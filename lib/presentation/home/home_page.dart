import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/navbar_bottom_page.dart';
import '../../theme/navbar_head_page.dart';
import '../roll_call/roll_call_page.dart';
import '../history/history_page.dart';
import '../profile/profile_page.dart';
import '../../widget/app_fonts_custom.dart';
import 'controller/home_controller.dart';
import '../history/controller/history_controller.dart';
import '../../widget/pop_up_custom.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/HomePage';
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = Get.put(HomeController());
  final HistoryController _historyController = Get.put(HistoryController());

  @override
  void initState() {
    super.initState();
    _controller.selectedIndex.value = 0; // Tambahkan ini agar navbar berubah ke Home
    _controller.loadSettings();

    // Reload otomatis setiap kali halaman Home dibuka
    _controller.reloadHomeData();
    _historyController.reloadHistory();

    // Cek jika ada pesan sukses dari login
    final args = Get.arguments;
    if (args != null && args['successMessage'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.showPopup(args['successMessage'], success: true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    final settings = _controller.settings.value;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) => Scaffold(
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
                  child: Column(
                    children: [
                      // Hapus Tombol reload
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     IconButton(
                      //       icon: Icon(Icons.refresh, color: Colors.blue),
                      //       onPressed: () async {
                      //         await _controller.reloadHomeData();
                      //         await _historyController.reloadHistory();
                      //       },
                      //     ),
                      //   ],
                      // ),
                      // Ubah bagian jadwal jadi Obx agar reload otomatis
                      Obx(() {
                        final settings = _controller.settings.value;
                        return Container(
                          width: double.infinity,
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
                          child: Column(
                            children: [
                              Text(
                                'Jadwal Kedatangan & Kepulangan',
                                style: AppFonts.semiBold(fontSize: 16.sp),
                              ),
                              SizedBox(height: 16.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text('Masuk', style: AppFonts.regular(fontSize: 14.sp, color: Colors.grey)),
                                      SizedBox(height: 4.h),
                                      Text(
                                        settings?.mondayStartTime ?? '-', 
                                        style: AppFonts.bold(fontSize: 20.sp),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 1.w,
                                    height: 40.h,
                                    color: const Color(0xFFBFD6F6),
                                  ),
                                  Column(
                                    children: [
                                      Text('Keluar', style: AppFonts.regular(fontSize: 14.sp, color: Colors.grey)),
                                      SizedBox(height: 4.h),
                                      Text(
                                        settings?.mondayEndTime ?? '-', 
                                        style: AppFonts.bold(fontSize: 20.sp),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(height: 16.h),
                      
                      Obx(() {
                        if (_controller.isTodayStatusLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final today = _controller.todayStatus.value;
                        String checkIn = (today?.statusData?.checkInTime != null && today!.statusData!.checkInTime!.length >= 5)
                            ? today.statusData!.checkInTime!.substring(0, 5)
                            : '--:--';
                        String checkOut = (today?.statusData?.checkOutTime != null && today!.statusData!.checkOutTime!.length >= 5)
                            ? today.statusData!.checkOutTime!.substring(0, 5)
                            : '--:--';
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 150.h,
                                margin: EdgeInsets.only(right: 8.w),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset('assets/images/panah_bawah.png', width: 47.w, height: 47.w, fit: BoxFit.contain),
                                        SizedBox(width: 8.w),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Masuk', style: AppFonts.bold(fontSize: 12.sp)),
                                            Text('Pagi', style: AppFonts.regular(fontSize: 10.sp, color: Colors.grey)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      checkIn,
                                      style: AppFonts.bold(fontSize: 23.sp, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 150.h,
                                margin: EdgeInsets.only(left: 8.w),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset('assets/images/panah_atas.png', width: 47.w, height: 47.w, fit: BoxFit.contain),
                                        SizedBox(width: 8.w),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Keluar', style: AppFonts.bold(fontSize: 12.sp)),
                                            Text('Sore', style: AppFonts.regular(fontSize: 10.sp, color: Colors.grey)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      checkOut,
                                      style: AppFonts.bold(fontSize: 23.sp, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: 16.h),
                      
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: const Color(0xFFE3E8F0), width: 1.w),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Lokasi Kantor', style: AppFonts.semiBold(fontSize: 16.sp)),
                            SizedBox(height: 8.h),
                            Text(
                                  'Raya Wangun, RT.01/RW.06, Sindangsari, Kec. Bogor Timur,\nKota Bogor, Jawa Barat 16146',
                              style: AppFonts.regular(fontSize: 12.sp, color: Colors.grey),
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Container(
                                  width: 10.w,
                                  height: 10.h,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Dalam Radius Kantor',
                                  style: AppFonts.bold(color: Colors.black87),
                                ),
                                const Spacer(),
                              ],
                            ),
                            if (settings != null)
                              Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Text(
                                  'Lat: ${settings!.latitude}, Long: ${settings!.longitude}, Radius: ${settings!.radius}m',
                                  style: AppFonts.regular(fontSize: 12.sp, color: Colors.grey),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Riwayat Kehadiran', style: AppFonts.semiBold(fontSize: 16.sp)),
                          TextButton(
                            onPressed: () {
                              _controller.navigateTo(context, 2);
                            },
                            child: Text('Lihat Selengkapnya', style: AppFonts.bold(fontSize: 12.sp, color: Color(0xFF2563EB))),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      
                      Obx(() {
                        if (_historyController.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (_historyController.error.isNotEmpty) {
                          return Text(_historyController.error.value, style: AppFonts.fonterror);
                        }
                        if (_historyController.records.isEmpty) {
                          return const Text('Tidak ada data riwayat.', style: TextStyle(color: Colors.grey, fontFamily: AppFonts.poppins));
                        }
                        return Column(
                          children: _historyController.getDisplayRecords()
                              .take(3)
                              .map((display) => _buildAttendanceHistoryItem(
                                    display.date,
                                    display.day,
                                    display.checkIn,
                                    display.checkOut,
                                  ))
                              .toList(),
                        );
                      }),
                    ],
                  ),
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
          onTap: (index) => _controller.navigateTo(context, index),
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
        color: const Color(0xFFFFFFFF),
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