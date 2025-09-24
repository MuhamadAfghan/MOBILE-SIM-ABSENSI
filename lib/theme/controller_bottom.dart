import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'navbar_bottom_page.dart';

class HomeWithNavbar extends StatefulWidget {
  const HomeWithNavbar({Key? key}) : super(key: key);

  @override
  State<HomeWithNavbar> createState() => _HomeWithNavbarState();
}

class _HomeWithNavbarState extends State<HomeWithNavbar> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          Center(child: Text("Beranda")),
          Center(child: Text("Artikel")),
          Center(child: Text("Riwayat")),
          Center(child: Text("Profil")),
        ],
      ),
      bottomNavigationBar: NavbarBottomPage(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
        