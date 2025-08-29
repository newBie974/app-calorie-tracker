import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class IOSMacroCards extends StatelessWidget {
  final int proteinGrams;
  final int proteinTarget;
  final int carbsGrams;
  final int carbsTarget;
  final int fatGrams;
  final int fatTarget;

  const IOSMacroCards({
    super.key,
    required this.proteinGrams,
    required this.proteinTarget,
    required this.carbsGrams,
    required this.carbsTarget,
    required this.fatGrams,
    required this.fatTarget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: _buildMacroCard(
              context,
              'Protein',
              proteinGrams,
              proteinTarget,
              'g',
              AppTheme.roseLight,
              AppTheme.errorLight,
              Icons.fitness_center_rounded,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildMacroCard(
              context,
              'Carbs',
              carbsGrams,
              carbsTarget,
              'g',
              AppTheme.lightYellowLight,
              AppTheme.warningLight,
              Icons.grain_rounded,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildMacroCard(
              context,
              'Fat',
              fatGrams,
              fatTarget,
              'g',
              AppTheme.lightBlueLight,
              AppTheme.secondaryLight,
              Icons.water_drop_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(
    BuildContext context,
    String title,
    int current,
    int target,
    String unit,
    Color backgroundColor,
    Color accentColor,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final progress = current / target;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: accentColor,
                size: 5.w,
              ),
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                child: CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 2.5,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.w),
          RichText(
            text: TextSpan(
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimaryLight,
                height: 1.0,
              ),
              children: [
                TextSpan(text: current.toString()),
                TextSpan(
                  text: '/$target$unit',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.w),
          Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondaryLight,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
