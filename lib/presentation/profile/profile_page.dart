import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../theme/navbar_bottom_page.dart';
import '../home/home_page.dart';
import '../roll_call/roll_call_page.dart';
import '../history/history_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;

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
              Stack(
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
                  const CircleAvatar(
                    radius: 55,
                    backgroundColor: Color(0xFFFDEEEE),
                    // Foto profil bisa diganti di sini
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Nama dan Mapel rata tengah
              const Text(
                'MRS. Sity Nurhaliza',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const Text(
                'Matematika',
                style: TextStyle(color: Colors.black54, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Statistik dalam card, rata tengah, jarak antar card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    _buildStatCard('95%', 'Kehadiran'),
                    const SizedBox(width: 10),
                    _buildStatCard('25', 'Hari kerja'),
                    const SizedBox(width: 10),
                    _buildStatCard('2', 'Jumlah Telat'),
                  ],
                ),
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
                      _buildInfoRow(Icons.badge, '12345678901112131415161718'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.email, 'sitinurhaliza@smkwikrama.sch.id'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.phone, '0812345678910'),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.book, 'Matematika'),
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
                      _buildActivityRow(Icons.login, 'Masuk', 'Hari ini, 07:45'),
                      _buildActivityRow(Icons.logout, 'Keluar', 'Hari ini, --:--'),
                      _buildActivityRow(Icons.warning_amber_rounded, 'Terlambat', 'Hari ini, 07:51'),
                    ],
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

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
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
}