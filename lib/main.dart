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
    debugPrint('Error: $details');
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
    // Read environment variables injected at compile time
    const url = String.fromEnvironment('SUPABASE_URL');
    const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

    if (url.isEmpty || anonKey.isEmpty) {
      debugPrint('❌ Supabase credentials not found.');
      debugPrint(
          '👉 Please pass them using --dart-define-from-file=env.json or manually via --dart-define.');
      return;
    }

    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: false, // set to true for verbose logging
    );

    debugPrint('✅ Supabase initialized successfully');
  } catch (e) {
    debugPrint('⚠️ Supabase initialization error: $e');
    debugPrint('App will continue without Supabase authentication');
  }
}

Future<Map<String, String>> _loadEnvData() async {
  try {
    // Example keys from your env.json
    const apiUrl = String.fromEnvironment('API_URL');
    const apiKey = String.fromEnvironment('API_KEY');
    const appEnv = String.fromEnvironment('APP_ENV');

    final result = <String, String>{
      'API_URL': apiUrl,
      'API_KEY': apiKey,
      'APP_ENV': appEnv,
    };

    debugPrint('Environment data loaded: ${result.keys.join(', ')}');
    return result;
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
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.initial,
      );
    });
  }
}
