import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../onboarding/onboarding_page.dart';
import '../login/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _iconAnimation;

  late AnimationController _circleController;
  late Animation<double> _circleAnimation;

  bool _showCircle = false;

  @override
  void initState() {
    super.initState();

    _iconController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _iconAnimation = Tween<double>(begin: -1.0, end: 0.0)
        .chain(CurveTween(curve: Curves.bounceOut))
        .animate(_iconController);

    _circleController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _circleAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _circleController,
        curve: Curves.easeOutCubic,
      ),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await _iconController.forward();

    // Bounce up
    await _iconController.animateTo(
      0.85,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
    );

    // Bounce down
    await _iconController.animateTo(
      1.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.bounceOut,
    );

    setState(() {
      _showCircle = true;
    });

    await _circleController.forward();
    await Future.delayed(const Duration(milliseconds: 400));

    _checkFirstSeen();
  }

  Future<void> _checkFirstSeen() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding');

    if (hasSeenOnboarding == null || !hasSeenOnboarding) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    _circleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Expanding blue circle
          if (_showCircle)
            AnimatedBuilder(
              animation: _circleAnimation,
              builder: (context, child) {
                final maxDiameter = (size.width * size.width + size.height * size.height);

                return Center(
                  child: Container(
                    width: maxDiameter * _circleAnimation.value,
                    height: maxDiameter * _circleAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.8),
                    ),
                  ),
                );
              },
            ),

          // Animated icon + text
          AnimatedBuilder(
            animation: _iconAnimation,
            builder: (context, child) {
              return Align(
                alignment: Alignment(0, _iconAnimation.value),
                child: child,
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.timer,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  'slow aja fffffffff',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
