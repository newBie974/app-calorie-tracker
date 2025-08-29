import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Hero illustration widget displaying healthy food and fitness imagery
/// Implements Contemporary Wellness Minimalism design with engaging visuals
class HeroIllustrationWidget extends StatelessWidget {
  const HeroIllustrationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: 35.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background gradient container
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  theme.colorScheme.secondaryContainer.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          // Main hero image
          Positioned(
            top: 2.h,
            child: Container(
              width: 70.w,
              height: 25.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomImageWidget(
                  imageUrl:
                      "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=800",
                  width: 70.w,
                  height: 25.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Floating food icons
          Positioned(
            top: 1.h,
            right: 8.w,
            child: _buildFloatingIcon(
              context,
              'restaurant',
              theme.colorScheme.primary,
            ),
          ),

          Positioned(
            bottom: 3.h,
            left: 6.w,
            child: _buildFloatingIcon(
              context,
              'fitness_center',
              theme.colorScheme.secondary,
            ),
          ),

          Positioned(
            top: 8.h,
            left: 2.w,
            child: _buildFloatingIcon(
              context,
              'local_dining',
              theme.colorScheme.tertiary,
            ),
          ),

          // Progress ring indicator
          Positioned(
            bottom: 1.h,
            right: 4.w,
            child: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 8.w,
                      height: 8.w,
                      child: CircularProgressIndicator(
                        value: 0.75,
                        strokeWidth: 2,
                        backgroundColor:
                            theme.colorScheme.outline.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Text(
                      '75%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(
      BuildContext context, String iconName, Color color) {
    final theme = Theme.of(context);

    return Container(
      width: 10.w,
      height: 10.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 5.w,
        ),
      ),
    );
  }
}
