import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class IOSActivityCards extends StatelessWidget {
  final int steps;
  final int stepsGoal;
  final double sleepHours;
  final double sleepGoal;
  final int meditationMinutes;

  const IOSActivityCards({
    super.key,
    required this.steps,
    required this.stepsGoal,
    required this.sleepHours,
    required this.sleepGoal,
    required this.meditationMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildStepsCard(context),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildSleepCard(context),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          _buildMeditationCard(context),
        ],
      ),
    );
  }

  Widget _buildStepsCard(BuildContext context) {
    final theme = Theme.of(context);
    final progress = steps / stepsGoal;
    final progressPercent = (progress * 100).toInt();

    return Container(
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppTheme.mintLight,
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
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.directions_walk_rounded,
                  color: AppTheme.primaryLight,
                  size: 6.w,
                ),
              ),
              Text(
                '$progressPercent% Goal',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.w),
          Text(
            'Walk Steps',
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondaryLight,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 1.w),
          Text(
            steps.toString().replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (Match m) => '${m[1]},',
                ),
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryLight,
              height: 1.1,
            ),
          ),
          SizedBox(height: 3.w),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withValues(alpha: 0.4),
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryLight),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepCard(BuildContext context) {
    final theme = Theme.of(context);
    final progress = sleepHours / sleepGoal;
    final progressPercent = (progress * 100).toInt();
    final hours = sleepHours.floor();
    final minutes = ((sleepHours - hours) * 60).round();

    return Container(
      padding: EdgeInsets.all(4.w),
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
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.bedtime_rounded,
              color: AppTheme.secondaryLight,
              size: 5.w,
            ),
          ),
          SizedBox(height: 3.w),
          Text(
            'Sleep',
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondaryLight,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 1.w),
          Text(
            '${hours}h ${minutes}m',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimaryLight,
              height: 1.1,
            ),
          ),
          SizedBox(height: 2.w),
          Text(
            '$progressPercent% Goal',
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 8.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: AppTheme.peachLight,
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.self_improvement_rounded,
              color: AppTheme.warningLight,
              size: 7.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meditation',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondaryLight,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 1.w),
                Text(
                  '$meditationMinutes min',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimaryLight,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Great!',
              style: theme.textTheme.labelMedium?.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.warningLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
