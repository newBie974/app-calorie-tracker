import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _backgroundController;
  bool _isInitialized = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
  }

  Future<void> _initializeApp() async {
    try {
      // Start background gradient animation
      _backgroundController.forward();

      // Start logo animation after short delay
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        _logoController.forward();
      }

      // Simulate app initialization with realistic tasks
      await Future.wait([
        _checkAuthenticationStatus(),
        _loadUserPreferences(),
        _fetchNutritionDatabase(),
        _prepareCacheData(),
      ]);

      setState(() {
        _isInitialized = true;
      });

      // Wait for animations to complete before navigating
      await Future.delayed(const Duration(milliseconds: 1000));

      if (mounted) {
        _navigateToNextScreen();
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to initialize app. Please try again.';
      });
    }
  }

  Future<void> _checkAuthenticationStatus() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  Future<void> _loadUserPreferences() async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  Future<void> _fetchNutritionDatabase() async {
    await Future.delayed(const Duration(milliseconds: 1000));
  }

  Future<void> _prepareCacheData() async {
    await Future.delayed(const Duration(milliseconds: 700));
  }

  void _navigateToNextScreen() {
    // Check if user is authenticated, for now go to welcome
    Navigator.pushReplacementNamed(context, '/welcome-screen');
  }

  void _retryInitialization() {
    setState(() {
      _hasError = false;
      _errorMessage = '';
      _isInitialized = false;
    });
    _logoController.reset();
    _backgroundController.reset();
    _initializeApp();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.primaryGreen,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
          child: SafeArea(
            child: _hasError ? _buildErrorView() : _buildSplashContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildSplashContent() {
    return AnimatedBuilder(
      animation: _backgroundController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryGreen.withAlpha(230),
                AppTheme.primaryGreenDark.withAlpha(204),
                AppTheme.accentBlue.withAlpha(153),
              ],
              stops: [0.0, 0.5, 1.0],
              transform: GradientRotation(_backgroundController.value * 0.5),
            ),
          ),
          child: Column(
            children: [
              // Logo section - main focus with premium animation
              Expanded(
                flex: 3,
                child: Center(
                  child: _buildAnimatedLogo(),
                ),
              ),

              // Tagline section - elegant typography
              Expanded(
                flex: 1,
                child: _buildTaglineSection(),
              ),

              // Loading section - minimal and elegant
              Expanded(
                flex: 1,
                child: _buildLoadingSection(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAnimatedLogo() {
    return Container(
      width: 40.w,
      height: 40.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow effect
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withAlpha(77),
                  Colors.white.withAlpha(26),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          )
              .animate(controller: _logoController)
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: 1200.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(
                duration: 800.ms,
                curve: Curves.easeOut,
              ),

          // Main logo container
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: AppTheme.primaryGreen.withAlpha(77),
                  blurRadius: 30,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant_menu_rounded,
                  size: 10.w,
                  color: AppTheme.primaryGreen,
                ).animate(controller: _logoController).scale(
                      begin: const Offset(0.0, 0.0),
                      end: const Offset(1.0, 1.0),
                      duration: 800.ms,
                      delay: 400.ms,
                      curve: Curves.bounceOut,
                    ),
                SizedBox(height: 1.h),
                Text(
                  'CT',
                  style: GoogleFonts.inter(
                    fontSize: 6.w,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.primaryGreen,
                    letterSpacing: 2,
                  ),
                )
                    .animate(controller: _logoController)
                    .fadeIn(
                      duration: 600.ms,
                      delay: 800.ms,
                    )
                    .slideY(
                      begin: 0.5,
                      end: 0,
                      duration: 600.ms,
                      delay: 800.ms,
                      curve: Curves.easeOut,
                    ),
              ],
            ),
          )
              .animate(controller: _logoController)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 1000.ms,
                delay: 200.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(
                duration: 800.ms,
                delay: 200.ms,
              ),
        ],
      ),
    );
  }

  Widget _buildTaglineSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Track smarter. Eat better.',
            style: GoogleFonts.inter(
              fontSize: 7.w,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(
                duration: 800.ms,
                delay: 1500.ms,
              )
              .slideY(
                begin: 0.3,
                end: 0,
                duration: 800.ms,
                delay: 1500.ms,
                curve: Curves.easeOut,
              ),
          SizedBox(height: 2.h),
          Text(
            'Your premium nutrition companion',
            style: GoogleFonts.inter(
              fontSize: 4.w,
              fontWeight: FontWeight.w400,
              color: Colors.white.withAlpha(230),
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(
                duration: 600.ms,
                delay: 1800.ms,
              ),
        ],
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_isInitialized)
          Container(
            width: 8.w,
            height: 8.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: AppTheme.primaryGreen,
              size: 5.w,
            ),
          ).animate().scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: 300.ms,
                curve: Curves.bounceOut,
              )
        else
          SizedBox(
            width: 6.w,
            height: 6.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withAlpha(230),
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .rotate(duration: 2000.ms),
        SizedBox(height: 3.h),
        Text(
          _isInitialized ? 'Ready to start!' : 'Preparing your experience...',
          style: GoogleFonts.inter(
            fontSize: 3.5.w,
            fontWeight: FontWeight.w500,
            color: Colors.white.withAlpha(230),
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(
              duration: 500.ms,
              delay: 2200.ms,
            ),
      ],
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(51),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 12.w,
                color: Colors.white,
              ),
            ).animate().scale(
                  duration: 500.ms,
                  curve: Curves.bounceOut,
                ),
            SizedBox(height: 4.h),
            Text(
              'Oops! Something went wrong',
              style: GoogleFonts.inter(
                fontSize: 6.w,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              _errorMessage,
              style: GoogleFonts.inter(
                fontSize: 4.w,
                fontWeight: FontWeight.w400,
                color: Colors.white.withAlpha(230),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5.h),
            ElevatedButton(
              onPressed: _retryInitialization,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.primaryGreen,
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 2.5.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh_rounded,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Try Again',
                    style: GoogleFonts.inter(
                      fontSize: 4.w,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
