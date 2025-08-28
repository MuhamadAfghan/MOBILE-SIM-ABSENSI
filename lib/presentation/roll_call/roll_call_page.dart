import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:sim_absensi/widget/app_fonts_custom.dart';
import 'package:sim_absensi/widget/pop_up_custom.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 
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
import 'package:flutter_image_compress/flutter_image_compress.dart';

class RollCallPage extends StatefulWidget {
  const RollCallPage({Key? key}) : super(key: key);

  @override
  State<RollCallPage> createState() => _RollCallPageState();
}

class _RollCallPageState extends State<RollCallPage> {
  int _selectedIndex = 1;
  String? _selectedMainType; 

  
  String? _selectedAbsensiType;
  final TextEditingController _noteController = TextEditingController();
  bool _loadingSubmit = false;
  File? _pickedImage;
  RollCallController? _controller;
  String? _token;

  
  final TextEditingController _dateStartController = TextEditingController();
  final TextEditingController _dateEndController = TextEditingController();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

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

  
  Future<void> _submitAbsensi() async {
    if (_controller == null) {
      _controller?.showPopup(context, 'Token tidak ditemukan. Silakan login ulang.', backgroundColor: Color(0xFFFF6243));
      return;
    }
    setState(() {
      _loadingSubmit = true;
    });

    try {
      
      Position position = await _controller!.getCurrentLocation();

      
      String keterangan = _noteController.text.trim();
      if (keterangan.isEmpty) {
        if (_selectedMainType == "Kedatangan") {
          keterangan = _selectedAbsensiType == "Telat" ? "Telat" : "Tepat waktu";
        } else {
          keterangan = "Pulang tepat waktu";
        }
      }

      final req = RollCallRequest(
        latitude: 0, 
        longitude: 0, 
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
        String distanceInfo = resp.data['distance_from_office'] != null
            ? "${resp.data['distance_from_office']} meter"
            : '';
        _controller?.showPopup(context, resp.message, backgroundColor: Color(0xFF43FF62));
        
      } else if (resp != null) {
        _controller?.showPopup(context, resp.message, backgroundColor: Color(0xFFFF6243));
      } else {
        _controller?.showPopup(context, 'Gagal mengirim absensi!', backgroundColor: Color(0xFFFF6243));
      }
    } catch (e) {
      setState(() {
        _loadingSubmit = false;
      });
      _controller?.showPopup(context, 'Error: ${e.toString()}', backgroundColor: Color(0xFFFF6243));
    }
  }

  
  Future<void> _submitKepulanganLangsung() async {
    if (_controller == null) {
      _controller?.showPopup(context, 'Token tidak ditemukan. Silakan login ulang.', backgroundColor: Color(0xFFFF6243));
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
        latitude: 0, 
        longitude: 0, 
        type: "mobile",
        keterangan: keterangan,
      );
      RollCallResponse? resp = await _controller!.checkOut(req);

      setState(() {
        _loadingSubmit = false;
      });

      if (resp != null && resp.status == "success") {
        String locationInfo = resp.data['location'] ?? '';
        String distanceInfo = resp.data['distance_from_office'] != null
            ? "${resp.data['distance_from_office']} meter"
            : '';
        _controller?.showPopup(context, resp.message, backgroundColor: Color(0xFF43FF62));
        
      } else if (resp != null) {
        _controller?.showPopup(context, resp.message, backgroundColor: Color(0xFFFF6243));
      } else {
        _controller?.showPopup(context, 'Gagal mengirim absensi!', backgroundColor: Color(0xFFFF6243));
      }
    } catch (e) {
      setState(() {
        _loadingSubmit = false;
      });
      _controller?.showPopup(context, 'Error: ${e.toString()}', backgroundColor: Color(0xFFFF6243));
    }
  }

  
  Future<void> _submitAbsence() async {
    if (_controller == null) {
      _controller?.showPopup(context, 'Token tidak ditemukan. Silakan login ulang.', backgroundColor: Color(0xFFFF6243));
      return;
    }
    if (_selectedAbsensiType == null) {
      _controller?.showPopup(context, 'Pilih jenis absensi dulu', backgroundColor: Color(0xFFFF6243));
      return;
    }
    if ((_selectedAbsensiType == "Izin" || _selectedAbsensiType == "Sakit") &&
        (_dateStartController.text.isEmpty || _dateEndController.text.isEmpty)) {
      _controller?.showPopup(context, 'Tanggal mulai dan akhir wajib diisi', backgroundColor: Color(0xFFFF6243));
      return;
    }

    setState(() {
      _loadingSubmit = true;
    });

    try {
      final req = AbsenceRequest(
        dateStart: _dateStartController.text.trim(),
        dateEnd: _dateEndController.text.trim(),
        type: _selectedAbsensiType?.toLowerCase() ?? '',
        description: _noteController.text.trim(),
        
      );
      AbsenceResponse? resp = await _controller!.submitAbsence(req, attachment: _pickedImage);

      setState(() {
        _loadingSubmit = false;
      });

      if (resp != null && resp.status == "success") {
        _controller?.showPopup(context, 'Berhasil mengirim ${_selectedAbsensiType?.toLowerCase() ?? ''}', backgroundColor: Color(0xFF43FF62));
        
        setState(() {
          _dateStartController.clear();
          _dateEndController.clear();
          _noteController.clear();
          _pickedImage = null;
          _selectedAbsensiType = null;
          _selectedMainType = null;
          _selectedStartDate = null;
          _selectedEndDate = null;
        });
      } else if (resp != null) {
        _controller?.showPopup(context, resp.message, backgroundColor: Color(0xFFFF6243));
      } else {
        _controller?.showPopup(context, 'Gagal mengirim izin!', backgroundColor: Color(0xFFFF6243));
      }
    } catch (e) {
      setState(() {
        _loadingSubmit = false;
      });
      _controller?.showPopup(context, 'Error: ${e.toString()}', backgroundColor: Color(0xFFFF6243));
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
                title: const Text('Ambil Foto dari Kamera'),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    File original = File(picked.path);
                    File? compressed = await _compressImage(original);
                    final fileToUse = compressed ?? original;
                    final sizeInKB = await fileToUse.length() / 1024;
                    if (sizeInKB > 2048) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('File terlalu besar, maksimal 2MB')),
                      );
                      return;
                    }
                    setState(() {
                      _pickedImage = fileToUse;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () async {
                  Navigator.pop(context);
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    File original = File(picked.path);
                    File? compressed = await _compressImage(original);
                    final fileToUse = compressed ?? original;
                    final sizeInKB = await fileToUse.length() / 1024;
                    if (sizeInKB > 2048) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('File terlalu besar, maksimal 2MB')),
                      );
                      return;
                    }
                    setState(() {
                      _pickedImage = fileToUse;
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

  
  Future<void> _pickDate(TextEditingController controller, {DateTime? initialDate}) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
      if (controller == _dateStartController) {
        _selectedStartDate = picked;
      } else if (controller == _dateEndController) {
        _selectedEndDate = picked;
      }
    }
  }

  
  Future<File?> _compressImage(File file) async {
    final targetPath = file.path.replaceFirst('.jpg', '_compressed.jpg');
    var result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 70,
      minWidth: 800,
      minHeight: 800,
    );
    if (result != null && await result.length() > 1500 * 1024) {
      
      result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        quality: 50,
        minWidth: 640,
        minHeight: 640,
      );
    }
    print('Final compressed size: ${await result?.length()} bytes');
    return result != null ? File(result.path) : null;
  }

  @override
  Widget build(BuildContext context) {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
    
    final deviceTime = DateTime.now();
    final timeStr = DateFormat('HH:mm', 'id_ID').format(deviceTime);
    final dateStr = DateFormat('d MMMM yyyy', 'id_ID').format(deviceTime);

    return Scaffold(
      backgroundColor: const Color(0xFFE3F3FF),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                NavbarHeadPage(),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(18.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Form Absensi",
                                  style: AppFonts.bold(fontSize: 16.sp),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      timeStr,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    Text(
                                      dateStr,
                                      style: AppFonts.regular(fontSize: 10.sp, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),

                            
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
                                      padding: EdgeInsets.symmetric(vertical: 24.h),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: _selectedMainType == "Kedatangan"
                                              ? Color(0xFF3B5EFF)
                                              : Color(0xFFB6DFFF),
                                          width: 2.w,
                                        ),
                                        borderRadius: BorderRadius.circular(12.r),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.login, size: 36.sp, color: Colors.black),
                                          SizedBox(height: 8.h),
                                          Text(
                                            "Kedatangan",
                                            style: AppFonts.bold(fontSize: 16.sp, color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _submitKepulanganLangsung();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 24.h),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: _selectedMainType == "Kepulangan"
                                              ? Color(0xFF3B5EFF)
                                              : Color(0xFFB6DFFF),
                                          width: 2.w,
                                        ),
                                        borderRadius: BorderRadius.circular(12.r),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.logout, size: 36.sp, color: Colors.black),
                                          SizedBox(height: 8.h),
                                          Text(
                                            "Kepulangan",
                                            style: AppFonts.bold(fontSize: 16.sp, color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 18.h),

                            
                            if (_selectedMainType != null) ...[
                              Text(
                                "Jenis Absensi",
                                style: AppFonts.bold(fontSize: 12.sp),
                              ),
                              SizedBox(height: 10.h),
                              GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                crossAxisSpacing: 12.w,
                                mainAxisSpacing: 12.h,
                                physics: NeverScrollableScrollPhysics(),
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
                                  _AbsensiButton(
                                    icon: Icons.help_outline,
                                    label: "Tanpa Keterangan",
                                    selected: _selectedAbsensiType == "Tanpa Keterangan",
                                    onTap: () {
                                      setState(() {
                                        _selectedAbsensiType = "Tanpa Keterangan";
                                      });
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 18.h),

                              
                              if (_selectedAbsensiType == "Izin" ||
                                  _selectedAbsensiType == "Sakit" ||
                                  _selectedAbsensiType == "Tanpa Keterangan") ...[
                                Text(
                                  "Tanggal Mulai",
                                  style: AppFonts.bold(fontSize: 12.sp),
                                ),
                                SizedBox(height: 8.h),
                                GestureDetector(
                                  onTap: () => _pickDate(_dateStartController, initialDate: _selectedStartDate),
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: _dateStartController,
                                      decoration: InputDecoration(
                                        hintText: "YYYY-MM-DD",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        contentPadding: EdgeInsets.all(12.w),
                                        suffixIcon: Icon(Icons.calendar_today, size: 18.sp),
                                      ),
                                      style: AppFonts.regular(fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  "Tanggal Akhir",
                                  style: AppFonts.bold(fontSize: 12.sp),
                                ),
                                SizedBox(height: 8.h),
                                GestureDetector(
                                  onTap: () => _pickDate(_dateEndController, initialDate: _selectedEndDate),
                                  child: AbsorbPointer(
                                    child: TextField(
                                      controller: _dateEndController,
                                      decoration: InputDecoration(
                                        hintText: "YYYY-MM-DD",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        contentPadding: EdgeInsets.all(12.w),
                                        suffixIcon: Icon(Icons.calendar_today, size: 18.sp),
                                      ),
                                      style: AppFonts.regular(fontSize: 14.sp),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 18.h),
                              ],

                              
                              Text(
                                "Catatan (Opsional)",
                                style: AppFonts.bold(fontSize: 12.sp),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFB6DFFF)),
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: TextField(
                                  controller: _noteController,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    hintText: "Tambahkan catatan...",
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(12.w),
                                  ),
                                ),
                              ),
                              SizedBox(height: 18.h),

                              
                              if (_selectedAbsensiType != "Hadir") ...[
                                Text(
                                  "Bukti Absensi",
                                  style: AppFonts.bold(fontSize: 12.sp),
                                ),
                                SizedBox(height: 8.h),
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    width: double.infinity,
                                    height: 120.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Color(0xFFB6DFFF)),
                                      borderRadius: BorderRadius.circular(12.r),
                                      color: Color(0xFFF8FBFF),
                                    ),
                                    child: _pickedImage == null
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.camera_alt, size: 36.sp, color: Colors.black38),
                                              SizedBox(height: 8.h),
                                              Text(
                                                "Unggah Bukti",
                                                style: TextStyle(fontSize: 14.sp, color: Colors.black38),
                                              ),
                                            ],
                                          )
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(12.r),
                                            child: _pickedImage != null
                                                ? Image.file(
                                                    _pickedImage!,
                                                    width: double.infinity,
                                                    height: 120.h,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(),
                                          ),
                                  ),
                                ),
                                SizedBox(height: 24.h),
                              ],

                              
                              AppButtonCustom(
                                label: _loadingSubmit ? "Mengirim..." : "Kirim Absensi",
                                loading: _loadingSubmit,
                                onPressed: (_selectedAbsensiType != null && !_loadingSubmit)
                                    ? (
                                        (_selectedAbsensiType == "Izin" ||
                                         _selectedAbsensiType == "Sakit" ||
                                         _selectedAbsensiType == "Tanpa Keterangan")
                                          ? _submitAbsence
                                          : _submitAbsensi
                                      )
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
          ],
        ),
      ),
      bottomNavigationBar: NavbarBottomPage(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}


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
        side: BorderSide(color: selected ? Color(0xFF3B5EFF) : Color(0xFF6EC1FF), width: 2.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        backgroundColor: selected ? Color(0xFFE3F3FF) : Colors.white,
        padding: EdgeInsets.symmetric(vertical: 8.h),
      ),
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black, size: 28.sp),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppFonts.bold(fontSize: 14.sp, color: Colors.black),
          ),
        ],
      ),
    );
  }
}