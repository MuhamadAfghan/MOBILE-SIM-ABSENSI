import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/navbar_bottom_page.dart';
import '../../theme/navbar_head_page.dart';
import '../home/home_page.dart';
import '../roll_call/roll_call_page.dart';
import '../profile/profile_page.dart';
import '../../widget/app_fonts_custom.dart'; 
import '../../widget/pop_up_custom.dart';
import 'binding/history_binding.dart';
import 'controller/history_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _selectedIndex = 2;
  final HistoryController _controller = Get.put(HistoryController());
  final RxString _popupMessage = ''.obs; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchHistory(limit: 10);
    });
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
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) => Scaffold(
        backgroundColor: const Color(0xFFE3F3FF),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  NavbarHeadPage(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 16.w, top: 8.h),
                          child: Text(
                            'Riwayat Absen',
                            style: AppFonts.semiBold(fontSize: 20.sp),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Expanded(
                          child: Obx(() {
                            if (_controller.isLoading.value) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (_controller.error.isNotEmpty) {
                              return Center(child: Text(_controller.error.value, style: AppFonts.fonterror));
                            }
                            if (_controller.records.isEmpty) {
                              return const Center(child: Text('Tidak ada data.', style: TextStyle(fontFamily: AppFonts.poppins)));
                            }
                            return ListView.separated(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                              itemCount: _controller.records.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 0),
                              itemBuilder: (context, index) {
                                final absen = _controller.records[index];
                                final tgl = absen.date.split('-').length > 2 ? absen.date.split('-')[2] : '-';
                                final hari = absen.dayName.length >= 3 ? absen.dayName.substring(0, 3) : absen.dayName;
                                final masuk = (absen.checkInTime != null && absen.checkInTime!.length >= 5)
                                    ? absen.checkInTime!.substring(0, 5)
                                    : '--:--';
                                final keluar = (absen.checkOutTime != null && absen.checkOutTime!.length >= 5)
                                    ? absen.checkOutTime!.substring(0, 5)
                                    : '--:--';
                                return _buildAttendanceHistoryItem(
                                  tgl,
                                  hari,
                                  masuk,
                                  keluar,
                                  absen.location ?? '',
                                );
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Obx(() => _popupMessage.value.isNotEmpty
                  ? SafeArea(
                      bottom: true,
                      child: Positioned(
                        left: 16.w,
                        right: 16.w,
                        bottom: 16.h,
                        child: PopUpCustom(message: _popupMessage.value),
                      ),
                    )
                  : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavbarBottomPage(
          currentIndex: _selectedIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }

  void _showPopup(String message, {bool success = false}) {
    _popupMessage.value = (success ? '[SUCCESS] ' : '[ERROR] ') + message;
    Future.delayed(const Duration(seconds: 2), () {
      _popupMessage.value = '';
    });
  }

  Widget _buildAttendanceHistoryItem(String date, String day, String masuk, String keluar, String location) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          
          Container(
            width: 60.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: const Color(0xFF4F6CD2),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(date, style: AppFonts.bold(fontSize: 22.sp, color: Colors.white)),
                Text(day, style: AppFonts.semiBold(fontSize: 15.sp, color: Colors.white)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(masuk, style: AppFonts.bold(fontSize: 18.sp, color: Colors.black)),
                          SizedBox(height: 2.h),
                          Text('Jam Masuk', style: AppFonts.semiBold(fontSize: 12.sp, color: Color(0xFFBDBDBD))),
                        ],
                      ),
                      
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        width: 1.w,
                        height: 32.h,
                        color: const Color(0xFFE3E8F0),
                      ),
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(keluar, style: AppFonts.bold(fontSize: 18.sp, color: Color(0xFFBDBDBD))),
                          SizedBox(height: 2.h),
                          Text('Jam Keluar', style: AppFonts.semiBold(fontSize: 12.sp, color: Color(0xFFBDBDBD))),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16.sp, color: Colors.black),
                      SizedBox(width: 4.w),
                      Text(
                        location,
                        style: AppFonts.bold(fontSize: 13.sp, color: Colors.black),
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