import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Footer links widget containing privacy policy and terms links
/// Implements Contemporary Wellness Minimalism with subtle styling
class FooterLinksWidget extends StatelessWidget {
  const FooterLinksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        children: [
          // Privacy and terms links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => _handlePrivacyPolicy(context),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurfaceVariant,
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                ),
                child: Text(
                  'Privacy Policy',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 3.h,
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                margin: EdgeInsets.symmetric(horizontal: 2.w),
              ),
              TextButton(
                onPressed: () => _handleTermsOfService(context),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurfaceVariant,
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                ),
                child: Text(
                  'Terms of Service',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // App version and copyright
          Text(
            'CalorieTracker v1.0.0',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 0.5.h),

          Text(
            '© 2024 CalorieTracker. All rights reserved.',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Trust signals
          _buildTrustSignals(context),
        ],
      ),
    );
  }

  Widget _buildTrustSignals(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SSL security badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'security',
                color: theme.colorScheme.primary,
                size: 3.w,
              ),
              SizedBox(width: 1.w),
              Text(
                'SSL Secured',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 3.w),

        // Privacy compliant badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: theme.colorScheme.secondary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'privacy_tip',
                color: theme.colorScheme.secondary,
                size: 3.w,
              ),
              SizedBox(width: 1.w),
              Text(
                'Privacy First',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handlePrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Text(
            'Your privacy is important to us. CalorieTracker collects and uses your personal information to provide nutrition tracking services.\n\n'
            'We collect:\n'
            '• Account information (name, email)\n'
            '• Health data (weight, goals, food logs)\n'
            '• Usage analytics for app improvement\n\n'
            'We do not:\n'
            '• Sell your personal data\n'
            '• Share health information without consent\n'
            '• Store payment information on our servers\n\n'
            'Your data is encrypted and stored securely. You can delete your account and data at any time.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleTermsOfService(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Terms of Service'),
        content: SingleChildScrollView(
          child: Text(
            'Welcome to CalorieTracker. By using our app, you agree to these terms.\n\n'
            'Service Usage:\n'
            '• You must be 13+ years old to use this app\n'
            '• Provide accurate health information\n'
            '• Use the app for personal nutrition tracking only\n\n'
            'Prohibited Activities:\n'
            '• Sharing account credentials\n'
            '• Attempting to hack or reverse engineer\n'
            '• Using the app for commercial purposes\n\n'
            'Disclaimer:\n'
            '• CalorieTracker is not a substitute for professional medical advice\n'
            '• Consult healthcare providers for medical decisions\n'
            '• We are not liable for health outcomes\n\n'
            'These terms may be updated. Continued use constitutes acceptance.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
