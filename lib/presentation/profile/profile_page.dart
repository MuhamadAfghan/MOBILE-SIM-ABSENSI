import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get/get.dart';
import 'package:sim_absensi/widget/app_fonts_custom.dart';
import 'package:sim_absensi/widget/pop_up_custom.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../theme/navbar_bottom_page.dart';
import '../home/home_page.dart';
import '../roll_call/roll_call_page.dart';
import '../history/history_page.dart';
import 'controller/profile_controller.dart';
import '../login/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;
  final ProfileController _profileController = Get.put(ProfileController());
  final RxString _popupMessage = ''.obs;

  @override
  void initState() {
    super.initState();
    
    _profileController.reloadUserFromPrefs(); 
  }

  
  void _onNavTap(int index) {
    Widget page;
    switch (index) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const RollCallPage();
        break;
      case 2:
        page = const HistoryPage();
        break;
      default:
        page = const ProfilePage();
        break;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );

    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3FF),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                
                Obx(() => _popupMessage.value.isNotEmpty
                    ? SafeArea(
                        bottom: true,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          child: _popupMessage.value.startsWith('[SUCCESS]')
                              ? PopUpSuccess(message: _popupMessage.value.replaceFirst('[SUCCESS]', '').trim())
                              : PopUpError(message: _popupMessage.value.replaceFirst('[ERROR]', '').trim()),
                        ),
                      )
                    : const SizedBox.shrink()),

                
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 24.h),
                        
                        Obx(() {
                          final user = _profileController.user.value;
                          final initials = _getInitials(user?.name ?? '-');
                          return Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 130.w,
                                    height: 130.w,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 55.r,
                                    backgroundColor: const Color(0xFFFDEEEE),
                                    child: Text(
                                      initials,
                                      style: AppFonts.bold(
                                          fontSize: 36.sp, color: Colors.black54),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                user?.name ?? '-',
                                style: AppFonts.bold(fontSize: 20.sp),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                user?.mapel ?? '-',
                                style: AppFonts.regular(
                                    fontSize: 15.sp, color: Colors.black54),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        }),
                        _buildEmptyStat(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Informasi Personal', style: AppFonts.bold()),
                                Divider(),
                                Obx(() {
                                  final u = _profileController.user.value;
                                  return Column(
                                    children: [
                                      _buildInfoRow(Icons.badge, 'NIP', u?.nip ?? '-'),
                                      SizedBox(height: 8.h),
                                      _buildInfoRow(Icons.email, 'Email', u?.email ?? '-'),
                                      SizedBox(height: 8.h),
                                      _buildInfoRow(Icons.phone, 'Telepon', u?.telepon ?? '-'),
                                      SizedBox(height: 8.h),
                                      _buildInfoRow(Icons.book, 'Mata Pelajaran', u?.mapel ?? '-'),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Aktivitas', style: AppFonts.bold()),
                                Divider(),
                                Obx(() {
                                  final a = _profileController.activity.value;
                                  return Column(
                                    children: [
                                      _buildActivityRow(Icons.login, 'Masuk', a?.formattedCheckIn ?? "--:--"),
                                      _buildActivityRow(Icons.logout, 'Keluar', a?.formattedCheckOut ?? "--:--"),
                                      _buildActivityRow(Icons.warning_amber_rounded, 'Terlambat', a?.formattedTerlambat ?? "Hari ini, -"),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _buildLogoutButton(),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavbarBottomPage(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }

  

  Widget _buildStatCard(String? value, String label) => Container(
        width: 110.w,
        height: 90.h,
        margin: EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (label == 'Kehadiran' && value != null && value != '-' && value != 'null')
                  ? '${value}%'
                  : (value == null || value == '' || value == 'null') ? '-' : value,
                style: AppFonts.bold(fontSize: 15.sp, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                style: AppFonts.regular(fontSize: 12.sp, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );

  Widget _buildLoadingCard() => Container(
        width: 80.w,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: SizedBox(
            width: 18.w,
            height: 18.h,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );

  Widget _buildEmptyStat() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              if (_profileController.isLoading.value) {
                return SizedBox(
                  height: 110.h,
                  child: Row(
                    children: List.generate(6, (index) => Padding(
                      padding: EdgeInsets.only(right: index < 5 ? 10.w : 0),
                      child: _buildLoadingCard(),
                    )),
                  ),
                );
              }
              if (_profileController.error.value.isNotEmpty) {
                return Center(
                  child: Text(
                    'Gagal memuat statistik',
                    style: AppFonts.regular(fontSize: 14.sp, color: Colors.red),
                  ),
                );
              }
              final stat = _profileController.statistik.value;
              return SizedBox(
                height: 110.h,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatCard(
                          stat?.persentaseKehadiran?.toString() ?? '-', 'Kehadiran'),
                      SizedBox(width: 10.w),
                      _buildStatCard(
                          stat?.jumlahMasuk?.toString() ?? '-', 'Hari Masuk'),
                      SizedBox(width: 10.w),
                      _buildStatCard(
                          stat?.jumlahTelat?.toString() ?? '-', 'Jumlah Telat'),
                      SizedBox(width: 10.w),
                      _buildStatCard(
                          stat?.jumlahTidakMasuk?.toString() ?? '-', 'Tidak Masuk'),
                      SizedBox(width: 10.w),
                      _buildStatCard(
                          stat?.jumlahIzin?.toString() ?? '-', 'Izin'),
                      SizedBox(width: 10.w),
                      _buildStatCard(
                          stat?.jumlahSakit?.toString() ?? '-', 'Sakit'),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      );

  Widget _buildPersonalInfo() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Informasi Personal', style: AppFonts.bold()),
              Divider(),
              Obx(() {
                final u = _profileController.user.value;
                return Column(
                  children: [
                    _buildInfoRowColumn(Icons.badge, 'NIP', u?.nip ?? '-'),
                    _buildInfoRowColumn(Icons.email, 'Email', u?.email ?? '-'),
                    _buildInfoRowColumn(Icons.phone, 'Telepon', u?.telepon ?? '-'),
                    _buildInfoRowColumn(Icons.book, 'Mata Pelajaran', u?.mapel ?? '-'),
                  ],
                );
              }),
            ],
          ),
        ),
      );

  Widget _buildActivity() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Aktivitas', style: AppFonts.bold()),
              Divider(),
              Obx(() {
                final a = _profileController.activity.value;
                return Column(
                  children: [
                    _buildActivityRow(Icons.login, 'Masuk', a?.formattedCheckIn ?? "--:--"),
                    _buildActivityRow(Icons.logout, 'Keluar', a?.formattedCheckOut ?? "--:--"),
                    _buildActivityRow(Icons.warning_amber_rounded, 'Terlambat', a?.formattedTerlambat ?? "Hari ini, -"),
                  ],
                );
              }),
            ],
          ),
        ),
      );

  Widget _buildLogoutButton() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
            icon: Icon(Icons.exit_to_app, size: 20.sp),
            label: Text('Keluar', style: AppFonts.bold(fontSize: 16.sp)),
            onPressed: () async {
              
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
        ),
      );

  
  Widget _buildInfoRow(IconData icon, String label, String value) => Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: Colors.black54),
            SizedBox(width: 8.w),
            Text(label, style: AppFonts.bold(fontSize: 13.sp)),
            Spacer(),
            Text(value, style: AppFonts.regular(fontSize: 13.sp)),
          ],
        ),
      );

  
  Widget _buildActivityRow(IconData icon, String label, String value) => Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Icon(icon, size: 20.sp, color: Colors.black54),
            SizedBox(width: 8.w),
            Text(label, style: AppFonts.bold()),
            Spacer(),
            Text(value, style: AppFonts.regular(fontSize: 12.sp, color: Colors.black54)),
          ],
        ),
      );

  
  Widget _buildInfoRowColumn(IconData icon, String label, String value) => Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18.sp, color: Colors.black54),
                SizedBox(width: 8.w),
                Text(label, style: AppFonts.bold(fontSize: 13.sp)),
              ],
            ),
            SizedBox(height: 2.h),
            Text(value, style: AppFonts.regular(fontSize: 13.sp)),
          ],
        ),
      );

  
  Widget _buildActivityRowColumn(IconData icon, String label, String value) => Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20.sp, color: Colors.black54),
                SizedBox(width: 8.w),
                Text(label, style: AppFonts.bold()),
              ],
            ),
            SizedBox(height: 2.h),
            Text(value, style: AppFonts.regular(fontSize: 12.sp, color: Colors.black54)),
          ],
        ),
      );

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0].length >= 2
          ? parts[0].substring(0, 2).toUpperCase()
          : parts[0].toUpperCase();
    } else if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return '';
  }

  void _showPopup(String message, {bool success = false}) {
    _popupMessage.value = (success ? '[SUCCESS] ' : '[ERROR] ') + message;
    Future.delayed(const Duration(seconds: 2), () {
      _popupMessage.value = '';
    });
  }
}

