import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Authentication buttons widget with primary, secondary and social login options
/// Implements platform-specific authentication patterns with proper branding
class AuthenticationButtonsWidget extends StatefulWidget {
  const AuthenticationButtonsWidget({super.key});

  @override
  State<AuthenticationButtonsWidget> createState() =>
      _AuthenticationButtonsWidgetState();
}

class _AuthenticationButtonsWidgetState
    extends State<AuthenticationButtonsWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        children: [
          // Primary Get Started button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleGetStarted,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                elevation: 2,
                shadowColor: theme.colorScheme.shadow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Get Started',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
            ),
          ),

          SizedBox(height: 2.h),

          // Secondary Sign In button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: OutlinedButton(
              onPressed: _isLoading ? null : _handleSignIn,
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                side: BorderSide(
                  color: theme.colorScheme.outline,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Sign In',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Divider with "or" text
          _buildDivider(context),

          SizedBox(height: 3.h),

          // Social authentication buttons
          _buildSocialButtons(context),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'or',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: theme.colorScheme.outline.withValues(alpha: 0.5),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Google Sign-In button (prominent on Android)
        if (!kIsWeb || defaultTargetPlatform == TargetPlatform.android)
          Container(
            width: double.infinity,
            height: 6.h,
            margin: EdgeInsets.only(bottom: 2.h),
            child: OutlinedButton.icon(
              onPressed: _isLoading ? null : _handleGoogleSignIn,
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface,
                backgroundColor: theme.colorScheme.surface,
                side: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.5),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: CustomImageWidget(
                imageUrl:
                    "https://developers.google.com/identity/images/g-logo.png",
                width: 5.w,
                height: 5.w,
                fit: BoxFit.contain,
              ),
              label: Text(
                'Continue with Google',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),

        // Apple Sign-In button (mandatory on iOS)
        if (!kIsWeb || defaultTargetPlatform == TargetPlatform.iOS)
          Container(
            width: double.infinity,
            height: 6.h,
            child: OutlinedButton.icon(
              onPressed: _isLoading ? null : _handleAppleSignIn,
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface,
                backgroundColor: theme.brightness == Brightness.light
                    ? Colors.black
                    : theme.colorScheme.surface,
                side: BorderSide(
                  color: theme.brightness == Brightness.light
                      ? Colors.black
                      : theme.colorScheme.outline.withValues(alpha: 0.5),
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: CustomIconWidget(
                iconName: 'apple',
                color: theme.brightness == Brightness.light
                    ? Colors.white
                    : theme.colorScheme.onSurface,
                size: 5.w,
              ),
              label: Text(
                'Continue with Apple',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.brightness == Brightness.light
                      ? Colors.white
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _handleGetStarted() {
    setState(() => _isLoading = true);

    // Navigate to authentication screens for account creation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushNamed(context, '/authentication-screens');
      }
    });
  }

  void _handleSignIn() {
    // Navigate to authentication screens for sign in
    Navigator.pushNamed(context, '/authentication-screens');
  }

  void _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      // Simulate Google Sign-In process
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);
        // Navigate to home dashboard on successful authentication
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-dashboard',
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google Sign-In failed. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _handleAppleSignIn() async {
    setState(() => _isLoading = true);

    try {
      // Simulate Apple Sign-In process
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);
        // Navigate to home dashboard on successful authentication
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home-dashboard',
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Apple Sign-In failed. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}
