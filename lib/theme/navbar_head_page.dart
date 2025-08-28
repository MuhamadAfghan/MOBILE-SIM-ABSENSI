import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widget/app_fonts_custom.dart';
import '../presentation/profile/controller/profile_controller.dart';

class NavbarHeadPage extends StatelessWidget {
  final String? title;
  final String date;

  NavbarHeadPage({
    Key? key,
    this.title,
    String? date,
  })  : date = date ??
            DateFormat("EEEE, d MMMM yyyy", "id_ID").format(
              DateTime.now().toUtc().add(const Duration(hours: 7)),
            ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final ProfileController profileController =
        Get.isRegistered<ProfileController>()
            ? Get.find<ProfileController>()
            : Get.put(ProfileController());

    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(48.r),
        bottomRight: Radius.circular(48.r),
      ),
      child: Container(
        color: const Color(0xFF5069D6),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Row(
          children: [
            
            Obx(() {
              final user = profileController.user.value;
              final initials = _getInitials(user?.name ?? '-');
              return CircleAvatar(
                backgroundColor: Colors.white,
                radius: 16.r,
                child: Text(
                  initials,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: const Color(0xFF5069D6),
                  ),
                ),
              );
            }),
            SizedBox(width: 16.w),

            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final user = profileController.user.value;
                  return Text(
                    title ?? (user?.name ?? '-'),
                    style: AppFonts.heading20.copyWith(
                      color: Colors.white,
                    ),
                  );
                }),
                SizedBox(height: 2.h),
                Text(
                  date,
                  style: AppFonts.normal10.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
}
