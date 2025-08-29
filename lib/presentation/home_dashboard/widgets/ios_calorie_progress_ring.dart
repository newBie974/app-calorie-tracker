import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class IOSCalorieProgressRing extends StatefulWidget {
  final int consumedCalories;
  final int targetCalories;
  final VoidCallback onTap;

  const IOSCalorieProgressRing({
    super.key,
    required this.consumedCalories,
    required this.targetCalories,
    required this.onTap,
  });

  @override
  State<IOSCalorieProgressRing> createState() => _IOSCalorieProgressRingState();
}

class _IOSCalorieProgressRingState extends State<IOSCalorieProgressRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.consumedCalories / widget.targetCalories,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = widget.targetCalories - widget.consumedCalories;
    final isOverTarget = remaining < 0;
    final displayRemaining = isOverTarget ? remaining.abs() : remaining;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 70.w,
        height: 70.w,
        margin: EdgeInsets.symmetric(vertical: 3.h),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.surfaceLight,
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight.withValues(alpha: 0.1),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Progress Ring
            SizedBox(
              width: 60.w,
              height: 60.w,
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: IOSProgressRingPainter(
                      progress: _progressAnimation.value,
                      strokeWidth: 8.0,
                      backgroundColor: AppTheme.lightBlueLight,
                      progressColor: isOverTarget
                          ? AppTheme.errorLight
                          : AppTheme.primaryLight,
                    ),
                  );
                },
              ),
            ),

            // Center Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  displayRemaining.toString(),
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w700,
                    color: isOverTarget
                        ? AppTheme.errorLight
                        : AppTheme.textPrimaryLight,
                    height: 1.0,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  isOverTarget ? 'Over' : 'Remaining',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondaryLight,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: AppTheme.mintLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Calories',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryLight,
                    ),
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

class IOSProgressRingPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color backgroundColor;
  final Color progressColor;

  IOSProgressRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background ring
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress ring
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = progressColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      const startAngle = -90 * (3.14159 / 180); // Start from top
      final sweepAngle = 2 * 3.14159 * progress.clamp(0.0, 1.0);

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
