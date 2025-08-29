import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../theme/app_theme.dart';

class PremiumRecentMeals extends StatefulWidget {
  const PremiumRecentMeals({super.key});

  @override
  State<PremiumRecentMeals> createState() => _PremiumRecentMealsState();
}

class _PremiumRecentMealsState extends State<PremiumRecentMeals>
    with TickerProviderStateMixin {
  late List<AnimationController> _mealControllers;

  final List<Map<String, dynamic>> _recentMeals = [
    {
      'name': 'Grilled Chicken Salad',
      'time': '12:30 PM',
      'calories': 450,
      'mealType': 'Lunch',
      'image':
          'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=300&h=300&fit=crop&crop=center',
      'color': AppTheme.primaryGreen,
    },
    {
      'name': 'Greek Yogurt & Berries',
      'time': '7:30 AM',
      'calories': 280,
      'mealType': 'Breakfast',
      'image':
          'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=300&h=300&fit=crop&crop=center',
      'color': AppTheme.accentBlue,
    },
    {
      'name': 'Quinoa Buddha Bowl',
      'time': '6:45 PM',
      'calories': 520,
      'mealType': 'Dinner',
      'image':
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=300&h=300&fit=crop&crop=center',
      'color': AppTheme.accentPurple,
    },
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _mealControllers = List.generate(
      _recentMeals.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    for (int i = 0; i < _mealControllers.length; i++) {
      await Future.delayed(Duration(milliseconds: i * 150));
      if (mounted) {
        _mealControllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _mealControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _recentMeals.length,
        separatorBuilder: (context, index) => SizedBox(width: 4.w),
        itemBuilder: (context, index) {
          final meal = _recentMeals[index];
          return _buildMealCard(meal, index);
        },
      ),
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal, int index) {
    return GestureDetector(
      onTap: () {
        // Navigate to meal details or edit
      },
      child: Container(
        width: 60.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: meal['color'].withAlpha(26),
              blurRadius: 30,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Container(
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: meal['image'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: AppTheme.softGreen,
                          highlightColor: Colors.white,
                          child: Container(
                            color: AppTheme.softGreen,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                meal['color'],
                                meal['color'].withAlpha(179),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.restaurant_rounded,
                              size: 10.w,
                              color: Colors.white.withAlpha(179),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Meal type badge
                  Positioned(
                    top: 3.w,
                    left: 3.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: meal['color'],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        meal['mealType'],
                        style: GoogleFonts.inter(
                          fontSize: 2.8.w,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Calorie badge
                  Positioned(
                    top: 3.w,
                    right: 3.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.5.w,
                        vertical: 0.8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(26),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${meal['calories']} cal',
                        style: GoogleFonts.inter(
                          fontSize: 2.8.w,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Meal info
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Meal name
                    Text(
                      meal['name'],
                      style: GoogleFonts.inter(
                        fontSize: 4.w,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Time and quick actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 4.w,
                              color: AppTheme.textSecondary,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              meal['time'],
                              style: GoogleFonts.inter(
                                fontSize: 3.2.w,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        // Quick action buttons
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Edit meal
                              },
                              child: Container(
                                padding: EdgeInsets.all(1.5.w),
                                decoration: BoxDecoration(
                                  color: meal['color'].withAlpha(26),
                                  borderRadius: BorderRadius.circular(1.5.w),
                                ),
                                child: Icon(
                                  Icons.edit_rounded,
                                  size: 3.5.w,
                                  color: meal['color'],
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            GestureDetector(
                              onTap: () {
                                // Add to favorites
                              },
                              child: Container(
                                padding: EdgeInsets.all(1.5.w),
                                decoration: BoxDecoration(
                                  color: AppTheme.textSecondary.withAlpha(26),
                                  borderRadius: BorderRadius.circular(1.5.w),
                                ),
                                child: Icon(
                                  Icons.favorite_border_rounded,
                                  size: 3.5.w,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          .animate(controller: _mealControllers[index])
          .fadeIn(
            duration: 400.ms,
          )
          .slideY(
            begin: 0.3,
            end: 0,
            duration: 400.ms,
            curve: Curves.easeOut,
          )
          .scale(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
            duration: 400.ms,
            curve: Curves.easeOut,
          ),
    );
  }
}
