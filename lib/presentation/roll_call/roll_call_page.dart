import 'package:flutter/material.dart';
import '../history/history_page.dart';
import '../profile/profile_page.dart';
import '../home/home_page.dart';
import '../../theme/navbar_bottom_page.dart';

class RollCallPage extends StatelessWidget {
  const RollCallPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 1;

    return Scaffold(
      backgroundColor: const Color(0xFF6EC1FF),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      body: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.person, color: Color(0xFF6EC1FF)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Hadir.in",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Kamis, 15 Februari 2025",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.notifications_none, color: Colors.white),
              ],
            ),
          ),

          // Konten utama
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
                            children: const [
                              Text(
                                "06.45",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "8 Januari 2025",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      const Text(
                        "Jenis Absensi",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Jenis Absensi Buttons
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 2.2,
                        children: const [
                          _AbsensiButton(icon: Icons.login, label: "Hadir"),
                          _AbsensiButton(icon: Icons.access_time, label: "Telat"),
                          _AbsensiButton(icon: Icons.assignment_ind_outlined, label: "Izin"),
                          _AbsensiButton(icon: Icons.thermostat_outlined, label: "Sakit"),
                        ],
                      ),
                      const SizedBox(height: 18),

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
                        child: const TextField(
                          maxLines: 4,
                          decoration: InputDecoration(
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

                      Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFB6DFFF)),
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFFF8FBFF),
                        ),
                        child: Column(
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
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Navigation
          NavbarBottomPage(
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              } else if (index == 2) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                  (route) => false,
                );
              } else if (index == 3) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                  (route) => false,
                );
              }
              // index 1 (RollCallPage) stay here
            },
          ),
        ],
      ),
    );
  }
}

class _AbsensiButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AbsensiButton({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF6EC1FF)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      onPressed: () {},
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
