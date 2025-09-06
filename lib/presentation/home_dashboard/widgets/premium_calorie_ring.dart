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
    ).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
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
      ).animate(
        CurvedAnimation(parent: _ringController, curve: Curves.easeInOut),
      );
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
    final remainingCalories = widget.targetCalories - widget.consumedCalories;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 85.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with title and edit button
            Padding(
              padding: EdgeInsets.fromLTRB(6.w, 4.h, 6.w, 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Calories',
                    style: GoogleFonts.inter(
                      fontSize: 6.w,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle edit action
                    },
                    child: Text(
                      'Edit',
                      style: GoogleFonts.inter(
                        fontSize: 4.w,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Semi-circular progress ring with center content
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 70.w,
                    height: 35.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Semi-circular progress ring
                        AnimatedBuilder(
                          animation: _ringAnimation,
                          builder: (context, child) {
                            return CustomPaint(
                              size: Size(70.w, 35.w),
                              painter: SemiCircularRingPainter(
                                progress: _ringAnimation.value,
                              ),
                            );
                          },
                        ),

                        // Center content with flame icon and remaining calories
                        Positioned(
                          bottom: 5.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Flame icon
                              Container(
                                    width: 12.w,
                                    height: 12.w,
                                    decoration: BoxDecoration(
                                      gradient: AppTheme.primaryGradient,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.local_fire_department_rounded,
                                      size: 7.w,
                                      color: Colors.white,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 800.ms, delay: 1000.ms)
                                  .scale(
                                    begin: const Offset(0.5, 0.5),
                                    end: const Offset(1.0, 1.0),
                                    duration: 800.ms,
                                    delay: 1000.ms,
                                  ),

                              SizedBox(height: 2.h),

                              // Remaining calories text
                              Text(
                                    '$remainingCalories',
                                    style: GoogleFonts.inter(
                                      fontSize: 8.w,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.primaryGreen,
                                      height: 0.8,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(duration: 800.ms, delay: 1200.ms)
                                  .slideY(
                                    begin: 0.5,
                                    end: 0,
                                    duration: 800.ms,
                                    delay: 1200.ms,
                                  ),

                              Text(
                                'Remaining',
                                style: GoogleFonts.inter(
                                  fontSize: 4.w,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textSecondary,
                                ),
                              ).animate().fadeIn(
                                duration: 600.ms,
                                delay: 1400.ms,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Horizontal macro indicators
            Padding(
              padding: EdgeInsets.fromLTRB(6.w, 3.h, 6.w, 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Protein
                  _buildHorizontalMacroIndicator(
                    title: 'Protein',
                    current: 40,
                    target: 77,
                    unit: 'g',
                    color: Colors.orange,
                    icon: Icons.fitness_center_rounded,
                  ),

                  // Carbs
                  _buildHorizontalMacroIndicator(
                    title: 'Carbs',
                    current: 40,
                    target: 77,
                    unit: 'g',
                    color: AppTheme.accentBlue,
                    icon: Icons.restaurant_rounded,
                  ),

                  // Fat
                  _buildHorizontalMacroIndicator(
                    title: 'Fat',
                    current: 40,
                    target: 77,
                    unit: 'g',
                    color: AppTheme.primaryGreen,
                    icon: Icons.eco_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalMacroIndicator({
    required String title,
    required int current,
    required int target,
    required String unit,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        // Icon
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 5.w, color: color),
        ),

        SizedBox(height: 1.h),

        // Title
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 3.5.w,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),

        SizedBox(height: 0.5.h),

        // Values
        Text(
          '$current/$target$unit',
          style: GoogleFonts.inter(
            fontSize: 3.w,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

class SemiCircularRingPainter extends CustomPainter {
  final double progress;

  SemiCircularRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 12;

    // Background track
    final trackPaint =
        Paint()
          ..color = AppTheme.softGreen
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round;

    // Draw semi-circle background
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159, // Start from left (180 degrees)
      3.14159, // Draw 180 degrees (semi-circle)
      false,
      trackPaint,
    );

    // Progress arc
    final progressPaint =
        Paint()
          ..shader = AppTheme.primaryGradient.createShader(
            Rect.fromCircle(center: center, radius: radius),
          )
          ..style = PaintingStyle.stroke
          ..strokeWidth = 12
          ..strokeCap = StrokeCap.round;

    final sweepAngle = 3.14159 * (progress > 1 ? 1 : progress);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159, // Start from left
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(SemiCircularRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
