import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './widgets/custom_error_widget.dart';
import 'core/app_export.dart';
import 'presentation/authentication_screens/authentication_screens.dart';
import 'presentation/authentication_screens/widgets/auth_guard.dart';
import 'presentation/main_navigation/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(
      errorDetails: details,
    );
  };

  // Initialize Supabase
  await _initializeSupabase();

  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    // Enable full screen usage by hiding status bar when needed
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
  ]).then((value) {
    runApp(MyApp());
  });
}

Future<void> _initializeSupabase() async {
  try {
    // Load environment variables
    final envData = await _loadEnvData();

    await Supabase.initialize(
      url: envData['SUPABASE_URL'] ?? '',
      anonKey: envData['SUPABASE_ANON_KEY'] ?? '',
      debug: false, // Set to true for development debugging
    );
  } catch (e) {
    // Handle initialization error gracefully
    debugPrint('Supabase initialization error: $e');
  }
}

Future<Map<String, String>> _loadEnvData() async {
  try {
    // In a real app, you might want to use a package like flutter_dotenv
    // For now, we'll use a simple approach with the existing env.json
    final envFile = await rootBundle.loadString('env.json');
    final Map<String, dynamic> envData = json.decode(envFile);

    return envData.map((key, value) => MapEntry(key, value.toString()));
  } catch (e) {
    debugPrint('Error loading environment data: $e');
    return {};
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        title: 'calorietracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
        // 🚨 END CRITICAL SECTION
        debugShowCheckedModeBanner: false,
        home: const AuthGuard(
          authenticatedChild: MainNavigationScreen(),
          unauthenticatedChild: AuthenticationScreens(),
        ),
        routes: AppRoutes.routes,
      );
    });
  }
}
