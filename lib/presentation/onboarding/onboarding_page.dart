import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sim_absensi/widget/app_fonts_custom.dart';
import 'package:sim_absensi/widget/pop_up_custom.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  final RxString _popupMessage = ''.obs; 

  Future<void> _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    Navigator.pushReplacementNamed(context, '/login');
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
      body: SafeArea(
        child: Stack(
          children: [
            Container(
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
                        SizedBox(height: 24.h),
                        
                        Center(
                          child: Image.asset(
                            "assets/onboarding/logo_lengkap.png",
                            height: 100.h,
                          ),
                        ),
                        SizedBox(height: 20.h),
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
                                    height: 220.h,
                                  ),
                                  SizedBox(height: 40.h),
                                  Text(
                                    onboardingData[index].title,
                                    style: AppFonts.bold(fontSize: 22, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    onboardingData[index].description,
                                    style: AppFonts.regular(fontSize: 15, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            onboardingData.length,
                            (index) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 4.w),
                              width: currentIndex == index ? 16.w : 8.w,
                              height: 8.h,
                              decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 60.h),
                      ],
                    ),
                    
                    Positioned(
                      left: 24.w,
                      bottom: 24.h,
                      child: GestureDetector(
                        onTap: _completeOnboarding,
                        child: Text(
                          "Skip",
                          style: AppFonts.bold(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    
                    Positioned(
                      right: 24.w,
                      bottom: 16.h,
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
                          width: 56.w,
                          height: 56.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFFA24B),
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 32.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
                : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  void _showPopup(String message, {bool success = false}) {
    _popupMessage.value = (success ? '[SUCCESS] ' : '[ERROR] ') + message;
    Future.delayed(const Duration(seconds: 2), () {
      _popupMessage.value = '';
    });
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
