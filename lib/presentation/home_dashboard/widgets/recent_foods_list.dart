import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentFoodsList extends StatelessWidget {
  final List<Map<String, dynamic>> recentFoods;
  final Function(Map<String, dynamic>)? onFoodTap;

  const RecentFoodsList({
    super.key,
    required this.recentFoods,
    this.onFoodTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (recentFoods.isEmpty) {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.all(6.w),
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
            CustomIconWidget(
              iconName: 'history',
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 12.w,
            ),
            SizedBox(height: 2.h),
            Text(
              'No Recent Foods',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Start logging your meals to see quick access to your favorite foods here',
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Foods',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(context, '/food-search-and-logging');
                  },
                  child: Text(
                    'See All',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 20.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              itemCount: recentFoods.length,
              itemBuilder: (context, index) {
                final food = recentFoods[index];
                return _RecentFoodCard(
                  food: food,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onFoodTap?.call(food);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentFoodCard extends StatefulWidget {
  final Map<String, dynamic> food;
  final VoidCallback? onTap;

  const _RecentFoodCard({
    required this.food,
    this.onTap,
  });

  @override
  State<_RecentFoodCard> createState() => _RecentFoodCardState();
}

class _RecentFoodCardState extends State<_RecentFoodCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
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

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foodName = widget.food['name'] as String? ?? 'Unknown Food';
    final calories = widget.food['calories'] as int? ?? 0;
    final imageUrl = widget.food['image'] as String?;
    final category = widget.food['category'] as String? ?? 'Food';

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: _handleTap,
            child: Container(
              width: 35.w,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
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
                  // Food image
                  Container(
                    height: 10.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                      color: theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: imageUrl != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: CustomImageWidget(
                              imageUrl: imageUrl,
                              width: double.infinity,
                              height: 10.h,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Center(
                            child: CustomIconWidget(
                              iconName: 'restaurant',
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                              size: 8.w,
                            ),
                          ),
                  ),

                  // Food details
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foodName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            category,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$calories cal',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
