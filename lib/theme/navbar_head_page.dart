import 'package:flutter/material.dart';
import '../widget/app_fonts_custom.dart';

class NavbarHeadPage extends StatelessWidget {
  final String title;
  final String date;
  final VoidCallback? onNotificationTap;

  const NavbarHeadPage({
    Key? key,
    this.title = "Hadi",
    this.date = "Kamis, 15 Februari 2025",
    this.onNotificationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF5069D6),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 32 / 2,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppFonts.heading20.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: AppFonts.body14.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
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
}