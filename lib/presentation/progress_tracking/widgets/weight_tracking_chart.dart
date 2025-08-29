import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class WeightTrackingChart extends StatefulWidget {
  final String selectedRange;

  const WeightTrackingChart({
    super.key,
    required this.selectedRange,
  });

  @override
  State<WeightTrackingChart> createState() => _WeightTrackingChartState();
}

class _WeightTrackingChartState extends State<WeightTrackingChart> {
  List<FlSpot> get weightData {
    switch (widget.selectedRange) {
      case 'Week':
        return [
          const FlSpot(0, 75.2),
          const FlSpot(1, 75.0),
          const FlSpot(2, 74.8),
          const FlSpot(3, 74.9),
          const FlSpot(4, 74.6),
          const FlSpot(5, 74.4),
          const FlSpot(6, 74.2),
        ];
      case 'Month':
        return [
          const FlSpot(0, 76.0),
          const FlSpot(1, 75.2),
          const FlSpot(2, 74.8),
          const FlSpot(3, 74.2),
        ];
      case '3 Months':
        return [
          const FlSpot(0, 78.5),
          const FlSpot(1, 76.8),
          const FlSpot(2, 74.2),
        ];
      default:
        return [];
    }
  }

  List<String> get xAxisLabels {
    switch (widget.selectedRange) {
      case 'Week':
        return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      case 'Month':
        return ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
      case '3 Months':
        return ['Month 1', 'Month 2', 'Month 3'];
      default:
        return [];
    }
  }

  void _showAddWeightDialog() {
    final TextEditingController weightController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(
            'Add Weight Entry',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  hintText: 'Enter your weight',
                  suffixText: 'kg',
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Date: ${DateTime.now().toString().split(' ')[0]}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (weightController.text.isNotEmpty) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Weight entry added: ${weightController.text} kg'),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = weightData;
    final labels = xAxisLabels;

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
                'Weight Progress',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              FloatingActionButton.small(
                onPressed: _showAddWeightDialog,
                backgroundColor: theme.colorScheme.primary,
                child: CustomIconWidget(
                  iconName: 'add',
                  color: theme.colorScheme.onPrimary,
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 25.h,
            child: data.isNotEmpty
                ? LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 0.5,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.2),
                            strokeWidth: 1,
                          );
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
                              final index = value.toInt();
                              if (index >= 0 && index < labels.length) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: Text(
                                    labels[index],
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
                            interval: 1,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              return Text(
                                '${value.toStringAsFixed(1)}kg',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              );
                            },
                            reservedSize: 12.w,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX: (data.length - 1).toDouble(),
                      minY: data
                              .map((spot) => spot.y)
                              .reduce((a, b) => a < b ? a : b) -
                          1,
                      maxY: data
                              .map((spot) => spot.y)
                              .reduce((a, b) => a > b ? a : b) +
                          1,
                      lineBarsData: [
                        LineChartBarData(
                          spots: data,
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withValues(alpha: 0.7),
                            ],
                          ),
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 4,
                                color: theme.colorScheme.primary,
                                strokeWidth: 2,
                                strokeColor: theme.colorScheme.surface,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary
                                    .withValues(alpha: 0.2),
                                theme.colorScheme.primary
                                    .withValues(alpha: 0.05),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipBgColor: theme.colorScheme.inverseSurface,
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              final index = barSpot.x.toInt();
                              final label =
                                  index < labels.length ? labels[index] : '';
                              return LineTooltipItem(
                                '$label\n${barSpot.y.toStringAsFixed(1)} kg',
                                theme.textTheme.bodySmall!.copyWith(
                                  color: theme.colorScheme.onInverseSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'monitor_weight',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'No weight data available',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Tap + to add your first weight entry',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          if (data.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeightStat(
                  context,
                  'Current',
                  '${data.last.y.toStringAsFixed(1)} kg',
                  theme.colorScheme.primary,
                ),
                _buildWeightStat(
                  context,
                  'Change',
                  '${(data.last.y - data.first.y).toStringAsFixed(1)} kg',
                  data.last.y < data.first.y
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                ),
                _buildWeightStat(
                  context,
                  'Goal',
                  '70.0 kg',
                  theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWeightStat(
      BuildContext context, String label, String value, Color color) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
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