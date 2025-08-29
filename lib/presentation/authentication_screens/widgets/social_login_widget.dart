import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SocialLoginWidget extends StatefulWidget {
  final VoidCallback? onGoogleLogin;
  final VoidCallback? onAppleLogin;

  const SocialLoginWidget({
    super.key,
    this.onGoogleLogin,
    this.onAppleLogin,
  });

  @override
  State<SocialLoginWidget> createState() => _SocialLoginWidgetState();
}

class _SocialLoginWidgetState extends State<SocialLoginWidget>
    with TickerProviderStateMixin {
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;

  late AnimationController _googleController;
  late AnimationController _appleController;
  late Animation<double> _googleScaleAnimation;
  late Animation<double> _appleScaleAnimation;

  @override
  void initState() {
    super.initState();

    _googleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _appleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _googleScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _googleController,
      curve: Curves.easeInOut,
    ));

    _appleScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _appleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _googleController.dispose();
    _appleController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleLogin() async {
    _googleController.forward().then((_) {
      _googleController.reverse();
    });

    setState(() => _isGoogleLoading = true);
    HapticFeedback.lightImpact();

    try {
      // Mock Google Sign-In - replace with actual Google Sign-In logic
      await Future.delayed(const Duration(seconds: 2));
      widget.onGoogleLogin?.call();
    } catch (e) {
      _showErrorMessage('Google Sign-In failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isGoogleLoading = false);
      }
    }
  }

  Future<void> _handleAppleLogin() async {
    _appleController.forward().then((_) {
      _appleController.reverse();
    });

    setState(() => _isAppleLoading = true);
    HapticFeedback.lightImpact();

    try {
      // Mock Apple Sign-In - replace with actual Apple Sign-In logic
      await Future.delayed(const Duration(seconds: 2));
      widget.onAppleLogin?.call();
    } catch (e) {
      _showErrorMessage('Apple Sign-In failed. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isAppleLoading = false);
      }
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

    return Column(
      children: [
        // Enhanced Divider with "OR" text
        Container(
          margin: EdgeInsets.symmetric(vertical: 2.h),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        theme.colorScheme.outline.withAlpha(128),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'OR',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        theme.colorScheme.outline.withAlpha(128),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 2.h),

        // Enhanced Google Sign-In Button
        ScaleTransition(
          scale: _googleScaleAnimation,
          child: Container(
            height: 6.5.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.outline.withAlpha(77),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: OutlinedButton(
              onPressed: _isGoogleLoading || _isAppleLoading
                  ? null
                  : _handleGoogleLogin,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _isGoogleLoading
                      ? SizedBox(
                          height: 5.w,
                          width: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryGreen,
                            ),
                          ),
                        )
                      : Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://developers.google.com/identity/images/g-logo.png',
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                  SizedBox(width: 4.w),
                  Text(
                    _isGoogleLoading ? 'Connecting...' : 'Continue with Google',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // Enhanced Apple Sign-In Button
        ScaleTransition(
          scale: _appleScaleAnimation,
          child: Container(
            height: 6.5.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(26),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: OutlinedButton(
              onPressed: _isAppleLoading || _isGoogleLoading
                  ? null
                  : _handleAppleLogin,
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.transparent,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _isAppleLoading
                      ? SizedBox(
                          height: 5.w,
                          width: 5.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.brightness == Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.apple,
                          color: theme.brightness == Brightness.dark
                              ? Colors.black
                              : Colors.white,
                          size: 6.w,
                        ),
                  SizedBox(width: 4.w),
                  Text(
                    _isAppleLoading ? 'Connecting...' : 'Continue with Apple',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: theme.brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 3.h),

        // Enhanced Privacy Notice
        Container(
          padding: EdgeInsets.all(4.w),
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(128),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.security,
                  color: AppTheme.primaryGreen,
                  size: 4.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Your data is protected with end-to-end encryption. We never share your information.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
