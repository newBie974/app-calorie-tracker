import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CalorieProgressRing extends StatefulWidget {
  final int consumedCalories;
  final int targetCalories;
  final VoidCallback? onTap;

  const CalorieProgressRing({
    super.key,
    required this.consumedCalories,
    required this.targetCalories,
    this.onTap,
  });

  @override
  State<CalorieProgressRing> createState() => _CalorieProgressRingState();
}

class _CalorieProgressRingState extends State<CalorieProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: (widget.consumedCalories / widget.targetCalories).clamp(0.0, 1.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void didUpdateWidget(CalorieProgressRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.consumedCalories != widget.consumedCalories ||
        oldWidget.targetCalories != widget.targetCalories) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: (widget.consumedCalories / widget.targetCalories).clamp(0.0, 1.0),
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

  Color _getProgressColor() {
    final progress = widget.consumedCalories / widget.targetCalories;
    if (progress <= 0.8) {
      return AppTheme.lightTheme.colorScheme.primary; // Green - on track
    } else if (progress <= 1.0) {
      return AppTheme.warningLight; // Yellow - approaching limit
    } else {
      return AppTheme.lightTheme.colorScheme.error; // Red - over target
    }
  }

  String _getMotivationalMessage() {
    final progress = widget.consumedCalories / widget.targetCalories;
    final remaining = widget.targetCalories - widget.consumedCalories;

    if (progress <= 0.5) {
      return "Great start! Keep it up!";
    } else if (progress <= 0.8) {
      return "You're doing well!";
    } else if (progress <= 1.0) {
      return "$remaining calories left";
    } else {
      final over = widget.consumedCalories - widget.targetCalories;
      return "$over calories over target";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining =
        math.max(0, widget.targetCalories - widget.consumedCalories);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 60.w,
        height: 60.w,
        padding: EdgeInsets.all(4.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow,
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),

            // Progress ring
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(52.w, 52.w),
                  painter: _ProgressRingPainter(
                    progress: _progressAnimation.value,
                    progressColor: _getProgressColor(),
                    backgroundColor:
                        theme.colorScheme.outline.withValues(alpha: 0.2),
                    strokeWidth: 2.w,
                  ),
                );
              },
            ),

            // Center content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  remaining.toString(),
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _getProgressColor(),
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'calories left',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getProgressColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getMotivationalMessage(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _getProgressColor(),
                      fontWeight: FontWeight.w500,
                      fontSize: 9.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  _ProgressRingPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2; // Start from top
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
