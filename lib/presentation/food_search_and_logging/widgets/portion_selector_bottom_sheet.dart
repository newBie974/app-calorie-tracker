import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PortionSelectorBottomSheet extends StatefulWidget {
  final Map<String, dynamic> food;
  final Function(Map<String, dynamic>) onAddToLog;

  const PortionSelectorBottomSheet({
    super.key,
    required this.food,
    required this.onAddToLog,
  });

  @override
  State<PortionSelectorBottomSheet> createState() =>
      _PortionSelectorBottomSheetState();
}

class _PortionSelectorBottomSheetState
    extends State<PortionSelectorBottomSheet> {
  double _servingMultiplier = 1.0;
  String _selectedUnit = 'serving';
  final List<String> _servingUnits = [
    'serving',
    'cup',
    'gram',
    'piece',
    'tablespoon'
  ];

  @override
  Widget build(BuildContext context) {
    final calculatedCalories =
        ((widget.food["calories"] as int) * _servingMultiplier).round();
    final calculatedProtein =
        ((widget.food["protein"] as double) * _servingMultiplier);
    final calculatedCarbs =
        ((widget.food["carbs"] as double) * _servingMultiplier);
    final calculatedFat = ((widget.food["fat"] as double) * _servingMultiplier);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: widget.food["image"] as String,
                    width: 15.w,
                    height: 15.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.food["name"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.food["brand"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Divider(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2)),

          // Portion selector
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Serving Size',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),

                // Serving amount slider
                Row(
                  children: [
                    Text(
                      'Amount:',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Slider(
                        value: _servingMultiplier,
                        min: 0.25,
                        max: 5.0,
                        divisions: 19,
                        label: _servingMultiplier.toStringAsFixed(2),
                        onChanged: (value) {
                          setState(() {
                            _servingMultiplier = value;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: 15.w,
                      child: Text(
                        _servingMultiplier.toStringAsFixed(2),
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Unit selector
                Text(
                  'Unit:',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 2.w,
                  children: _servingUnits.map((unit) {
                    final isSelected = _selectedUnit == unit;
                    return FilterChip(
                      label: Text(unit),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedUnit = unit;
                        });
                      },
                      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                      selectedColor:
                          AppTheme.lightTheme.colorScheme.primaryContainer,
                      labelStyle:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimaryContainer
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 3.h),

                // Nutrition information
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primaryContainer
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Nutrition Information',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNutritionItem(
                              'Calories', calculatedCalories.toString(), 'cal'),
                          _buildNutritionItem('Protein',
                              calculatedProtein.toStringAsFixed(1), 'g'),
                          _buildNutritionItem(
                              'Carbs', calculatedCarbs.toStringAsFixed(1), 'g'),
                          _buildNutritionItem(
                              'Fat', calculatedFat.toStringAsFixed(1), 'g'),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 4.h),

                // Add to log button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final logEntry = {
                        ...widget.food,
                        'servingMultiplier': _servingMultiplier,
                        'selectedUnit': _selectedUnit,
                        'calculatedCalories': calculatedCalories,
                        'calculatedProtein': calculatedProtein,
                        'calculatedCarbs': calculatedCarbs,
                        'calculatedFat': calculatedFat,
                        'timestamp': DateTime.now(),
                      };
                      widget.onAddToLog(logEntry);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Add to Log ($calculatedCalories cal)',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 2.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          unit,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
