import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../theme/navbar_bottom_page.dart';
import '../../theme/navbar_head_page.dart';
import '../history/history_page.dart';
import '../profile/profile_page.dart';
import '../home/home_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../widget/app_button_send_custom.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'controller/roll_call_controller.dart';
import 'models/roll_call_models.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class RollCallPage extends StatefulWidget {
  const RollCallPage({Key? key}) : super(key: key);

  @override
  State<RollCallPage> createState() => _RollCallPageState();
}

class _RollCallPageState extends State<RollCallPage> {
  int _selectedIndex = 1;
  String? _selectedMainType; // "Kedatangan" atau "Kepulangan"

  // Tambahkan state untuk form
  String? _selectedAbsensiType;
  final TextEditingController _noteController = TextEditingController();
  bool _loadingSubmit = false;
  File? _pickedImage;
  RollCallController? _controller;
  String? _token;

  @override
  void initState() {
    super.initState();
    _initToken();
  }

  Future<void> _initToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
      if (_token != null) {
        _controller = RollCallController(token: _token!);
      }
    });
  }

  // Fungsi submit absensi ke API
  Future<void> _submitAbsensi() async {
    if (_controller == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token tidak ditemukan. Silakan login ulang.')),
      );
      return;
    }
    setState(() {
      _loadingSubmit = true;
    });

    try {
      // Ambil lokasi
      Position position = await _controller!.getCurrentLocation();

      // Keterangan
      String keterangan = _noteController.text.trim();
      if (keterangan.isEmpty) {
        if (_selectedMainType == "Kedatangan") {
          keterangan = _selectedAbsensiType == "Telat" ? "Telat" : "Tepat waktu";
        } else {
          keterangan = "Pulang tepat waktu";
        }
      }

      final req = RollCallRequest(
        latitude: position.latitude,
        longitude: position.longitude,
        type: "mobile",
        keterangan: keterangan,
      );

      RollCallResponse? resp;
      if (_selectedMainType == "Kedatangan") {
        resp = await _controller!.checkIn(req);
      } else {
        resp = await _controller!.checkOut(req);
      }

      setState(() {
        _loadingSubmit = false;
      });

      if (resp != null && resp.status == "success") {
        String locationInfo = resp.data['location'] ?? '';
        String distanceInfo = resp.data['distance_from_office'] ?? '';
        print('Backend message: ${resp.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${resp.message}\nLokasi: $locationInfo\nJarak: $distanceInfo',
            ),
          ),
        );
      } else if (resp != null) {
        print('Backend error message: ${resp.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resp.message)),
        );
      } else {
        print('Backend error: Gagal mengirim absensi!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim absensi!')),
        );
      }
    } catch (e) {
      setState(() {
        _loadingSubmit = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Tambahkan fungsi untuk submit kepulangan langsung
  Future<void> _submitKepulanganLangsung() async {
    if (_controller == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token tidak ditemukan. Silakan login ulang.')),
      );
      return;
    }
    setState(() {
      _loadingSubmit = true;
      _selectedMainType = "Kepulangan";
      _selectedAbsensiType = "Hadir";
    });

    try {
      Position position = await _controller!.getCurrentLocation();
      String keterangan = _noteController.text.trim();
      if (keterangan.isEmpty) {
        keterangan = "Pulang tepat waktu";
      }
      final req = RollCallRequest(
        latitude: position.latitude,
        longitude: position.longitude,
        type: "mobile",
        keterangan: keterangan,
      );
      RollCallResponse? resp = await _controller!.checkOut(req);

      setState(() {
        _loadingSubmit = false;
      });

      if (resp != null && resp.status == "success") {
        String locationInfo = resp.data['location'] ?? '';
        String distanceInfo = resp.data['distance_from_office'] ?? '';
        print('Backend message: ${resp.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${resp.message}\nLokasi: $locationInfo\nJarak: $distanceInfo',
            ),
          ),
        );
      } else if (resp != null) {
        print('Backend error message: ${resp.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resp.message)),
        );
      } else {
        print('Backend error: Gagal mengirim absensi!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim absensi!')),
        );
      }
    } catch (e) {
      setState(() {
        _loadingSubmit = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } else if (index == 1) {
      // Stay on this page
    } else if (index == 2) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HistoryPage()),
        (route) => false,
      );
    } else if (index == 3) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
        (route) => false,
      );
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    setState(() {
                      _pickedImage = File(picked.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    setState(() {
                      _pickedImage = File(picked.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Waktu Indonesia Barat (WIB) - Jakarta
    final nowUtc = DateTime.now().toUtc();
    final jakartaTime = nowUtc.add(const Duration(hours: 7));
    final timeStr = DateFormat('HH:mm', 'id_ID').format(jakartaTime);
    final dateStr = DateFormat('d MMMM yyyy', 'id_ID').format(jakartaTime);

    return Scaffold(
      backgroundColor: const Color(0xFFE3F3FF),
      body: Column(
        children: [
          NavbarHeadPage(),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form Absensi Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Form Absensi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                timeStr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                dateStr,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Card Pilihan Kedatangan & Kepulangan
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedMainType = "Kedatangan";
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _selectedMainType == "Kedatangan"
                                        ? Color(0xFF3B5EFF)
                                        : Color(0xFFB6DFFF),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.login, size: 36, color: Colors.black),
                                    SizedBox(height: 8),
                                    Text(
                                      "Kedatangan",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _submitKepulanganLangsung();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _selectedMainType == "Kepulangan"
                                        ? Color(0xFF3B5EFF)
                                        : Color(0xFFB6DFFF),
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.logout, size: 36, color: Colors.black),
                                    SizedBox(height: 8),
                                    Text(
                                      "Kepulangan",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Tampilkan form absensi jika sudah memilih jenis utama
                      if (_selectedMainType != null) ...[
                        const Text(
                          "Jenis Absensi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 2.2,
                          children: [
                            _AbsensiButton(
                              icon: Icons.login,
                              label: "Hadir",
                              selected: _selectedAbsensiType == "Hadir",
                              onTap: () {
                                setState(() {
                                  _selectedAbsensiType = "Hadir";
                                });
                              },
                            ),
                            _AbsensiButton(
                              icon: Icons.access_time,
                              label: "Telat",
                              selected: _selectedAbsensiType == "Telat",
                              onTap: () {
                                setState(() {
                                  _selectedAbsensiType = "Telat";
                                });
                              },
                            ),
                            _AbsensiButton(
                              icon: Icons.assignment_ind_outlined,
                              label: "Izin",
                              selected: _selectedAbsensiType == "Izin",
                              onTap: () {
                                setState(() {
                                  _selectedAbsensiType = "Izin";
                                });
                              },
                            ),
                            _AbsensiButton(
                              icon: Icons.thermostat_outlined,
                              label: "Sakit",
                              selected: _selectedAbsensiType == "Sakit",
                              onTap: () {
                                setState(() {
                                  _selectedAbsensiType = "Sakit";
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),

                        // Catatan & upload bukti selalu tampil untuk semua jenis absensi
                        const Text(
                          "Catatan (Opsional)",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFB6DFFF)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _noteController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: "Tambahkan catatan...",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          "Bukti Absensi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFFB6DFFF)),
                              borderRadius: BorderRadius.circular(12),
                              color: const Color(0xFFF8FBFF),
                            ),
                            child: _pickedImage == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.camera_alt, size: 36, color: Colors.black38),
                                      SizedBox(height: 8),
                                      Text(
                                        "Unggah Bukti",
                                        style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _pickedImage!,
                                      width: double.infinity,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Tombol submit tetap tampil
                        AppButtonCustom(
                          label: _loadingSubmit ? "Mengirim..." : "Kirim Absensi",
                          loading: _loadingSubmit,
                          onPressed: (_selectedAbsensiType != null && !_loadingSubmit)
                              ? _submitAbsensi
                              : null,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavbarBottomPage(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// Update _AbsensiButton agar bisa dipilih dan ada onTap
class _AbsensiButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _AbsensiButton({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: selected ? Color(0xFF3B5EFF) : Color(0xFF6EC1FF), width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: selected ? Color(0xFFE3F3FF) : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}