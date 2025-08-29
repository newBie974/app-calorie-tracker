import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class WeeklyCalorieChart extends StatefulWidget {
  final String selectedRange;

  const WeeklyCalorieChart({
    super.key,
    required this.selectedRange,
  });

  @override
  State<WeeklyCalorieChart> createState() => _WeeklyCalorieChartState();
}

class _WeeklyCalorieChartState extends State<WeeklyCalorieChart> {
  int touchedIndex = -1;

  List<Map<String, dynamic>> get chartData {
    switch (widget.selectedRange) {
      case 'Week':
        return [
          {'day': 'Mon', 'intake': 1850, 'goal': 2000},
          {'day': 'Tue', 'intake': 2100, 'goal': 2000},
          {'day': 'Wed', 'intake': 1950, 'goal': 2000},
          {'day': 'Thu', 'intake': 1800, 'goal': 2000},
          {'day': 'Fri', 'intake': 2200, 'goal': 2000},
          {'day': 'Sat', 'intake': 1900, 'goal': 2000},
          {'day': 'Sun', 'intake': 1750, 'goal': 2000},
        ];
      case 'Month':
        return [
          {'day': 'Week 1', 'intake': 1900, 'goal': 2000},
          {'day': 'Week 2', 'intake': 2050, 'goal': 2000},
          {'day': 'Week 3', 'intake': 1850, 'goal': 2000},
          {'day': 'Week 4', 'intake': 1950, 'goal': 2000},
        ];
      case '3 Months':
        return [
          {'day': 'Month 1', 'intake': 1950, 'goal': 2000},
          {'day': 'Month 2', 'intake': 1900, 'goal': 2000},
          {'day': 'Month 3', 'intake': 1850, 'goal': 2000},
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = chartData;

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
          Text(
            'Calorie Intake vs Goal',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 30.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 2500,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: theme.colorScheme.inverseSurface,
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final dayData = data[groupIndex];
                      final isIntake = rodIndex == 0;
                      return BarTooltipItem(
                        '${dayData['day']}\n${isIntake ? 'Intake' : 'Goal'}: ${rod.toY.round()} cal',
                        theme.textTheme.bodySmall!.copyWith(
                          color: theme.colorScheme.onInverseSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          barTouchResponse == null ||
                          barTouchResponse.spot == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          barTouchResponse.spot!.touchedBarGroupIndex;
                    });
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (value.toInt() < data.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 1.h),
                            child: Text(
                              data[value.toInt()]['day'],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 4.h,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 500,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Text(
                          '${value.toInt()}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                      reservedSize: 10.w,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: data.asMap().entries.map((entry) {
                  final index = entry.key;
                  final dayData = entry.value;
                  final intake = (dayData['intake'] as int).toDouble();
                  final goal = (dayData['goal'] as int).toDouble();
                  final isTouched = index == touchedIndex;

                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: intake,
                        color: intake > goal
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                        width: isTouched ? 6.w : 4.w,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      BarChartRodData(
                        toY: goal,
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: isTouched ? 4.w : 2.w,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ],
                  );
                }).toList(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 500,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(
                context,
                color: theme.colorScheme.primary,
                label: 'Intake (On Track)',
              ),
              SizedBox(width: 4.w),
              _buildLegendItem(
                context,
                color: theme.colorScheme.error,
                label: 'Intake (Over Goal)',
              ),
              SizedBox(width: 4.w),
              _buildLegendItem(
                context,
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                label: 'Goal',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context,
      {required Color color, required String label}) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}