import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../theme/navbar_bottom_page.dart';
import '../../theme/navbar_head_page.dart';
import '../home/home_page.dart';
import '../roll_call/roll_call_page.dart';
import '../profile/profile_page.dart';
import '../../widget/app_fonts_custom.dart'; // Tambahkan ini

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _selectedIndex = 2;

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
      // Stay on this page
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

  // Dummy data for demonstration
  final List<Map<String, String>> _absenList = [
    {"tgl": "05", "hari": "Sen", "masuk": "06.45", "keluar": "16:10"},
    {"tgl": "06", "hari": "Sel", "masuk": "06.45", "keluar": "16:10"},
    {"tgl": "07", "hari": "Rab", "masuk": "06.45", "keluar": "16:10"},
    {"tgl": "08", "hari": "Kam", "masuk": "06.45", "keluar": "16:10"},
    {"tgl": "09", "hari": "Kam", "masuk": "06.45", "keluar": "16:10"},
    {"tgl": "10", "hari": "Jum", "masuk": "06.45", "keluar": "16:10"},
    {"tgl": "11", "hari": "Sab", "masuk": "06.45", "keluar": "16:10"},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFE3F3FF),
        body: Column(
          children: [
            const NavbarHeadPage(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: Text(
                      'Riwayat Absen',
                      style: AppFonts.semiBold(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      itemCount: _absenList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 0),
                      itemBuilder: (context, index) {
                        final absen = _absenList[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F7FF),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date & Day
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4B5ED6),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      absen["tgl"]!,
                                      style: AppFonts.bold(fontSize: 32, color: Colors.white),
                                    ),
                                    Text(
                                      absen["hari"]!,
                                      style: AppFonts.regular(fontSize: 14, color: Colors.white), // Ubah fontSize dari 20 ke 14
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              // Jam Masuk & Keluar
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // Jam Masuk
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              absen["masuk"]!,
                                              style: AppFonts.bold(fontSize: 12, color: Colors.black),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "Jam Masuk",
                                              style: AppFonts.semiBold(fontSize: 12, color: Color(0xFFD1D1D1)),
                                            ),
                                          ],
                                        ),
                                        // Garis vertikal
                                        Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 18),
                                          width: 1,
                                          height: 36,
                                          color: const Color(0xFFD1D1D1),
                                        ),
                                        // Jam Keluar
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              absen["keluar"]!,
                                              style: AppFonts.bold(fontSize: 12, color: Colors.black),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              "Jam Keluar",
                                              style: AppFonts.semiBold(fontSize: 12, color: Color(0xFFD1D1D1)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 20, color: Colors.black),
                                        const SizedBox(width: 6),
                                        Text(
                                          "SMK WIKRAMA, KOTA BOGOR",
                                          style: AppFonts.bold(fontSize: 12, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: NavbarBottomPage(
            currentIndex: _selectedIndex,
            onTap: _onNavTap,
          ),
        ),
      ),
    );
  }
}