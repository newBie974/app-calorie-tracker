import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/food_search_and_logging/food_search_and_logging.dart';
import '../presentation/welcome_screen/welcome_screen.dart';
import '../presentation/progress_tracking/progress_tracking.dart';
import '../presentation/authentication_screens/authentication_screens.dart';
import '../presentation/settings/settings.dart';
import '../presentation/onboarding/onboarding_screen.dart';
import '../presentation/qr_scanner/qr_scanner_screen.dart';
import '../presentation/ai_chat/ai_chat_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String foodSearchAndLogging = '/food-search-and-logging';
  static const String welcome = '/welcome-screen';
  static const String progressTracking = '/progress-tracking';
  static const String authentications = '/authentication-screens';
  static const String settings = '/settings';
  static const String onboarding = '/onboarding';
  static const String qrScanner = '/qr-scanner';
  static const String aiChat = '/ai-chat';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    foodSearchAndLogging: (context) => const FoodSearchAndLogging(),
    welcome: (context) => const WelcomeScreen(),
    progressTracking: (context) => const ProgressTracking(),
    authentications: (context) => const AuthenticationScreens(),
    settings: (context) => const Settings(),
    onboarding: (context) => const OnboardingScreen(),
    qrScanner: (context) => const QRScannerScreen(),
    aiChat: (context) => const AIChatScreen(),
    // TODO: Add your other routes here
  };
}
