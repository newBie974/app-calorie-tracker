import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class IOSCommunitySection extends StatelessWidget {
  const IOSCommunitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          _buildTogetherCard(context),
          SizedBox(height: 3.w),
          _buildDiscoverSection(context),
        ],
      ),
    );
  }

  Widget _buildTogetherCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightBlueLight,
            AppTheme.mintLight,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Together is better!',
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryLight,
              height: 1.2,
            ),
          ),
          SizedBox(height: 2.w),
          Text(
            'Invite your crew to join MuseFit',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondaryLight,
              height: 1.3,
            ),
          ),
          SizedBox(height: 4.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  for (int i = 0; i < 4; i++)
                    Container(
                      width: 10.w,
                      height: 10.w,
                      margin: EdgeInsets.only(right: i < 3 ? 2.w : 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.getPastelColor(i),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.shadowLight.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: AppTheme.textSecondaryLight,
                        size: 5.w,
                      ),
                    ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.5.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryLight.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Invite friends',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoverSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.w),
          child: Text(
            'Discover',
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
        ),
        SizedBox(height: 2.w),
        Row(
          children: [
            Expanded(
              child: _buildDiscoverCard(
                context,
                'Meal Plans',
                'Cook, Taste, Record, Repeat',
                Icons.restaurant_rounded,
                AppTheme.roseLight,
                AppTheme.errorLight,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildDiscoverCard(
                context,
                'Exercise',
                'Sweating is self-love',
                Icons.fitness_center_rounded,
                AppTheme.lightYellowLight,
                AppTheme.warningLight,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.w),
        _buildMoodTrackingCard(context),
      ],
    );
  }

  Widget _buildDiscoverCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color backgroundColor,
    Color iconColor,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.5.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 5.w,
            ),
          ),
          SizedBox(height: 3.w),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryLight,
              height: 1.2,
            ),
          ),
          SizedBox(height: 1.w),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondaryLight,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodTrackingCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppTheme.lavenderLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight.withValues(alpha: 0.08),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Feel after workout?',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                  height: 1.2,
                ),
              ),
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.mood_rounded,
                  color: AppTheme.secondaryLight,
                  size: 5.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          Text(
            'Track your mood to maintain an accurate history and identify changes in cortisol levels',
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondaryLight,
              height: 1.4,
            ),
          ),
          SizedBox(height: 4.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.5.w),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryLight.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              'Check mood levels',
              style: theme.textTheme.labelMedium?.copyWith(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
