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
          NavbarHeadPage(),
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), // lebih kecil
                      itemCount: _absenList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 0),
                      itemBuilder: (context, index) {
                        final absen = _absenList[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10), // lebih kecil
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F7FF),
                            borderRadius: BorderRadius.circular(16), // lebih kecil
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 6, // lebih kecil
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12), // lebih kecil
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Date & Day
                              Container(
                                width: 48, // lebih kecil
                                height: 48, // lebih kecil
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4B5ED6),
                                  borderRadius: BorderRadius.circular(12), // lebih kecil
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      absen["tgl"]!,
                                      style: AppFonts.bold(fontSize: 20, color: Colors.white), // lebih kecil
                                    ),
                                    Text(
                                      absen["hari"]!,
                                      style: AppFonts.regular(fontSize: 10, color: Colors.white), // lebih kecil
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12), // lebih kecil
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
                                              style: AppFonts.bold(fontSize: 10, color: Colors.black), // lebih kecil
                                            ),
                                            const SizedBox(height: 1), // lebih kecil
                                            Text(
                                              "Jam Masuk",
                                              style: AppFonts.semiBold(fontSize: 10, color: Color(0xFFD1D1D1)), // lebih kecil
                                            ),
                                          ],
                                        ),
                                        // Garis vertikal
                                        Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 10), // lebih kecil
                                          width: 1,
                                          height: 24, // lebih kecil
                                          color: const Color(0xFFD1D1D1),
                                        ),
                                        // Jam Keluar
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              absen["keluar"]!,
                                              style: AppFonts.bold(fontSize: 10, color: Colors.black), // lebih kecil
                                            ),
                                            const SizedBox(height: 1), // lebih kecil
                                            Text(
                                              "Jam Keluar",
                                              style: AppFonts.semiBold(fontSize: 10, color: Color(0xFFD1D1D1)), // lebih kecil
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8), // lebih kecil
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on, size: 14, color: Colors.black), // lebih kecil
                                        const SizedBox(width: 4), // lebih kecil
                                        Text(
                                          "SMK WIKRAMA, KOTA BOGOR",
                                          style: AppFonts.bold(fontSize: 10, color: Colors.black), // lebih kecil
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