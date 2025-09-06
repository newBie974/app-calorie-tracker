import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/forgot_password_modal.dart';
import './widgets/login_form_widget.dart';
import './widgets/register_form_widget.dart';
import './widgets/social_login_widget.dart';

class AuthenticationScreens extends StatefulWidget {
  const AuthenticationScreens({super.key});

  @override
  State<AuthenticationScreens> createState() => _AuthenticationScreensState();
}

class _AuthenticationScreensState extends State<AuthenticationScreens>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Setup animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _startAnimations();

    // Listen to keyboard visibility
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mediaQuery = MediaQuery.of(context);
      setState(() {
        _isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;
      });
    });
  }

  void _startAnimations() async {
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _scaleController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _handleLoginSuccess() {
    HapticFeedback.lightImpact();
    // Add success animation
    _showSuccessAnimation();
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    });
  }

  void _handleRegisterSuccess() {
    HapticFeedback.lightImpact();
    // Add success animation
    _showSuccessAnimation();
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    });
  }

  void _handleSocialLoginSuccess() {
    HapticFeedback.lightImpact();
    _showSuccessAnimation();
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    });
  }

  void _showSuccessAnimation() {
    HapticFeedback.lightImpact();
    // Add a subtle success indicator
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 4.w,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              'Bienvenue !',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showForgotPasswordModal() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: const ForgotPasswordModal(),
      ),
    );
  }

  void _switchToRegister() {
    HapticFeedback.selectionClick();
    _tabController.animateTo(1);
  }

  void _switchToLogin() {
    HapticFeedback.selectionClick();
    _tabController.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final keyboardHeight = mediaQuery.viewInsets.bottom;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Enhanced App Bar with Animation
                SlideTransition(
                  position: _slideAnimation,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Enhanced back button with proper tap target
                        Container(
                          width: 11.w,
                          height: 11.w,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Navigator.of(context).pop();
                            },
                            icon: CustomIconWidget(
                              iconName: 'arrow_back_ios',
                              color: theme.colorScheme.onSurface,
                              size: 5.w,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Bienvenue',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 11.w), // Balance the back button
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Column(
                        children: [
                          // Enhanced Logo Section with Animation
                          if (keyboardHeight == 0) ...[
                            SizedBox(height: 4.h),
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: Container(
                                width: 28.w,
                                height: 28.w,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.primaryGradient,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppTheme.primaryGreen.withAlpha(77),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: CustomIconWidget(
                                    iconName: 'restaurant',
                                    color: Colors.white,
                                    size: 14.w,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 3.h),
                            SlideTransition(
                              position: _slideAnimation,
                              child: Column(
                                children: [
                                  Text(
                                    'CalorieTracker',
                                    style:
                                        theme.textTheme.headlineLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      foreground: Paint()
                                        ..shader = AppTheme.primaryGradient
                                            .createShader(
                                          const Rect.fromLTWH(0, 0, 200, 70),
                                        ),
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    'Votre compagnon nutrition personnel',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4.h),
                          ] else ...[
                            SizedBox(height: 2.h),
                          ],

                          // Enhanced Tab Bar with Modern Design
                          SlideTransition(
                            position: _slideAnimation,
                            child: Container(
                              padding: EdgeInsets.all(1.w),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(10),
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TabBar(
                                controller: _tabController,
                                indicator: BoxDecoration(
                                  gradient: AppTheme.primaryGradient,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          AppTheme.primaryGreen.withAlpha(77),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                dividerColor: Colors.transparent,
                                labelColor: Colors.white,
                                unselectedLabelColor:
                                    theme.colorScheme.onSurfaceVariant,
                                labelStyle: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.1,
                                ),
                                unselectedLabelStyle: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -0.1,
                                ),
                                splashFactory: NoSplash.splashFactory,
                                overlayColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                tabs: [
                                  Tab(
                                    height: 6.h,
                                    child: const Text('Connexion'),
                                  ),
                                  Tab(
                                    height: 6.h,
                                    child: const Text('Inscription'),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 4.h),

                          // Enhanced Tab Bar View with Animation
                          SlideTransition(
                            position: _slideAnimation,
                            child: SizedBox(
                              height: keyboardHeight > 0 ? null : 65.h,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  // Login Form
                                  SingleChildScrollView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    child: Column(
                                      children: [
                                        LoginFormWidget(
                                          onLoginSuccess: _handleLoginSuccess,
                                          onForgotPassword:
                                              _showForgotPasswordModal,
                                          onSwitchToRegister: _switchToRegister,
                                        ),
                                        SizedBox(height: 4.h),
                                        SocialLoginWidget(
                                          onGoogleLogin:
                                              _handleSocialLoginSuccess,
                                          onAppleLogin:
                                              _handleSocialLoginSuccess,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Register Form
                                  SingleChildScrollView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    child: Column(
                                      children: [
                                        RegisterFormWidget(
                                          onRegisterSuccess:
                                              _handleRegisterSuccess,
                                          onSwitchToLogin: _switchToLogin,
                                        ),
                                        SizedBox(height: 4.h),
                                        SocialLoginWidget(
                                          onGoogleLogin:
                                              _handleSocialLoginSuccess,
                                          onAppleLogin:
                                              _handleSocialLoginSuccess,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Bottom padding for keyboard
                          SizedBox(height: keyboardHeight > 0 ? 2.h : 4.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
