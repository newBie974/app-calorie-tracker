import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

class PremiumCalorieRing extends StatefulWidget {
  final int consumedCalories;
  final int targetCalories;
  final VoidCallback? onTap;

  const PremiumCalorieRing({
    super.key,
    required this.consumedCalories,
    required this.targetCalories,
    this.onTap,
  });

  @override
  State<PremiumCalorieRing> createState() => _PremiumCalorieRingState();
}

class _PremiumCalorieRingState extends State<PremiumCalorieRing>
    with TickerProviderStateMixin {
  late AnimationController _ringController;
  late AnimationController _pulseController;
  late Animation<double> _ringAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _ringController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _ringAnimation = Tween<double>(
      begin: 0.0,
      end: widget.consumedCalories / widget.targetCalories,
    ).animate(CurvedAnimation(
      parent: _ringController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _ringController.forward();
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PremiumCalorieRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.consumedCalories != widget.consumedCalories ||
        oldWidget.targetCalories != widget.targetCalories) {
      _ringAnimation = Tween<double>(
        begin: _ringAnimation.value,
        end: widget.consumedCalories / widget.targetCalories,
      ).animate(CurvedAnimation(
        parent: _ringController,
        curve: Curves.easeInOut,
      ));
      _ringController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ringController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.consumedCalories / widget.targetCalories;
    final remainingCalories = widget.targetCalories - widget.consumedCalories;
    final isOverTarget = remainingCalories < 0;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 70.w,
              height: 70.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background glow effect
                  Container(
                    width: 68.w,
                    height: 68.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppTheme.primaryGreen.withAlpha(26),
                          AppTheme.primaryGreen.withAlpha(13),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                    ),
                  ),

                  // Outer ring container
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                        BoxShadow(
                          color: AppTheme.primaryGreen.withAlpha(51),
                          blurRadius: 40,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),

                  // Progress ring
                  AnimatedBuilder(
                    animation: _ringAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size(55.w, 55.w),
                        painter: CalorieRingPainter(
                          progress: _ringAnimation.value,
                          isOverTarget: isOverTarget,
                        ),
                      );
                    },
                  ),

                  // Center content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Main calorie number
                      Text(
                        '${widget.consumedCalories}',
                        style: GoogleFonts.inter(
                          fontSize: 16.w,
                          fontWeight: FontWeight.w900,
                          color: isOverTarget
                              ? AppTheme.accentBlue
                              : AppTheme.primaryGreen,
                          height: 0.8,
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 800.ms, delay: 1000.ms)
                          .slideY(
                              begin: 0.5,
                              end: 0,
                              duration: 800.ms,
                              delay: 1000.ms),

                      // "calories" label
                      Text(
                        'calories',
                        style: GoogleFonts.inter(
                          fontSize: 4.w,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondary,
                        ),
                      ).animate().fadeIn(duration: 600.ms, delay: 1200.ms),

                      SizedBox(height: 2.h),

                      // Remaining/over calories
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: isOverTarget
                              ? AppTheme.accentBlue.withAlpha(26)
                              : AppTheme.softGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          isOverTarget
                              ? '${remainingCalories.abs()} over'
                              : '$remainingCalories left',
                          style: GoogleFonts.inter(
                            fontSize: 3.5.w,
                            fontWeight: FontWeight.w600,
                            color: isOverTarget
                                ? AppTheme.accentBlue
                                : AppTheme.primaryGreen,
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 600.ms, delay: 1400.ms)
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1.0, 1.0),
                            duration: 600.ms,
                            delay: 1400.ms,
                          ),
                    ],
                  ),

                  // Tap indicator
                  Positioned(
                    bottom: 4.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(26),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_circle_outline_rounded,
                            size: 4.w,
                            color: AppTheme.textSecondary,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Tap to add',
                            style: GoogleFonts.inter(
                              fontSize: 3.w,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 500.ms, delay: 1600.ms).slideY(
                        begin: 0.5, end: 0, duration: 500.ms, delay: 1600.ms),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CalorieRingPainter extends CustomPainter {
  final double progress;
  final bool isOverTarget;

  CalorieRingPainter({
    required this.progress,
    required this.isOverTarget,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;

    // Background track
    final trackPaint = Paint()
      ..color = AppTheme.softGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = isOverTarget
          ? LinearGradient(
              colors: [
                AppTheme.accentBlue,
                AppTheme.accentPurple,
              ],
            ).createShader(Rect.fromCircle(center: center, radius: radius))
          : AppTheme.calorieRingGradient
              .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    const startAngle = -90 * (3.14159 / 180); // Start from top
    final sweepAngle = 2 * 3.14159 * (progress > 1 ? 1 : progress);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    // If over target, draw additional arc
    if (progress > 1) {
      final overPaint = Paint()
        ..color = AppTheme.accentBlue.withAlpha(179)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round;

      final overSweep =
          2 * 3.14159 * ((progress - 1) > 0.5 ? 0.5 : (progress - 1));

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius + 6),
        startAngle,
        overSweep,
        false,
        overPaint,
      );
    }
  }

  @override
  bool shouldRepaint(CalorieRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isOverTarget != isOverTarget;
  }
}
