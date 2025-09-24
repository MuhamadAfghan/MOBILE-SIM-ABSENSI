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

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);

  final HistoryController _controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    _controller.selectedIndex.value = 2; // Tambahkan ini agar navbar berubah ke History
    _controller.reloadHistory(); // Reload otomatis setiap kali halaman History dibuka
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
                  SizedBox(height: 0),
                ],
              ),
              Positioned(
                top: 120.h,
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          itemCount: _controller.getDisplayRecords().length,
                          separatorBuilder: (_, __) => const SizedBox(height: 0),
                          itemBuilder: (context, index) {
                            final display = _controller.getDisplayRecords()[index];
                            return _buildAttendanceHistoryItem(
                              display.date,
                              display.day,
                              display.checkIn,
                              display.checkOut,
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Obx(() => _controller.popupMessage.isNotEmpty
                  ? SafeArea(
                      bottom: true,
                      child: Positioned(
                        left: 16.w,
                        right: 16.w,
                        bottom: 16.h,
                        child: PopUpCustom(message: _controller.popupMessage.value),
                      ),
                    )
                  : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Obx(() => NavbarBottomPage(
          currentIndex: _controller.selectedIndex.value,
          onTap: _controller.navigateTo,
        )),
      ),
    );
  }

  Widget _buildAttendanceHistoryItem(String date, String day, String masuk, String keluar) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
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
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(masuk, style: AppFonts.bold(fontSize: 18.sp, color: Color(0xFF33353C))),
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
                        Text(keluar, style: AppFonts.bold(fontSize: 18.sp, color: Color(0xFF33353C))),
                        SizedBox(height: 2.h),
                        Text('Jam Keluar', style: AppFonts.semiBold(fontSize: 12.sp, color: Color(0xFFBDBDBD))),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}