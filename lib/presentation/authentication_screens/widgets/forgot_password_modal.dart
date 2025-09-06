import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class ForgotPasswordModal extends StatefulWidget {
  const ForgotPasswordModal({super.key});

  @override
  State<ForgotPasswordModal> createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _buttonController;

  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _buttonScaleAnimation;

  bool _isLoading = false;
  String? _emailError;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _scaleController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _buttonController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = 'Email is required';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _emailError = 'Please enter a valid email address';
      } else {
        _emailError = null;
      }
    });
  }

  bool get _isFormValid =>
      _emailError == null && _emailController.text.isNotEmpty;

  Future<void> _handlePasswordReset() async {
    if (!_isFormValid) return;

    // Button press animation
    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });

    setState(() => _isLoading = true);

    try {
      // Mock password reset - replace with actual password reset logic
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _emailSent = true;
        _isLoading = false;
      });

      HapticFeedback.lightImpact();

      // Auto close modal after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorMessage('Failed to send reset email. Please try again.');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                color: AppTheme.lightTheme.colorScheme.error,
                size: 4.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: EdgeInsets.only(
          left: 6.w,
          right: 6.w,
          top: 3.h,
          bottom: mediaQuery.viewInsets.bottom + 3.h,
        ),
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Enhanced Header with Close Button
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  children: [
                    if (!_emailSent)
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
                          icon: Icon(
                            Icons.close_rounded,
                            color: theme.colorScheme.onSurface,
                            size: 5.w,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        _emailSent ? 'Check Your Email!' : 'Reset Password',
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                        textAlign:
                            _emailSent ? TextAlign.center : TextAlign.start,
                      ),
                    ),
                    if (!_emailSent) SizedBox(width: 11.w),
                  ],
                ),
              ),

              if (!_emailSent) ...[
                // Instructions with better typography
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.softBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.accentBlue.withAlpha(26),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: AppTheme.accentBlue,
                          size: 5.w,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          'Enter your email address and we\'ll send you a secure link to reset your password.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.accentBlue,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 4.h),

                // Enhanced Email Form
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withAlpha(128),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _emailError != null
                                ? theme.colorScheme.error.withAlpha(128)
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          enabled: !_isLoading,
                          onChanged: _validateEmail,
                          onFieldSubmitted: (_) => _handlePasswordReset(),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'Enter your email',
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(4.w),
                              child: Icon(
                                Icons.email_outlined,
                                color: _emailError != null
                                    ? theme.colorScheme.error
                                    : theme.colorScheme.onSurfaceVariant,
                                size: 5.w,
                              ),
                            ),
                            filled: false,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 4.w,
                              vertical: 2.h,
                            ),
                            errorText: null,
                          ),
                        ),
                      ),
                      if (_emailError != null) ...[
                        SizedBox(height: 1.h),
                        Padding(
                          padding: EdgeInsets.only(left: 4.w),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 4.w,
                                color: theme.colorScheme.error,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                _emailError!,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: 4.h),

                // Enhanced Send Reset Link Button
                ScaleTransition(
                  scale: _buttonScaleAnimation,
                  child: Container(
                    height: 7.h,
                    decoration: BoxDecoration(
                      gradient: _isFormValid && !_isLoading
                          ? AppTheme.primaryGradient
                          : LinearGradient(
                              colors: [
                                theme.colorScheme.surfaceContainerHighest,
                                theme.colorScheme.surfaceContainerHighest,
                              ],
                            ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: _isFormValid && !_isLoading
                          ? [
                              BoxShadow(
                                color: AppTheme.primaryGreen.withAlpha(77),
                                blurRadius: 12,
                                spreadRadius: 2,
                                offset: const Offset(0, 6),
                              ),
                            ]
                          : [],
                    ),
                    child: ElevatedButton(
                      onPressed: _isFormValid && !_isLoading
                          ? _handlePasswordReset
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 5.w,
                              width: 5.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Send Reset Link',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: _isFormValid && !_isLoading
                                        ? Colors.white
                                        : theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Icon(
                                  Icons.send_rounded,
                                  color: _isFormValid && !_isLoading
                                      ? Colors.white
                                      : theme.colorScheme.onSurfaceVariant,
                                  size: 5.w,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ] else ...[
                // Enhanced Success State
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    children: [
                      Container(
                        width: 25.w,
                        height: 25.w,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryGreen.withAlpha(77),
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.mark_email_read_outlined,
                            color: Colors.white,
                            size: 12.w,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.softGreen,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Reset link sent successfully!',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryGreenDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'We\'ve sent a password reset link to:',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppTheme.primaryGreenDark.withAlpha(204),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 1.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _emailController.text,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppTheme.primaryGreen,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Check your email and click the link to reset your password. This window will close automatically.',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppTheme.primaryGreenDark.withAlpha(179),
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
