import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../authentication_screens/authentication_screens.dart';
import '../onboarding/onboarding_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _contentController;
  late AnimationController _buttonsController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _heroController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _buttonsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _heroController.forward();

      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) {
        _contentController.forward();

        await Future.delayed(const Duration(milliseconds: 200));
        if (mounted) {
          _buttonsController.forward();
        }
      }
    }
  }

  void _navigateToLogin() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: const AuthenticationScreens(),
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _navigateToSignup() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: const OnboardingScreen(),
        duration: const Duration(milliseconds: 400),
        reverseDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _continueAsGuest() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/home-dashboard');
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    HapticFeedback.selectionClick();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _contentController.dispose();
    _buttonsController.dispose();
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
          child: Column(
            children: [
              // Hero illustration section - 35% of screen (reduced to make room for date picker)
              Expanded(
                flex: 40,
                child: _buildHeroSection(),
              ),

              // Content and buttons section - 40% of screen
              Expanded(
                flex: 60,
                child: _buildContentSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*Widget _buildDatePickerSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          // Section title
          Text(
            'Choose Your Start Date',
            style: GoogleFonts.inter(
              fontSize: 4.w,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ).animate(controller: _contentController).fadeIn(
                duration: 500.ms,
                delay: 300.ms,
              ),

          SizedBox(height: 2.h),

          // Sliding date picker
          Expanded(
            child: SlidingHorizontalDatePicker(
              onDateSelected: _onDateSelected,
              backgroundColor: AppTheme.surfaceLight,
              selectedColor: const Color(0xFFDFFF9C), // Pastel green from specs
              todayColor: AppTheme.primaryGreen,
            ).animate(controller: _contentController).slideY(
                  begin: 0.5,
                  end: 0,
                  duration: 600.ms,
                  delay: 400.ms,
                  curve: Curves.easeOutBack,
                ),
          ),
        ],
      ),
    );
  }*/

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Gradient background for hero section
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.softGreen,
                  AppTheme.backgroundLight,
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),

          // Floating elements for visual interest
          Positioned(
            top: 10.h,
            left: 15.w,
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.softPurple,
                shape: BoxShape.circle,
              ),
            )
                .animate(
                    onPlay: (controller) => controller.repeat(reverse: true))
                .moveY(
                  begin: 0,
                  end: 20,
                  duration: 3000.ms,
                  curve: Curves.easeInOut,
                ),
          ),

          Positioned(
            top: 20.h,
            right: 20.w,
            child: Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: AppTheme.softBlue,
                borderRadius: BorderRadius.circular(2.w),
              ),
            )
                .animate(
                    onPlay: (controller) => controller.repeat(reverse: true))
                .moveX(
                  begin: 0,
                  end: -15,
                  duration: 2500.ms,
                  delay: 500.ms,
                  curve: Curves.easeInOut,
                ),
          ),

          // Main illustration/image
          Center(
            child: Container(
              width: 70.w,
              height: 35.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=500&h=600&fit=crop&crop=center',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: AppTheme.softGreen,
                    highlightColor: Colors.white,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.softGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_menu_rounded,
                            size: 15.w,
                            color: Colors.white,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Vie Saine',
                            style: GoogleFonts.inter(
                              fontSize: 5.w,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
                .animate(controller: _heroController)
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.0, 1.0),
                  duration: 800.ms,
                  curve: Curves.easeOut,
                )
                .fadeIn(
                  duration: 600.ms,
                ),
          ),

          // Decorative elements
          Positioned(
            bottom: 5.h,
            left: 10.w,
            child: Container(
              width: 4.w,
              height: 4.w,
              decoration: const BoxDecoration(
                color: AppTheme.softPeach,
                shape: BoxShape.circle,
              ),
            )
                .animate(
                    onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  begin: const Offset(0.8, 0.8),
                  end: const Offset(1.2, 1.2),
                  duration: 2000.ms,
                  curve: Curves.easeInOut,
                ),
          ),

          Positioned(
            bottom: 8.h,
            right: 12.w,
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: BoxDecoration(
                color: AppTheme.softRose,
                borderRadius: BorderRadius.circular(1.w),
              ),
            )
                .animate(
                    onPlay: (controller) => controller.repeat(reverse: true))
                .rotate(
                  begin: 0,
                  end: 0.5,
                  duration: 4000.ms,
                  curve: Curves.easeInOut,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          // Main heading and value proposition
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bienvenue dans votre\nParcours Nutritionnel',
                  style: GoogleFonts.inter(
                    fontSize: 8.w,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate(controller: _contentController)
                    .fadeIn(
                      duration: 500.ms,
                    )
                    .slideY(
                      begin: 0.3,
                      end: 0,
                      duration: 500.ms,
                      curve: Curves.easeOut,
                    ),
                SizedBox(height: 1.h),
                Text(
                  _selectedDate != null
                      ? 'Commencer votre parcours le ${_formatSelectedDate()} !'
                      : 'Suivedz vos repas, atteignez vos objectifs et développez des habitudes plus saines.',
                  style: GoogleFonts.inter(
                    fontSize: 4.w,
                    fontWeight: FontWeight.w400,
                    color: _selectedDate != null
                        ? AppTheme.primaryGreen
                        : AppTheme.textSecondary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ).animate(controller: _contentController).fadeIn(
                      duration: 500.ms,
                      delay: 200.ms,
                    ),
              ],
            ),
          ),

          // Action buttons
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Primary button - Create Account
                Container(
                  width: double.infinity,
                  height: 7.h,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryGreen.withAlpha(77),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _navigateToSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Créer un Compte',
                      style: GoogleFonts.inter(
                        fontSize: 4.5.w,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
                    .animate(controller: _buttonsController)
                    .fadeIn(
                      duration: 400.ms,
                    )
                    .slideY(
                      begin: 0.5,
                      end: 0,
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    ),

                SizedBox(height: 2.h),

                // Secondary button - Log In
                Container(
                  width: double.infinity,
                  height: 7.h,
                  child: OutlinedButton(
                    onPressed: _navigateToLogin,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppTheme.primaryGreen,
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Se Connecter',
                      style: GoogleFonts.inter(
                        fontSize: 4.5.w,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                )
                    .animate(controller: _buttonsController)
                    .fadeIn(
                      duration: 400.ms,
                      delay: 100.ms,
                    )
                    .slideY(
                      begin: 0.5,
                      end: 0,
                      duration: 400.ms,
                      delay: 100.ms,
                      curve: Curves.easeOut,
                    ),

                SizedBox(height: 2.h),

                // Guest access
                TextButton(
                  onPressed: _continueAsGuest,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 1.5.h,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Continuer en Invité',
                        style: GoogleFonts.inter(
                          fontSize: 3.8.w,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 4.w,
                        color: AppTheme.textSecondary,
                      ),
                    ],
                  ),
                ).animate(controller: _buttonsController).fadeIn(
                      duration: 400.ms,
                      delay: 200.ms,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatSelectedDate() {
    if (_selectedDate == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay =
        DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);

    if (selectedDay == today) {
      return 'aujourd\'hui';
    } else if (selectedDay == today.add(const Duration(days: 1))) {
      return 'demain';
    } else {
      return DateFormat('d MMMM', 'fr').format(_selectedDate!);
    }
  }
}
