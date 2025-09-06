import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/home_dashboard_content.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fabController;
  late AnimationController _greetingController;
  late List<AnimationController> _cardControllers;

  // Premium dashboard data
  int _consumedCalories = 1450;
  final int _targetCalories = 2000;
  int _proteinGrams = 85;
  final int _proteinTarget = 150;
  int _carbsGrams = 180;
  final int _carbsTarget = 250;
  int _fatGrams = 50;
  final int _fatTarget = 67;

  // Water and step tracking
  int _waterGlasses = 6;
  final int _waterTarget = 8;
  int _steps = 8240;
  final int _stepsTarget = 10000;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _scrollController = ScrollController();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _greetingController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create controllers for staggered card animations
    _cardControllers = List.generate(
      6, // Number of main sections
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );
  }

  void _startAnimations() async {
    // Start greeting animation
    _greetingController.forward();

    // Staggered card animations
    for (int i = 0; i < _cardControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: 100 + (i * 80)));
      if (mounted) {
        _cardControllers[i].forward();
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    final name = 'Alex'; // This would come from user data

    if (hour < 12) {
      return 'Bonjour, $name ! ☀️';
    } else if (hour < 17) {
      return 'Bon après-midi, $name ! 🌤️';
    } else {
      return 'Bonsoir, $name ! 🌙';
    }
  }

  void _handleAddFood() {
    HapticFeedback.lightImpact();
    _fabController.forward().then((_) {
      _fabController.reverse();
    });
    Navigator.pushNamed(context, '/food-search-and-logging');
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    // Simulate data refresh with realistic delay
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() {
        // Update with fresh data
        _consumedCalories = 1450 + (DateTime.now().millisecond % 100);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fabController.dispose();
    _greetingController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppTheme.backgroundLight,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: const HomeDashboardContent(),
      ),
    );
  }
}
