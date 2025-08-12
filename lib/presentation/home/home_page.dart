import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/navbar_bottom_page.dart';
import '../../theme/navbar_head_page.dart';
import '../roll_call/roll_call_page.dart';
import '../history/history_page.dart';
import '../profile/profile_page.dart';
import '../../widget/app_fonts_custom.dart';
import 'controller/home_controller.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/HomePage';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final HomeController _controller = Get.put(HomeController());

  void _onNavTap(int index) {
    if (index == 0 && _selectedIndex != 0) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomePage.routeName,
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

  @override
  void initState() {
    super.initState();
    _controller.fetchSettings();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFE3F3FF),
        body: GetX<HomeController>(
          init: _controller,
          builder: (ctrl) {
            final isLoading = ctrl.isLoading.value;
            final settings = ctrl.settings.value;
            return isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                    NavbarHeadPage(),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Jadwal Kedatangan & Kepulangan
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Jadwal Kedatangan & Kepulangan',
                                      style: AppFonts.semiBold(fontSize: 16),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text('Masuk', style: AppFonts.regular(fontSize: 14, color: Colors.grey)),
                                            const SizedBox(height: 4),
                                            Text(
                                              settings?.mondayStartTime ?? '-',
                                              style: AppFonts.bold(fontSize: 28),
                                            ),
                                          ],
                                        ),
                                        // Garis vertikal tipis
                                        Container(
                                          width: 1,
                                          height: 40,
                                          color: const Color(0xFFBFD6F6),
                                        ),
                                        Column(
                                          children: [
                                            Text('Keluar', style: AppFonts.regular(fontSize: 14, color: Colors.grey)),
                                            const SizedBox(height: 4),
                                            Text(
                                              settings?.mondayEndTime ?? '-',
                                              style: AppFonts.bold(fontSize: 28),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Absen Masuk & Keluar
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFFE3E8F0), width: 1),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            (settings?.mondayStartTime != null && settings!.mondayStartTime.isNotEmpty)
                                                ? settings!.mondayStartTime
                                                : '-',
                                            style: AppFonts.bold(fontSize: 24, color: const Color(0xFF2563EB)),
                                          ),
                                          const SizedBox(height: 8),
                                          Text('Absen Masuk', style: AppFonts.bold(color: const Color(0xFF2563EB))),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFFE3E8F0), width: 1),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            (settings?.mondayEndTime != null && settings!.mondayEndTime.isNotEmpty)
                                                ? settings!.mondayEndTime
                                                : '-',
                                            style: AppFonts.bold(fontSize: 24, color: const Color(0xFF2563EB)),
                                          ),
                                          const SizedBox(height: 8),
                                          Text('Absen Keluar', style: AppFonts.bold(color: const Color(0xFF2563EB))),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Lokasi Kantor
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFE3E8F0), width: 1),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Lokasi Kantor', style: AppFonts.semiBold(fontSize: 16)),
                                    const SizedBox(height: 8),
                                    Text(
                                      settings?.locationName ??
                                          'Raya Wangun, RT.01/RW.06, Sindangsari, Kec. Bogor Tim.,\nKota Bogor, Jawa Barat 16146',
                                      style: AppFonts.regular(fontSize: 14, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Dalam Radius Kantor',
                                          style: AppFonts.bold(color: Colors.black87),
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Text('Lihat map', style: AppFonts.bold(color: Color(0xFF2563EB))),
                                        ),
                                      ],
                                    ),
                                    if (settings != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          'Lat: ${settings!.latitude}, Long: ${settings!.longitude}, Radius: ${settings!.radius}m',
                                          style: AppFonts.regular(fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Riwayat Kehadiran
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Riwt Kehadiran', style: AppFonts.semiBold(fontSize: 16)),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text('Lihat Selengkapnya', style: AppFonts.bold(fontSize: 12, color: Color(0xFF2563EB))),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // List Riwayat
                              _buildAttendanceHistoryItem('05', 'Sen', '06.45', '16:10', 'SMK WIKRAMA, KOTA BOGOR'),
                              const SizedBox(height: 12),
                              _buildAttendanceHistoryItem('04', 'Min', '07.00', '16:00', 'SMK WIKRAMA, KOTA BOGOR'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
          },
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

  Widget _buildAttendanceHistoryItem(String date, String day, String masuk, String keluar, String location) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Tanggal & Hari
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF4F6CD2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(date, style: AppFonts.bold(fontSize: 22, color: Colors.white)),
                Text(day, style: AppFonts.semiBold(fontSize: 15, color: Colors.white)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Jam Masuk
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(masuk, style: AppFonts.bold(fontSize: 18, color: Colors.black)),
                          const SizedBox(height: 2),
                          Text('Jam Masuk', style: AppFonts.semiBold(fontSize: 12, color: Color(0xFFBDBDBD))),
                        ],
                      ),
                      // Garis vertikal tipis
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: 1,
                        height: 32,
                        color: const Color(0xFFE3E8F0),
                      ),
                      // Jam Keluar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(keluar, style: AppFonts.bold(fontSize: 18, color: Color(0xFFBDBDBD))),
                          const SizedBox(height: 2),
                          Text('Jam Keluar', style: AppFonts.semiBold(fontSize: 12, color: Color(0xFFBDBDBD))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.black),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: AppFonts.bold(fontSize: 13, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}