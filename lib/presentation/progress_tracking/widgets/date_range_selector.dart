import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class DateRangeSelector extends StatelessWidget {
  final String selectedRange;
  final Function(String) onRangeChanged;

  const DateRangeSelector({
    super.key,
    required this.selectedRange,
    required this.onRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ranges = ['Week', 'Month', '3 Months'];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Row(
        children: ranges.map((range) {
          final isSelected = selectedRange == range;
          return Expanded(
            child: GestureDetector(
              onTap: () => onRangeChanged(range),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 1.w),
                padding: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: 1,
                  ),
                ),
                child: Text(
                  range,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
