import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AchievementBadges extends StatelessWidget {
  const AchievementBadges({super.key});

  List<Map<String, dynamic>> get achievements => [
        {
          'id': 1,
          'title': '7-Day Streak',
          'description': 'Logged meals for 7 consecutive days',
          'icon': 'local_fire_department',
          'isUnlocked': true,
          'progress': 7,
          'target': 7,
          'color': 'primary',
        },
        {
          'id': 2,
          'title': 'Goal Achiever',
          'description': 'Met daily calorie goal 5 times',
          'icon': 'emoji_events',
          'isUnlocked': true,
          'progress': 5,
          'target': 5,
          'color': 'secondary',
        },
        {
          'id': 3,
          'title': 'Weight Loss',
          'description': 'Lost 2kg from starting weight',
          'icon': 'trending_down',
          'isUnlocked': true,
          'progress': 2,
          'target': 2,
          'color': 'tertiary',
        },
        {
          'id': 4,
          'title': '30-Day Master',
          'description': 'Logged meals for 30 consecutive days',
          'icon': 'star',
          'isUnlocked': false,
          'progress': 12,
          'target': 30,
          'color': 'outline',
        },
        {
          'id': 5,
          'title': 'Macro Balance',
          'description': 'Balanced macros for 10 days',
          'icon': 'balance',
          'isUnlocked': false,
          'progress': 6,
          'target': 10,
          'color': 'outline',
        },
        {
          'id': 6,
          'title': 'Hydration Hero',
          'description': 'Met water intake goal 14 days',
          'icon': 'water_drop',
          'isUnlocked': false,
          'progress': 8,
          'target': 14,
          'color': 'outline',
        },
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unlockedAchievements =
        achievements.where((a) => a['isUnlocked'] == true).toList();
    final lockedAchievements =
        achievements.where((a) => a['isUnlocked'] == false).toList();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
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
                'Achievements',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${unlockedAchievements.length}/${achievements.length}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (unlockedAchievements.isNotEmpty) ...[
            Text(
              'Unlocked',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 1.h,
                childAspectRatio: 0.8,
              ),
              itemCount: unlockedAchievements.length,
              itemBuilder: (context, index) {
                return _buildAchievementBadge(
                    context, unlockedAchievements[index]);
              },
            ),
            SizedBox(height: 2.h),
          ],
          if (lockedAchievements.isNotEmpty) ...[
            Text(
              'In Progress',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 1.h,
                childAspectRatio: 0.8,
              ),
              itemCount: lockedAchievements.length,
              itemBuilder: (context, index) {
                return _buildAchievementBadge(
                    context, lockedAchievements[index]);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(
      BuildContext context, Map<String, dynamic> achievement) {
    final theme = Theme.of(context);
    final isUnlocked = achievement['isUnlocked'] as bool;
    final progress = achievement['progress'] as int;
    final target = achievement['target'] as int;
    final progressPercentage = progress / target;

    Color badgeColor;
    switch (achievement['color']) {
      case 'primary':
        badgeColor = theme.colorScheme.primary;
        break;
      case 'secondary':
        badgeColor = theme.colorScheme.secondary;
        break;
      case 'tertiary':
        badgeColor = theme.colorScheme.tertiary;
        break;
      default:
        badgeColor = theme.colorScheme.outline;
    }

    return GestureDetector(
      onTap: () => _showAchievementDetails(context, achievement),
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isUnlocked
              ? badgeColor.withValues(alpha: 0.1)
              : theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnlocked ? badgeColor : theme.colorScheme.outline,
            width: isUnlocked ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (!isUnlocked)
                  SizedBox(
                    width: 8.w,
                    height: 8.w,
                    child: CircularProgressIndicator(
                      value: progressPercentage,
                      strokeWidth: 2,
                      backgroundColor:
                          theme.colorScheme.outline.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(badgeColor),
                    ),
                  ),
                CustomIconWidget(
                  iconName: achievement['icon'],
                  color: isUnlocked
                      ? badgeColor
                      : theme.colorScheme.onSurfaceVariant,
                  size: isUnlocked ? 24 : 20,
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              achievement['title'],
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: isUnlocked
                    ? badgeColor
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isUnlocked ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (!isUnlocked) ...[
              SizedBox(height: 0.5.h),
              Text(
                '$progress/$target',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 10.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAchievementDetails(
      BuildContext context, Map<String, dynamic> achievement) {
    final theme = Theme.of(context);
    final isUnlocked = achievement['isUnlocked'] as bool;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: achievement['icon'],
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  achievement['title'],
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                achievement['description'],
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              if (isUnlocked) ...[
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Achievement Unlocked!',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Text(
                  'Progress: ${achievement['progress']}/${achievement['target']}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                LinearProgressIndicator(
                  value: (achievement['progress'] as int) /
                      (achievement['target'] as int),
                  backgroundColor:
                      theme.colorScheme.outline.withValues(alpha: 0.3),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
