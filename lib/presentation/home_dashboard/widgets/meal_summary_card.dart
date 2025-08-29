import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MealSummaryCard extends StatefulWidget {
  final String mealType;
  final int calories;
  final int targetCalories;
  final List<Map<String, dynamic>> recentItems;
  final VoidCallback? onAddFood;
  final bool isExpanded;
  final VoidCallback? onToggleExpanded;

  const MealSummaryCard({
    super.key,
    required this.mealType,
    required this.calories,
    required this.targetCalories,
    required this.recentItems,
    this.onAddFood,
    this.isExpanded = false,
    this.onToggleExpanded,
  });

  @override
  State<MealSummaryCard> createState() => _MealSummaryCardState();
}

class _MealSummaryCardState extends State<MealSummaryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (widget.isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(MealSummaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isExpanded != widget.isExpanded) {
      if (widget.isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  IconData _getMealIcon() {
    switch (widget.mealType.toLowerCase()) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      case 'snacks':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
  }

  Color _getMealColor() {
    switch (widget.mealType.toLowerCase()) {
      case 'breakfast':
        return AppTheme.warningLight;
      case 'lunch':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'dinner':
        return AppTheme.secondaryLight;
      case 'snacks':
        return AppTheme.lightTheme.colorScheme.tertiary;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  void _handleAddFood() {
    HapticFeedback.lightImpact();
    widget.onAddFood?.call();
  }

  void _handleToggleExpanded() {
    HapticFeedback.selectionClick();
    widget.onToggleExpanded?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mealColor = _getMealColor();
    final progress = widget.targetCalories > 0
        ? (widget.calories / widget.targetCalories).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
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
        children: [
          // Header
          GestureDetector(
            onTap: _handleToggleExpanded,
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: mealColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: _getMealIcon().codePoint.toString(),
                      color: mealColor,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.mealType,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${widget.calories} / ${widget.targetCalories} cal',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _handleAddFood,
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: mealColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'add',
                        color: mealColor,
                        size: 5.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  AnimatedRotation(
                    turns: widget.isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Progress bar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(0.25.h),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: mealColor,
                  borderRadius: BorderRadius.circular(0.25.h),
                ),
              ),
            ),
          ),

          // Expandable content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: widget.recentItems.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 2.h),
                        Text(
                          'Recent Items',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        ...widget.recentItems
                            .take(3)
                            .map((item) => _buildFoodItem(context, item)),
                      ],
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: Column(
                        children: [
                          CustomIconWidget(
                            iconName: 'restaurant_menu',
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5),
                            size: 8.w,
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'No items logged yet',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            'Tap + to add your first ${widget.mealType.toLowerCase()} item',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] as String? ?? 'Unknown Food',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${item['portion'] as String? ?? '1 serving'} • ${item['calories'] as int? ?? 0} cal',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          CustomIconWidget(
            iconName: 'chevron_right',
            color: theme.colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
        ],
      ),
    );
  }
}
