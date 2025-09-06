import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/main_navigation/main_navigation_screen.dart';
import '../presentation/welcome_screen/welcome_screen.dart';
import '../presentation/authentication_screens/authentication_screens.dart';
import '../presentation/settings/settings.dart';
import '../presentation/onboarding/onboarding_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String mainNavigation = '/main-navigation';
  static const String welcome = '/welcome-screen';
  static const String authentications = '/authentication-screens';
  static const String settings = '/settings';
  static const String onboarding = '/onboarding';

  // Legacy routes - kept for backward compatibility but redirect to main navigation
  static const String homeDashboard = '/home-dashboard';
  static const String foodSearchAndLogging = '/food-search-and-logging';
  static const String progressTracking = '/progress-tracking';
  static const String qrScanner = '/qr-scanner';
  static const String aiChat = '/ai-chat';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    mainNavigation: (context) => const MainNavigationScreen(),
    welcome: (context) => const WelcomeScreen(),
    authentications: (context) => const AuthenticationScreens(),
    settings: (context) => const Settings(),
    onboarding: (context) => const OnboardingScreen(),

    // Legacy routes redirect to main navigation
    homeDashboard: (context) => const MainNavigationScreen(),
    foodSearchAndLogging: (context) => const MainNavigationScreen(),
    progressTracking: (context) => const MainNavigationScreen(),
    qrScanner: (context) => const MainNavigationScreen(),
    aiChat: (context) => const MainNavigationScreen(),
    // TODO: Add your other routes here
  };
}
