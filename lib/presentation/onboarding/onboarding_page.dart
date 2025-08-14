import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController pageController = PageController();
  int currentIndex = 0;

  final List<OnboardingData> onboardingData = [
    OnboardingData(
      title: "Tepat Waktu",
      description: "Absensi jadi praktis dengan pengaturan waktu yang fleksibel.",
      imageAsset: "assets/onboarding/onboarding1.png",
    ),
    OnboardingData(
      title: "Mudah Digunakan",
      description: "Antarmuka sederhana dan intuitif, cocok untuk semua kalangan.",
      imageAsset: "assets/onboarding/onboarding2.png",
    ),
    OnboardingData(
      title: "Aman & Terpercaya",
      description: "Data absensi tersimpan aman dan dapat diakses kapan saja.",
      imageAsset: "assets/onboarding/onboarding3.png",
    ),
  ];

  Future<void> _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB3C6F7),
              Color(0xFF6A9CFD),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 24),
                  // Logo Hadir.in
                  Center(
                    child: Image.asset(
                      "assets/onboarding/logo_lengkap.png",
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      itemCount: onboardingData.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              onboardingData[index].imageAsset,
                              height: 220,
                            ),
                            const SizedBox(height: 40),
                            Text(
                              onboardingData[index].title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              onboardingData[index].description,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // Dots indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: currentIndex == index ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
              // Skip button (bottom left)
              Positioned(
                left: 24,
                bottom: 24,
                child: GestureDetector(
                  onTap: _completeOnboarding,
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              // Next/Arrow button (bottom right)
              Positioned(
                right: 24,
                bottom: 16,
                child: GestureDetector(
                  onTap: () async {
                    if (currentIndex == onboardingData.length - 1) {
                      await _completeOnboarding();
                    } else {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFA24B),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String imageAsset;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imageAsset,
  });
}
