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
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final HomeController _controller = Get.put(HomeController());
  final HistoryController _historyController = Get.put(HistoryController());
  final RxString _popupMessage = ''.obs; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchSettings();
      _controller.fetchTodayStatus();
      _historyController.fetchHistory(limit: 3);
    });
  }

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
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: GetX<HomeController>(
                      init: _controller,
                      builder: (ctrl) {
                        final isLoading = ctrl.isLoading.value;
                        final settings = ctrl.settings.value;
                        print("settings = ${ctrl.settings.value}");
                        print("history records = ${_historyController.records.length}");
                        return isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                children: [
                                  NavbarHeadPage(),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      padding: EdgeInsets.all(16.w),
                                      child: Column(
                                        children: [
                                          
                                          Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(20.w),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(255, 255, 255, 255),
                                              borderRadius: BorderRadius.circular(12.r),
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
                                          ),
                                          SizedBox(height: 16.h),
                                          
                                          Obx(() {
                                            if (ctrl.isTodayStatusLoading.value) {
                                              return const Center(child: CircularProgressIndicator());
                                            }
                                            final today = ctrl.todayStatus.value;
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
                                                    height: 160.h,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(12.r),
                                                      border: Border.all(color: const Color(0xFFE3E8F0), width: 1.w),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(16.w),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundColor: Color(0xFF4F6CD2),
                                                                radius: 24.r,
                                                                child: Icon(Icons.arrow_back, color: Colors.white, size: 28.sp),
                                                              ),
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
                                                            style: AppFonts.bold(fontSize: 27.sp, color: Colors.black87),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 16.w),
                                                Expanded(
                                                  child: Container(
                                                    height: 160.h,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(12.r),
                                                      border: Border.all(color: const Color(0xFFE3E8F0), width: 1.w),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(16.w),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundColor: Color(0xFF4F6CD2),
                                                                radius: 24.r,
                                                                child: Icon(Icons.arrow_forward, color: Colors.white, size: 28.sp),
                                                              ),
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
                                                            style: AppFonts.bold(fontSize: 27.sp, color: Colors.black87),
                                                          ),
                                                        ],
                                                      ),
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
                                                  settings?.locationName ??
                                                      'Raya Wangun, RT.01/RW.06, Sindangsari, Kec. Bogor Tim.,\nKota Bogor, Jawa Barat 16146',
                                                  style: AppFonts.regular(fontSize: 14.sp, color: Colors.grey),
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
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(builder: (_) => const HistoryPage()),
                                                    (route) => false,
                                                  );
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
                                              children: _historyController.records
                                                  .take(3)
                                                  .map((absen) => _buildAttendanceHistoryItem(
                                                        absen.date.split('-').length > 2 ? absen.date.split('-')[2] : '-',
                                                        absen.dayName.length >= 3 ? absen.dayName.substring(0, 3) : absen.dayName,
                                                        (absen.checkInTime != null && absen.checkInTime!.length >= 5) ? absen.checkInTime!.substring(0, 5) : '--:--',
                                                        (absen.checkOutTime != null && absen.checkOutTime!.length >= 5) ? absen.checkOutTime!.substring(0, 5) : '--:--',
                                                        absen.location ?? '',
                                                      ))
                                                  .toList(),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                      },
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