import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/premium_calorie_ring.dart';
import './widgets/premium_macro_cards.dart';
import './widgets/premium_quick_stats.dart';
import './widgets/premium_recent_meals.dart';

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
      return 'Bonjour, $name! ☀️';
    } else if (hour < 17) {
      return 'Bonjour, $name! 🌤️';
    } else {
      return 'Bonsoir, $name! 🌙';
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
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppTheme.primaryGreen,
            backgroundColor: Colors.white,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                // Custom app bar with greeting
                SliverToBoxAdapter(
                  child: _buildGreetingHeader(),
                ),

                // Main content sections
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3.h),

                      // Premium calorie progress ring
                      Center(
                        child: PremiumCalorieRing(
                          consumedCalories: _consumedCalories,
                          targetCalories: _targetCalories,
                          onTap: _handleAddFood,
                        )
                            .animate(controller: _cardControllers[0])
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              end: const Offset(1.0, 1.0),
                              duration: 600.ms,
                              curve: Curves.elasticOut,
                            )
                            .fadeIn(
                              duration: 400.ms,
                            ),
                      ),

                      SizedBox(height: 4.h),

                      // Macro breakdown cards
                      PremiumMacroCards(
                        proteinGrams: _proteinGrams,
                        proteinTarget: _proteinTarget,
                        carbsGrams: _carbsGrams,
                        carbsTarget: _carbsTarget,
                        fatGrams: _fatGrams,
                        fatTarget: _fatTarget,
                      )
                          .animate(controller: _cardControllers[1])
                          .fadeIn(
                            duration: 500.ms,
                          )
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 500.ms,
                            curve: Curves.easeOut,
                          ),

                      SizedBox(height: 4.h),

                      // Quick stats (water, steps)
                      PremiumQuickStats(
                        waterGlasses: _waterGlasses,
                        waterTarget: _waterTarget,
                        steps: _steps,
                        stepsTarget: _stepsTarget,
                      )
                          .animate(controller: _cardControllers[2])
                          .fadeIn(
                            duration: 500.ms,
                          )
                          .slideX(
                            begin: -0.2,
                            end: 0,
                            duration: 500.ms,
                            curve: Curves.easeOut,
                          ),

                      SizedBox(height: 4.h),

                      // Recent meals section
                      _buildSectionHeader('Recent Meals', 'See all')
                          .animate(controller: _cardControllers[3])
                          .fadeIn(
                            duration: 400.ms,
                          ),

                      SizedBox(height: 2.h),

                      PremiumRecentMeals()
                          .animate(controller: _cardControllers[4])
                          .fadeIn(
                            duration: 500.ms,
                          )
                          .slideY(
                            begin: 0.2,
                            end: 0,
                            duration: 500.ms,
                            curve: Curves.easeOut,
                          ),

                      SizedBox(height: 4.h),

                      // Motivational message
                      _buildMotivationalCard()
                          .animate(controller: _cardControllers[5])
                          .fadeIn(
                            duration: 500.ms,
                          )
                          .scale(
                            begin: const Offset(0.95, 0.95),
                            end: const Offset(1.0, 1.0),
                            duration: 500.ms,
                            curve: Curves.easeOut,
                          ),

                      SizedBox(height: 15.h), // Bottom padding for FAB
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Premium floating action button
        floatingActionButton: _buildPremiumFAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        // Bottom navigation
        bottomNavigationBar: const CustomBottomBar(currentIndex: 0),
      ),
    );
  }

  Widget _buildGreetingHeader() {
    return Padding(
      padding: EdgeInsets.all(6.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: GoogleFonts.inter(
                    fontSize: 5.w,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    height: 1.1,
                  ),
                )
                    .animate(controller: _greetingController)
                    .fadeIn(
                      duration: 500.ms,
                    )
                    .slideX(
                      begin: -0.3,
                      end: 0,
                      duration: 500.ms,
                      curve: Curves.easeOut,
                    ),
                SizedBox(height: 0.5.h),
                Text(
                  'Ready to crush your goals?',
                  style: GoogleFonts.inter(
                    fontSize: 4.w,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textSecondary,
                  ),
                ).animate(controller: _greetingController).fadeIn(
                      duration: 400.ms,
                      delay: 200.ms,
                    ),
              ],
            ),
          ),

          // Profile avatar with notification badge
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/settings');
            },
            child: Stack(
              children: [
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryGreen.withAlpha(77),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: 8.w,
                    color: Colors.white,
                  ),
                ),

                // Notification badge
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 4.w,
                    height: 4.w,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '2',
                        style: GoogleFonts.inter(
                          fontSize: 2.5.w,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).animate(controller: _greetingController).scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 400.ms,
                delay: 300.ms,
                curve: Curves.bounceOut,
              ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 6.w,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              // Navigate to full list
            },
            child: Text(
              actionText,
              style: GoogleFonts.inter(
                fontSize: 4.w,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationalCard() {
    final caloriesLeft = _targetCalories - _consumedCalories;
    final isOnTrack = caloriesLeft > 0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: isOnTrack
            ? AppTheme.primaryGradient
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.accentBlue,
                  AppTheme.accentPurple,
                ],
              ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isOnTrack ? AppTheme.primaryGreen : AppTheme.accentBlue)
                .withAlpha(77),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isOnTrack ? 'You\'re doing great! 🎉' : 'Goal achieved! 🏆',
                  style: GoogleFonts.inter(
                    fontSize: 5.5.w,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  isOnTrack
                      ? '$caloriesLeft calories left for today'
                      : 'You\'ve reached your daily target!',
                  style: GoogleFonts.inter(
                    fontSize: 4.w,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withAlpha(230),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isOnTrack
                  ? Icons.local_fire_department_rounded
                  : Icons.star_rounded,
              size: 8.w,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumFAB() {
    return AnimatedBuilder(
      animation: _fabController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 - (_fabController.value * 0.1),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryGreen.withAlpha(102),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              onPressed: _handleAddFood,
              backgroundColor: Colors.transparent,
              elevation: 0,
              extendedPadding: EdgeInsets.symmetric(horizontal: 8.w),
              icon: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
              label: Text(
                'Add Food',
                style: GoogleFonts.inter(
                  fontSize: 4.5.w,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
