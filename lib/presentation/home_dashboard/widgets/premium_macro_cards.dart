import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

class PremiumMacroCards extends StatefulWidget {
  final int proteinGrams;
  final int proteinTarget;
  final int carbsGrams;
  final int carbsTarget;
  final int fatGrams;
  final int fatTarget;

  const PremiumMacroCards({
    super.key,
    required this.proteinGrams,
    required this.proteinTarget,
    required this.carbsGrams,
    required this.carbsTarget,
    required this.fatGrams,
    required this.fatTarget,
  });

  @override
  State<PremiumMacroCards> createState() => _PremiumMacroCardsState();
}

class _PremiumMacroCardsState extends State<PremiumMacroCards>
    with TickerProviderStateMixin {
  late List<AnimationController> _progressControllers;
  late List<Animation<double>> _progressAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _progressControllers = List.generate(
      3,
      (index) => AnimationController(
        duration: Duration(milliseconds: 1500 + (index * 200)),
        vsync: this,
      ),
    );

    _progressAnimations = _progressControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 400));
    for (int i = 0; i < _progressControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 150));
      if (mounted) {
        _progressControllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _progressControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Row(
        children: [
          // Protein card
          Expanded(
            child: _buildMacroCard(
              title: 'Protein',
              current: widget.proteinGrams,
              target: widget.proteinTarget,
              unit: 'g',
              color: AppTheme.accentBlue,
              gradient: AppTheme.macroProteinGradient,
              icon: Icons.fitness_center_rounded,
              animationIndex: 0,
            ),
          ),

          SizedBox(width: 3.w),

          // Carbs card
          Expanded(
            child: _buildMacroCard(
              title: 'Carbs',
              current: widget.carbsGrams,
              target: widget.carbsTarget,
              unit: 'g',
              color: AppTheme.accentPurple,
              gradient: AppTheme.macroCarbGradient,
              icon: Icons.grain_rounded,
              animationIndex: 1,
            ),
          ),

          SizedBox(width: 3.w),

          // Fat card
          Expanded(
            child: _buildMacroCard(
              title: 'Fat',
              current: widget.fatGrams,
              target: widget.fatTarget,
              unit: 'g',
              color: Colors.orange,
              gradient: AppTheme.macroFatGradient,
              icon: Icons.water_drop_rounded,
              animationIndex: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard({
    required String title,
    required int current,
    required int target,
    required String unit,
    required Color color,
    required LinearGradient gradient,
    required IconData icon,
    required int animationIndex,
  }) {
    final progress = current / target;
    final isComplete = progress >= 1.0;

    return Container(
      height: 28.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: color.withAlpha(26),
            blurRadius: 40,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background gradient overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 8.h,
                decoration: BoxDecoration(
                  gradient: gradient.scale(0.3),
                ),
              ),
            ),

            // Main content
            Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon and title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(230),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: Icon(
                          icon,
                          size: 5.w,
                          color: color,
                        ),
                      ),
                      if (isComplete)
                        Container(
                          padding: EdgeInsets.all(1.5.w),
                          decoration: BoxDecoration(
                            color: color.withAlpha(26),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            size: 4.w,
                            color: color,
                          ),
                        ).animate().scale(
                              begin: const Offset(0.5, 0.5),
                              end: const Offset(1.0, 1.0),
                              duration: 400.ms,
                              delay: 2000.ms,
                              curve: Curves.bounceOut,
                            ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Current value
                  Text(
                    '$current',
                    style: GoogleFonts.inter(
                      fontSize: 7.w,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                      height: 0.9,
                    ),
                  )
                      .animate()
                      .fadeIn(
                        duration: 600.ms,
                        delay: (800 + animationIndex * 200).ms,
                      )
                      .slideY(
                        begin: 0.5,
                        end: 0,
                        duration: 600.ms,
                        delay: (800 + animationIndex * 200).ms,
                      ),

                  // Unit and target
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: unit,
                          style: GoogleFonts.inter(
                            fontSize: 3.w,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        TextSpan(
                          text: ' / $target$unit',
                          style: GoogleFonts.inter(
                            fontSize: 2.8.w,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(
                        duration: 500.ms,
                        delay: (1000 + animationIndex * 200).ms,
                      ),

                  SizedBox(height: 3.h),

                  // Progress bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 3.5.w,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),

                      SizedBox(height: 1.h),

                      // Progress track
                      Container(
                        height: 1.5.h,
                        decoration: BoxDecoration(
                          color: color.withAlpha(26),
                          borderRadius: BorderRadius.circular(1.h),
                        ),
                        child: AnimatedBuilder(
                          animation: _progressAnimations[animationIndex],
                          builder: (context, child) {
                            return FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor:
                                  _progressAnimations[animationIndex].value *
                                      (progress > 1 ? 1 : progress),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: gradient,
                                  borderRadius: BorderRadius.circular(1.h),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 1.h),

                      // Progress percentage
                      Text(
                        '${(progress * 100).round()}%',
                        style: GoogleFonts.inter(
                          fontSize: 3.w,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ).animate().fadeIn(
                            duration: 400.ms,
                            delay: (1400 + animationIndex * 200).ms,
                          ),
                    ],
                  ),
                ],
              ),
            ),

            // Shimmer effect for completed macros
            if (isComplete)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: const Alignment(-1.0, -0.3),
                      end: const Alignment(1.0, 0.3),
                      colors: [
                        Colors.transparent,
                        color.withAlpha(26),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                      duration: 2000.ms,
                      delay: 2500.ms,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}

extension LinearGradientExtension on LinearGradient {
  LinearGradient scale(double opacity) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: colors.map((color) => color.withOpacity(opacity)).toList(),
      stops: stops,
    );
  }
}
