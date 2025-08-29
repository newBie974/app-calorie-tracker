import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class StatisticsCards extends StatelessWidget {
  final String selectedRange;

  const StatisticsCards({
    super.key,
    required this.selectedRange,
  });

  List<Map<String, dynamic>> get statisticsData {
    switch (selectedRange) {
      case 'Week':
        return [
          {
            'title': 'Avg Daily Calories',
            'value': '1,925',
            'unit': 'kcal',
            'icon': 'local_fire_department',
            'color': 'primary',
            'trend': '+2.5%',
            'trendUp': true,
          },
          {
            'title': 'Logging Streak',
            'value': '12',
            'unit': 'days',
            'icon': 'calendar_today',
            'color': 'secondary',
            'trend': '+3 days',
            'trendUp': true,
          },
          {
            'title': 'Foods Logged',
            'value': '84',
            'unit': 'items',
            'icon': 'restaurant',
            'color': 'tertiary',
            'trend': '+12',
            'trendUp': true,
          },
          {
            'title': 'Weight Change',
            'value': '-1.0',
            'unit': 'kg',
            'icon': 'monitor_weight',
            'color': 'primary',
            'trend': 'This week',
            'trendUp': false,
          },
        ];
      case 'Month':
        return [
          {
            'title': 'Avg Daily Calories',
            'value': '1,950',
            'unit': 'kcal',
            'icon': 'local_fire_department',
            'color': 'primary',
            'trend': '+1.2%',
            'trendUp': true,
          },
          {
            'title': 'Logging Streak',
            'value': '28',
            'unit': 'days',
            'icon': 'calendar_today',
            'color': 'secondary',
            'trend': '+16 days',
            'trendUp': true,
          },
          {
            'title': 'Foods Logged',
            'value': '336',
            'unit': 'items',
            'icon': 'restaurant',
            'color': 'tertiary',
            'trend': '+252',
            'trendUp': true,
          },
          {
            'title': 'Weight Change',
            'value': '-2.8',
            'unit': 'kg',
            'icon': 'monitor_weight',
            'color': 'primary',
            'trend': 'This month',
            'trendUp': false,
          },
        ];
      case '3 Months':
        return [
          {
            'title': 'Avg Daily Calories',
            'value': '1,875',
            'unit': 'kcal',
            'icon': 'local_fire_department',
            'color': 'primary',
            'trend': '-3.8%',
            'trendUp': false,
          },
          {
            'title': 'Logging Streak',
            'value': '89',
            'unit': 'days',
            'icon': 'calendar_today',
            'color': 'secondary',
            'trend': '+61 days',
            'trendUp': true,
          },
          {
            'title': 'Foods Logged',
            'value': '1,068',
            'unit': 'items',
            'icon': 'restaurant',
            'color': 'tertiary',
            'trend': '+732',
            'trendUp': true,
          },
          {
            'title': 'Weight Change',
            'value': '-4.3',
            'unit': 'kg',
            'icon': 'monitor_weight',
            'color': 'primary',
            'trend': '3 months',
            'trendUp': false,
          },
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = statisticsData;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Key Statistics',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 1.2,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              return _buildStatCard(context, stats[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, Map<String, dynamic> stat) {
    final theme = Theme.of(context);

    Color cardColor;
    switch (stat['color']) {
      case 'primary':
        cardColor = theme.colorScheme.primary;
        break;
      case 'secondary':
        cardColor = theme.colorScheme.secondary;
        break;
      case 'tertiary':
        cardColor = theme.colorScheme.tertiary;
        break;
      default:
        cardColor = theme.colorScheme.primary;
    }

    final trendUp = stat['trendUp'] as bool;
    final trendColor =
        trendUp ? theme.colorScheme.primary : theme.colorScheme.error;

    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: cardColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: stat['icon'],
                  color: cardColor,
                  size: 20,
                ),
              ),
              if (stat['trend'] != null)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: trendColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: trendUp ? 'trending_up' : 'trending_down',
                        color: trendColor,
                        size: 12,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        stat['trend'],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: trendColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text: stat['value'],
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                  children: [
                    TextSpan(
                      text: ' ${stat['unit']}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                stat['title'],
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
