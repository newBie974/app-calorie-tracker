import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Welcome content widget containing heading, subtitle and value proposition
/// Implements Contemporary Wellness Minimalism typography hierarchy
class WelcomeContentWidget extends StatelessWidget {
  const WelcomeContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Main heading
          Text(
            'Track Your Nutrition Journey',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Supporting subtitle
          Text(
            'Simplify your daily calorie and nutrition tracking with intuitive food logging and visual progress monitoring.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 3.h),

          // Feature highlights
          _buildFeatureHighlights(context),
        ],
      ),
    );
  }

  Widget _buildFeatureHighlights(BuildContext context) {
    final theme = Theme.of(context);

    final features = [
      {
        'icon': 'track_changes',
        'title': 'Easy Tracking',
        'description': 'Log meals with just a few taps',
      },
      {
        'icon': 'insights',
        'title': 'Visual Progress',
        'description': 'See your nutrition goals come to life',
      },
      {
        'icon': 'psychology',
        'title': 'Smart Guidance',
        'description': 'Get personalized recommendations',
      },
    ];

    return Column(
      children: features.map((feature) {
        return Container(
          margin: EdgeInsets.only(bottom: 2.h),
          child: Row(
            children: [
              // Feature icon
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: feature['icon'] as String,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 6.w,
                  ),
                ),
              ),

              SizedBox(width: 4.w),

              // Feature content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature['title'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      feature['description'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
