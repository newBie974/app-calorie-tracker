import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

class PremiumQuickStats extends StatefulWidget {
  final int waterGlasses;
  final int waterTarget;
  final int steps;
  final int stepsTarget;

  const PremiumQuickStats({
    super.key,
    required this.waterGlasses,
    required this.waterTarget,
    required this.steps,
    required this.stepsTarget,
  });

  @override
  State<PremiumQuickStats> createState() => _PremiumQuickStatsState();
}

class _PremiumQuickStatsState extends State<PremiumQuickStats>
    with TickerProviderStateMixin {
  late AnimationController _waterController;
  late AnimationController _stepsController;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _waterController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _stepsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      _waterController.forward();

      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        _stepsController.forward();
      }
    }
  }

  @override
  void dispose() {
    _waterController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Row(
        children: [
          // Water tracking card
          Expanded(
            child: _buildWaterCard(),
          ),

          SizedBox(width: 4.w),

          // Steps tracking card
          Expanded(
            child: _buildStepsCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildWaterCard() {
    final progress = widget.waterGlasses / widget.waterTarget;
    final remaining = widget.waterTarget - widget.waterGlasses;

    return Container(
      height: 20.h,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.softBlue,
            Color(0xFFE8F4FD),
            Colors.white,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentBlue.withAlpha(26),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue.withAlpha(26),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Icon(
                  Icons.local_drink_rounded,
                  size: 5.w,
                  color: AppTheme.accentBlue,
                ),
              ),
              Text(
                '${widget.waterGlasses}/${widget.waterTarget}',
                style: GoogleFonts.inter(
                  fontSize: 3.5.w,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentBlue,
                ),
              ),
            ],
          )
              .animate(controller: _waterController)
              .fadeIn(duration: 400.ms)
              .slideX(begin: -0.3, end: 0, duration: 400.ms),

          SizedBox(height: 2.h),

          // Water count
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${widget.waterGlasses}',
                style: GoogleFonts.inter(
                  fontSize: 8.w,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                  height: 0.9,
                ),
              )
                  .animate(controller: _waterController)
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.5, end: 0, duration: 600.ms, delay: 200.ms),
              SizedBox(width: 2.w),
              Padding(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: Text(
                  'glasses',
                  style: GoogleFonts.inter(
                    fontSize: 3.5.w,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              )
                  .animate(controller: _waterController)
                  .fadeIn(duration: 500.ms, delay: 400.ms),
            ],
          ),

          SizedBox(height: 2.h),

          // Water glasses visual
          Row(
            children: List.generate(widget.waterTarget, (index) {
              final isFilled = index < widget.waterGlasses;
              return Container(
                width: 4.w,
                height: 6.w,
                margin: EdgeInsets.only(right: 1.w),
                decoration: BoxDecoration(
                  color: isFilled
                      ? AppTheme.accentBlue
                      : AppTheme.accentBlue.withAlpha(51),
                  borderRadius: BorderRadius.circular(1.w),
                ),
              )
                  .animate(controller: _waterController)
                  .fadeIn(
                    duration: 300.ms,
                    delay: (600 + index * 100).ms,
                  )
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                    duration: 300.ms,
                    delay: (600 + index * 100).ms,
                  );
            }),
          ),

          const Spacer(),

          // Remaining text
          if (remaining > 0)
            Text(
              '$remaining more to go! 💧',
              style: GoogleFonts.inter(
                fontSize: 3.w,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            )
                .animate(controller: _waterController)
                .fadeIn(duration: 400.ms, delay: 1000.ms)
          else
            Text(
              'Goal achieved! 🎉',
              style: GoogleFonts.inter(
                fontSize: 3.w,
                fontWeight: FontWeight.w600,
                color: AppTheme.accentBlue,
              ),
            )
                .animate(controller: _waterController)
                .fadeIn(duration: 400.ms, delay: 1000.ms)
                .shimmer(duration: 2000.ms, delay: 1200.ms),
        ],
      ),
    );
  }

  Widget _buildStepsCard() {
    final progress = widget.steps / widget.stepsTarget;
    final remaining = widget.stepsTarget - widget.steps;
    final isComplete = remaining <= 0;

    return Container(
      height: 20.h,
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.softPurple,
            Color(0xFFF3E8FF),
            Colors.white,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentPurple.withAlpha(26),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple.withAlpha(26),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Icon(
                  Icons.directions_walk_rounded,
                  size: 5.w,
                  color: AppTheme.accentPurple,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: GoogleFonts.inter(
                  fontSize: 3.5.w,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accentPurple,
                ),
              ),
            ],
          )
              .animate(controller: _stepsController)
              .fadeIn(duration: 400.ms)
              .slideX(begin: 0.3, end: 0, duration: 400.ms),

          SizedBox(height: 2.h),

          // Steps count
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatSteps(widget.steps),
                style: GoogleFonts.inter(
                  fontSize: 7.w,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.textPrimary,
                  height: 0.9,
                ),
              )
                  .animate(controller: _stepsController)
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.5, end: 0, duration: 600.ms, delay: 200.ms),
              SizedBox(width: 2.w),
              Padding(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: Text(
                  'steps',
                  style: GoogleFonts.inter(
                    fontSize: 3.5.w,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
              )
                  .animate(controller: _stepsController)
                  .fadeIn(duration: 500.ms, delay: 400.ms),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress bar
          Container(
            height: 1.5.h,
            decoration: BoxDecoration(
              color: AppTheme.accentPurple.withAlpha(51),
              borderRadius: BorderRadius.circular(1.h),
            ),
            child: AnimatedBuilder(
              animation: _stepsController,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor:
                      _stepsController.value * (progress > 1 ? 1 : progress),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppTheme.accentPurple,
                          Color(0xFFBA68C8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(1.h),
                    ),
                  ),
                );
              },
            ),
          )
              .animate(controller: _stepsController)
              .fadeIn(duration: 500.ms, delay: 600.ms),

          const Spacer(),

          // Status text
          if (!isComplete)
            Text(
              '${_formatSteps(remaining)} to goal 🚶‍♂️',
              style: GoogleFonts.inter(
                fontSize: 3.w,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            )
                .animate(controller: _stepsController)
                .fadeIn(duration: 400.ms, delay: 1000.ms)
          else
            Text(
              'Goal smashed! 🏆',
              style: GoogleFonts.inter(
                fontSize: 3.w,
                fontWeight: FontWeight.w600,
                color: AppTheme.accentPurple,
              ),
            )
                .animate(controller: _stepsController)
                .fadeIn(duration: 400.ms, delay: 1000.ms)
                .shimmer(duration: 2000.ms, delay: 1200.ms),
        ],
      ),
    );
  }

  String _formatSteps(int steps) {
    if (steps >= 1000) {
      return '${(steps / 1000).toStringAsFixed(1)}k';
    }
    return steps.toString();
  }
}
