import 'package:flutter/material.dart';
import '../../theme/navbar_bottom_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3FF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Avatar
            const CircleAvatar(
              radius: 55,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 52,
                backgroundColor: Color(0xFFFDEEEE),
                // Foto profil bisa diganti di sini
              ),
            ),
            const SizedBox(height: 16),
            // Nama dan Mapel
            const Text(
              'MRS. Sity Nurhaliza',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Text(
              'Matematika',
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
            const SizedBox(height: 20),
            // Statistik
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
            // Informasi Personal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
            // Aktivitas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
          ],
        ),
      ),
      bottomNavigationBar: NavbarBottomPage(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index != 3) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
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
