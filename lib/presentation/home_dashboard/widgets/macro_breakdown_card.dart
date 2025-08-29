import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MacroBreakdownCard extends StatelessWidget {
  final int proteinGrams;
  final int proteinTarget;
  final int carbsGrams;
  final int carbsTarget;
  final int fatGrams;
  final int fatTarget;

  const MacroBreakdownCard({
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

    return Container(
      width: double.infinity,
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
            'Macronutrients',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _MacroItem(
                  label: 'Protein',
                  current: proteinGrams,
                  target: proteinTarget,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  unit: 'g',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _MacroItem(
                  label: 'Carbs',
                  current: carbsGrams,
                  target: carbsTarget,
                  color: AppTheme.secondaryLight,
                  unit: 'g',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _MacroItem(
                  label: 'Fat',
                  current: fatGrams,
                  target: fatTarget,
                  color: AppTheme.warningLight,
                  unit: 'g',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MacroItem extends StatefulWidget {
  final String label;
  final int current;
  final int target;
  final Color color;
  final String unit;

  const _MacroItem({
    required this.label,
    required this.current,
    required this.target,
    required this.color,
    required this.unit,
  });

  @override
  State<_MacroItem> createState() => _MacroItemState();
}

class _MacroItemState extends State<_MacroItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: (widget.current / widget.target).clamp(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void didUpdateWidget(_MacroItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.current != widget.current ||
        oldWidget.target != widget.target) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: (widget.current / widget.target).clamp(0.0, 1.0),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ));
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Text(
              '${widget.current}',
              style: theme.textTheme.titleSmall?.copyWith(
                color: widget.color,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
            Text(
              '/${widget.target}${widget.unit}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Container(
          height: 1.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(0.5.h),
          ),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progressAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(0.5.h),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
