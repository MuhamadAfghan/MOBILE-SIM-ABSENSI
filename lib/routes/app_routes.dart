import 'package:flutter/material.dart';
import '../presentation/splash/splash_screen.dart';
import '../presentation/onboarding/onboarding_page.dart';
import '../presentation/login/login_page.dart';
import '../presentation/home/home_page.dart';
import '../presentation/history/history_page.dart';
import '../presentation/roll_call/roll_call_page.dart';
import '../presentation/profile/profile_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/HomePage';
  static const String history = '/HistoryPage';
  static const String rollCall = '/RollCallPage';
  static const String profile = '/ProfilePage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case history:
        return MaterialPageRoute(builder: (_) => const HistoryPage());
      case rollCall:
        return MaterialPageRoute(builder: (_) => const RollCallPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
