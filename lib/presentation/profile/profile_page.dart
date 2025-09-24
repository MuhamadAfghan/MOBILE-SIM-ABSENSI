import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sim_absensi/widget/app_fonts_custom.dart';
import 'package:sim_absensi/widget/pop_up_custom.dart';
import 'package:sim_absensi/presentation/profile/controller/profile_controller.dart';
import '../../theme/navbar_bottom_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    } else if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    controller.selectedIndex.value = 3; 
    
    controller.reloadUserFromPrefs();
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
                
                Obx(() => controller.popupMessage.value.isNotEmpty
                    ? SafeArea(
                        bottom: true,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          child: controller.popupMessage.value.startsWith('[SUCCESS]')
                              ? PopUpSuccess(
                                  message: controller.popupMessage.value.replaceFirst('[SUCCESS]', '').trim(),
                                )
                              : PopUpError(
                                  message: controller.popupMessage.value.replaceFirst('[ERROR]', '').trim(),
                                ),
                        ),
                      )
                    : const SizedBox.shrink()),

                
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        SizedBox(height: 24.h),

                        
                        Obx(() {
                          final user = controller.user.value;
                          final initials = _getInitials(user?.name ?? '-');
                          return Column(
                            children: [
                              CircleAvatar(
                                radius: 55.r,
                                backgroundColor: const Color(0xFFFDEEEE),
                                child: Text(initials,
                                    style: AppFonts.bold(fontSize: 36.sp, color: Colors.black54)),
                              ),
                              SizedBox(height: 16.h),
                              Text(user?.name ?? '-', style: AppFonts.bold(fontSize: 20.sp)),
                              Text(user?.mapel ?? '-', style: AppFonts.regular(fontSize: 15.sp, color: Colors.black54)),
                            ],
                          );
                        }),

                        
                        _buildStatistik(controller),

                        
                        _buildPersonalInfo(controller),

                        SizedBox(height: 16.h),

                        
                        _buildActivity(controller),

                        SizedBox(height: 16.h),

                        
                        _buildLogoutButton(controller),

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
      bottomNavigationBar: Obx(() => NavbarBottomPage(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.navigateTo,
          )),
    );
  }

  
  Widget _buildStatistik(ProfileController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
      child: Obx(() {
        if (controller.isLoading.value) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 110.h,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  6,
                  (index) => Container(
                    width: 80.w,
                    margin: EdgeInsets.only(right: index < 5 ? 10.w : 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                ),
              ),
            ),
          );
        }

        if (controller.error.value.isNotEmpty) {
          return Center(
            child: Text('Gagal memuat statistik',
                style: AppFonts.regular(fontSize: 14.sp, color: Colors.red)),
          );
        }

        final stat = controller.statistik.value;
        Widget statCard(String? value, String label) {
          final displayValue = (label == 'Kehadiran' && value != null && value != '-' && value != 'null')
              ? '$value%'
              : (value == null || value.isEmpty || value == 'null') ? '-' : value;

          return Container(
            width: 110.w,
            height: 90.h,
            margin: EdgeInsets.only(right: 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4.r, offset: Offset(0, 2.h))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(displayValue, style: AppFonts.bold(fontSize: 15.sp)),
                SizedBox(height: 8.h),
                Text(label, style: AppFonts.regular(fontSize: 12.sp, color: Colors.black87)),
              ],
            ),
          );
        }

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 110.h,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                statCard(stat?.persentaseKehadiran?.toString(), 'Kehadiran'),
                statCard(stat?.jumlahMasuk?.toString(), 'Hari Masuk'),
                statCard(stat?.jumlahTelat?.toString(), 'Jumlah Telat'),
                statCard(stat?.jumlahTidakMasuk?.toString(), 'Tidak Masuk'),
                statCard(stat?.jumlahIzin?.toString(), 'Izin'),
                statCard(stat?.jumlahSakit?.toString(), 'Sakit'),
              ],
            ),
          ),
        );
      }),
    );
  }

  
  Widget _buildPersonalInfo(ProfileController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Informasi Personal', style: AppFonts.bold()),
            Divider(),
            Obx(() {
              final u = controller.user.value;
              Widget infoRow(IconData icon, String label, String value) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      children: [
                        Icon(icon, size: 18.sp, color: Colors.black54),
                        SizedBox(width: 8.w),
                        Text(label, style: AppFonts.bold(fontSize: 13.sp)),
                        const Spacer(),
                        Text(value, style: AppFonts.regular(fontSize: 13.sp)),
                      ],
                    ),
                  );
              return Column(
                children: [
                  infoRow(Icons.badge, 'NIP', u?.nip ?? '-'),
                  infoRow(Icons.email, 'Email', u?.email ?? '-'),
                  infoRow(Icons.phone, 'Telepon', u?.telepon ?? '-'),
                  infoRow(Icons.book, 'Mata Pelajaran', u?.mapel ?? '-'),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  
  Widget _buildActivity(ProfileController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Aktivitas', style: AppFonts.bold()),
            Divider(),
            Obx(() {
              final a = controller.activity.value;
              Widget activityRow(IconData icon, String label, String value) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: Row(
                      children: [
                        Icon(icon, size: 20.sp, color: Colors.black54),
                        SizedBox(width: 8.w),
                        Text(label, style: AppFonts.bold()),
                        const Spacer(),
                        Text(value, style: AppFonts.regular(fontSize: 12.sp, color: Colors.black54)),
                      ],
                    ),
                  );
              return Column(
                children: [
                  activityRow(Icons.login, 'Masuk', a?.formattedCheckIn ?? "--:--"),
                  activityRow(Icons.logout, 'Keluar', a?.formattedCheckOut ?? "--:--"),
                  activityRow(Icons.warning_amber_rounded, 'Terlambat', a?.formattedTerlambat ?? "Hari ini, -"),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  
  Widget _buildLogoutButton(ProfileController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            padding: EdgeInsets.symmetric(vertical: 14.h),
          ),
          icon: Icon(Icons.exit_to_app, size: 20.sp),
          label: Text('Keluar', style: AppFonts.bold(fontSize: 16.sp)),
          onPressed: controller.logout,
        ),
      ),
    );
  }
}
