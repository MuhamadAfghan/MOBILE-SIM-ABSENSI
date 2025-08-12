import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../widget/app_fonts_custom.dart';
import '../presentation/profile/controller/profile_controller.dart';

class NavbarHeadPage extends StatelessWidget {
  final String? title;
  final String date;
  final VoidCallback? onNotificationTap;

  NavbarHeadPage({
    Key? key,
    this.title,
    String? date,
    this.onNotificationTap,
  })  : date = date ??
            DateFormat("EEEE, d MMMM yyyy", "id_ID").format(
              DateTime.now().toUtc().add(const Duration(hours: 7)),
            ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pastikan controller sudah diinisialisasi jika belum ada
    final ProfileController profileController =
        Get.isRegistered<ProfileController>()
            ? Get.find<ProfileController>()
            : Get.put(ProfileController());
    return Container(
      color: const Color(0xFF5069D6),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Obx(() {
            final user = profileController.user.value;
            final initials = _getInitials(user?.name ?? '-');
            return CircleAvatar(
              backgroundColor: Colors.white,
              radius: 32 / 2,
              child: Text(
                initials,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF5069D6),
                ),
              ),
            );
          }),
          const SizedBox(width: 16),
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
              const SizedBox(height: 2),
              Text(
                date,
                style: AppFonts.normal10.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: onNotificationTap,
            child: const Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
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