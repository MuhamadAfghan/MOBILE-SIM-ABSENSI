import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../onboarding/onboarding_page.dart';
import '../login/login_page.dart';
import 'widgets/animated_logo.dart';
import 'widgets/shimmer_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoMoveController;
  late Animation<double> _logoMoveAnimation;

  late AnimationController _circleDropController;
  late Animation<double> _circleDropAnimation;

  late AnimationController _fadeTextController;
  late Animation<double> _fadeTextAnimation;

  bool _showLogo = false;
  bool _showCircle = false;
  bool _showText = false;
  bool _changeBg = false;

  @override
  void initState() {
    super.initState();

    _logoMoveController = AnimationController(
      duration: const Duration(milliseconds: 1400), // lebih lama
      vsync: this,
    );
    _logoMoveAnimation = Tween<double>(begin: -1.2, end: 0.0).animate(
      CurvedAnimation(parent: _logoMoveController, curve: Curves.easeOutCubic),
    );

    _circleDropController = AnimationController(
      duration: const Duration(milliseconds: 1200), // lebih lama
      vsync: this,
    );
    _circleDropAnimation = Tween<double>(begin: -1.2, end: 0.0).animate(
      CurvedAnimation(parent: _circleDropController, curve: Curves.easeOutBack),
    );

    _fadeTextController = AnimationController(
      duration: const Duration(milliseconds: 1600), // lebih lama
      vsync: this,
    );
    _fadeTextAnimation = CurvedAnimation(parent: _fadeTextController, curve: Curves.easeIn);

    _startSequence();
  }

  Future<void> _startSequence() async {
    // 1. Logo turun dari atas ke tengah
    setState(() => _showLogo = true);
    await _logoMoveController.forward();
    await Future.delayed(const Duration(milliseconds: 400)); // transisi lebih smooth
    // 2. Lingkaran turun dari atas ke tengah (di belakang logo)
    setState(() => _showCircle = true);
    await _circleDropController.forward();
    await Future.delayed(const Duration(milliseconds: 400)); // transisi lebih smooth
    // 3. Background langsung berubah warna
    setState(() => _changeBg = true);
    // 4. Tulisan muncul
    setState(() => _showText = true);
    await _fadeTextController.forward();
    // Tunggu hingga total durasi splash screen ~7 detik
    final totalAnim = 1400 + 400 + 1200 + 400 + 1600; // = 5000 ms
    final remaining = 7000 - totalAnim;
    if (remaining > 0) {
      await Future.delayed(Duration(milliseconds: remaining));
    }
    _checkFirstSeen();
  }

  void _navigateWithSlide(Widget page) {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 650),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ));
  }

  Future<void> _checkFirstSeen() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding');

    if (hasSeenOnboarding == null || !hasSeenOnboarding) {
      _navigateWithSlide(const OnboardingPage());
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _logoMoveController.dispose();
    _circleDropController.dispose();
    _fadeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleDiameter = size.width * 0.7;

    return Scaffold(
      backgroundColor: _changeBg ? Colors.blue[900] : Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Lingkaran biru turun dari atas ke tengah (di belakang logo)
          if (_showCircle)
            AnimatedBuilder(
              animation: _circleDropAnimation,
              builder: (context, child) {
                return Align(
                  alignment: Alignment(0, _circleDropAnimation.value),
                  child: Container(
                    width: circleDiameter,
                    height: circleDiameter,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[700]?.withOpacity(0.85),
                    ),
                  ),
                );
              },
            ),

          // Logo turun dari atas ke tengah
          if (_showLogo)
            AnimatedBuilder(
              animation: _logoMoveAnimation,
              builder: (context, child) {
                return Align(
                  alignment: Alignment(0, _logoMoveAnimation.value),
                  child: child,
                );
              },
              child: AnimatedLogo(),
            ),

          // Tulisan dan progress muncul setelah background berubah
          if (_showText)
            Positioned(
              bottom: size.height * 0.18,
              child: FadeTransition(
                opacity: _fadeTextAnimation,
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    ShimmerText(
                      text: 'Selamat Datang di SIM Absensi',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ShimmerText(
                      text: 'Solusi absensi modern & mudah',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 30),
                    const CircularProgressIndicator(color: Colors.white),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
