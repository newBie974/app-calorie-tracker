import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class WaterIntakeCard extends StatefulWidget {
  final int currentGlasses;
  final int targetGlasses;
  final VoidCallback? onGlassTap;

  const WaterIntakeCard({
    super.key,
    required this.currentGlasses,
    required this.targetGlasses,
    this.onGlassTap,
  });

  @override
  State<WaterIntakeCard> createState() => _WaterIntakeCardState();
}

class _WaterIntakeCardState extends State<WaterIntakeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleGlassTap() {
    HapticFeedback.lightImpact();
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onGlassTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress =
        (widget.currentGlasses / widget.targetGlasses).clamp(0.0, 1.0);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Water Intake',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${widget.currentGlasses}/${widget.targetGlasses} glasses',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: GestureDetector(
                      onTap: _handleGlassTap,
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'local_drink',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 6.w,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Progress bar
          Container(
            height: 1.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(0.75.h),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(0.75.h),
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),

          // Water glasses visualization
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(widget.targetGlasses, (index) {
              final isFilled = index < widget.currentGlasses;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: isFilled
                      ? AppTheme.lightTheme.colorScheme.primary
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'water_drop',
                  color: isFilled
                      ? Colors.white
                      : theme.colorScheme.onSurfaceVariant,
                  size: 3.w,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
