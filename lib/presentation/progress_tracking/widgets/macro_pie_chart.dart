import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class MacroPieChart extends StatefulWidget {
  final String selectedRange;

  const MacroPieChart({
    super.key,
    required this.selectedRange,
  });

  @override
  State<MacroPieChart> createState() => _MacroPieChartState();
}

class _MacroPieChartState extends State<MacroPieChart> {
  int touchedIndex = -1;

  Map<String, dynamic> get macroData {
    switch (widget.selectedRange) {
      case 'Week':
        return {
          'protein': {'value': 25.0, 'grams': 125},
          'carbs': {'value': 45.0, 'grams': 225},
          'fat': {'value': 30.0, 'grams': 67},
        };
      case 'Month':
        return {
          'protein': {'value': 28.0, 'grams': 140},
          'carbs': {'value': 42.0, 'grams': 210},
          'fat': {'value': 30.0, 'grams': 67},
        };
      case '3 Months':
        return {
          'protein': {'value': 30.0, 'grams': 150},
          'carbs': {'value': 40.0, 'grams': 200},
          'fat': {'value': 30.0, 'grams': 67},
        };
      default:
        return {
          'protein': {'value': 25.0, 'grams': 125},
          'carbs': {'value': 45.0, 'grams': 225},
          'fat': {'value': 30.0, 'grams': 67},
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = macroData;

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
            'Macronutrient Distribution',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 25.h,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 8.w,
                      sections: _buildPieChartSections(context, data),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(
                      context,
                      color: theme.colorScheme.primary,
                      label: 'Protein',
                      percentage: data['protein']['value'],
                      grams: data['protein']['grams'],
                    ),
                    SizedBox(height: 2.h),
                    _buildLegendItem(
                      context,
                      color: theme.colorScheme.secondary,
                      label: 'Carbs',
                      percentage: data['carbs']['value'],
                      grams: data['carbs']['grams'],
                    ),
                    SizedBox(height: 2.h),
                    _buildLegendItem(
                      context,
                      color: theme.colorScheme.tertiary,
                      label: 'Fat',
                      percentage: data['fat']['value'],
                      grams: data['fat']['grams'],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroStat(
                  context,
                  'Total Calories',
                  '2,000',
                  'kcal',
                ),
                _buildMacroStat(
                  context,
                  'Avg Daily',
                  widget.selectedRange == 'Week' ? '286' : '500',
                  'kcal',
                ),
                _buildMacroStat(
                  context,
                  'Goal Met',
                  '85',
                  '%',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
      BuildContext context, Map<String, dynamic> data) {
    final theme = Theme.of(context);
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
    ];
    final labels = ['protein', 'carbs', 'fat'];

    return labels.asMap().entries.map((entry) {
      final index = entry.key;
      final label = entry.value;
      final isTouched = index == touchedIndex;
      final radius = isTouched ? 12.w : 10.w;
      final fontSize = isTouched ? 14.sp : 12.sp;

      return PieChartSectionData(
        color: colors[index],
        value: data[label]['value'],
        title: '${data[label]['value'].toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: theme.textTheme.labelMedium?.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onPrimary,
        ),
        badgeWidget: isTouched
            ? Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  '${data[label]['grams']}g',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : null,
        badgePositionPercentageOffset: 1.2,
      );
    }).toList();
  }

  Widget _buildLegendItem(
    BuildContext context, {
    required Color color,
    required String label,
    required double percentage,
    required int grams,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(0)}% (${grams}g)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMacroStat(
      BuildContext context, String label, String value, String unit) {
    final theme = Theme.of(context);
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
            children: [
              TextSpan(
                text: ' $unit',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
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
