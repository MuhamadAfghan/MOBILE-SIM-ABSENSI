import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:sim_absensi/widget/app_color_custom.dart';


class NavbarBottomPage extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavbarBottomPage({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      height: 60,
      backgroundColor: Colors.transparent,
      color: AppColor.primaryBlue,
      buttonBackgroundColor: Colors.blueAccent,
      animationDuration: const Duration(milliseconds: 800),
      items: const [
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.article, size: 30, color: Colors.white),
        Icon(Icons.access_time, size: 30, color: Colors.white),
        Icon(Icons.person, size: 30, color: Colors.white),
      ],
      onTap: onTap,
    );
  }
}
