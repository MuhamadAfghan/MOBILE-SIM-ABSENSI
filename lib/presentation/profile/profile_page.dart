import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../theme/navbar_bottom_page.dart';
import '../home/home_page.dart';
import '../roll_call/roll_call_page.dart';
import '../history/history_page.dart';
import 'controller/profile_controller.dart';
import 'models/profile_models.dart';
import '../login/login_page.dart'; // Pastikan import halaman LoginPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    // Tidak perlu panggil fetchStatistik di sini, biarkan controller yang handle
  }

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } else if (index == 1) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const RollCallPage()),
        (route) => false,
      );
    } else if (index == 2) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HistoryPage()),
        (route) => false,
      );
    } else if (index == 3) {
      // Stay on this page
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Avatar dengan background lingkaran besar
              Obx(() {
                final user = _profileController.user.value;
                final initials = _getInitials(user?.name ?? '-');
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: const Color(0xFFFDEEEE),
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 16),
              // Nama dan Mapel rata tengah
              Obx(() {
                final user = _profileController.user.value;
                return Column(
                  children: [
                    Text(
                      user?.name ?? '-',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      user?.mapel ?? '-',
                      style: const TextStyle(color: Colors.black54, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),
              // Statistik dalam card, rata tengah, jarak antar card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Obx(() {
                  if (_profileController.isLoading.value) {
                    return Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          6,
                          (index) => Padding(
                            padding: EdgeInsets.only(right: index < 5 ? 10 : 0),
                            child: _buildLoadingCard(),
                          ),
                        ),
                      ),
                    );
                  } else if (_profileController.error.value.isNotEmpty) {
                    return Center(child: Text(_profileController.error.value));
                  } else if (_profileController.statistik.value != null) {
                    final statistik = _profileController.statistik.value!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStatCard(
                              statistik.persentaseKehadiran != null
                                  ? '${statistik.persentaseKehadiran}%'
                                  : '-',
                              'Kehadiran'),
                            const SizedBox(width: 10),
                            _buildStatCard(
                              statistik.jumlahMasuk != null
                                  ? '${statistik.jumlahMasuk}'
                                  : '-',
                              'Hari Masuk'),
                            const SizedBox(width: 10),
                            _buildStatCard(
                              statistik.jumlahTelat != null
                                  ? '${statistik.jumlahTelat}'
                                  : '-',
                              'Jumlah Telat'),
                            const SizedBox(width: 10),
                            _buildStatCard(
                              statistik.jumlahTidakMasuk != null
                                  ? '${statistik.jumlahTidakMasuk}'
                                  : '-',
                              'Tidak Masuk'),
                            const SizedBox(width: 10),
                            _buildStatCard(
                              statistik.jumlahIzin != null
                                  ? '${statistik.jumlahIzin}'
                                  : '-',
                              'Izin'),
                            const SizedBox(width: 10),
                            _buildStatCard(
                              statistik.jumlahSakit != null
                                  ? '${statistik.jumlahSakit}'
                                  : '-',
                              'Sakit'),
                          ],
                        ),
                      ),
                    );
                  }
                  // Jika statistik null, tampilkan semua "-"
                  return Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatCard('-', 'Kehadiran'),
                        const SizedBox(width: 10),
                        _buildStatCard('-', 'Hari Masuk'),
                        const SizedBox(width: 10),
                        _buildStatCard('-', 'Jumlah Telat'),
                        const SizedBox(width: 10),
                        _buildStatCard('-', 'Tidak Masuk'),
                        const SizedBox(width: 10),
                        _buildStatCard('-', 'Izin'),
                        const SizedBox(width: 10),
                        _buildStatCard('-', 'Sakit'),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              // Informasi Personal card lebih rounded
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informasi Personal',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      Obx(() {
                        final user = _profileController.user.value;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(Icons.badge, user?.nip ?? '-'),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.email, user?.email ?? '-'),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.phone, user?.telepon ?? '-'),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.book, user?.mapel ?? '-'),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Aktivitas card lebih rounded
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Aktivitas',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      Obx(() {
                        final activity = _profileController.activity.value;
                        return Column(
                          children: [
                            _buildActivityRow(Icons.login, 'Masuk', 'Hari ini, ${activity?.formattedCheckIn ?? "--:--"}'),
                            _buildActivityRow(Icons.logout, 'Keluar', 'Hari ini, ${activity?.formattedCheckOut ?? "--:--"}'),
                            _buildActivityRow(Icons.warning_amber_rounded, 'Terlambat', activity?.formattedTerlambat ?? "Hari ini, -"),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Tombol Keluar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.exit_to_app),
                    label: const Text('Keluar'),
                    onPressed: () {
                      // TODO: Tambahkan logika logout jika perlu (misal hapus token)
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavbarBottomPage(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildStatCard(String? value, String label) {
    return Container(
      width: 80, // atur lebar sesuai kebutuhan desain
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            (value == null || value == '' || value == 'null') ? '-' : value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      width: 80, // samakan dengan _buildStatCard
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildActivityRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black54),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      // Ambil dua huruf pertama dari satu kata
      return parts[0].length >= 2
          ? parts[0].substring(0, 2).toUpperCase()
          : parts[0].toUpperCase();
    } else if (parts.length > 1) {
      // Ambil huruf pertama dari dua kata pertama
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return '';
  }
}