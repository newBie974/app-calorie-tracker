import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentMealsWidget extends StatelessWidget {
  final Function(Map<String, dynamic>) onMealSelected;

  const RecentMealsWidget({
    super.key,
    required this.onMealSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recentMeals = [
      {
        "id": 1,
        "name": "Protein Power Bowl",
        "description": "Grilled chicken, quinoa, avocado, mixed greens",
        "totalCalories": 485,
        "mealType": "Lunch",
        "foods": [
          {"name": "Grilled Chicken Breast", "calories": 165},
          {"name": "Quinoa", "calories": 120},
          {"name": "Avocado", "calories": 160},
          {"name": "Mixed Greens", "calories": 40},
        ],
        "image":
            "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "lastLogged": "2 days ago",
      },
      {
        "id": 2,
        "name": "Greek Breakfast",
        "description": "Greek yogurt, banana, honey, granola",
        "totalCalories": 320,
        "mealType": "Breakfast",
        "foods": [
          {"name": "Greek Yogurt", "calories": 150},
          {"name": "Banana", "calories": 89},
          {"name": "Honey", "calories": 64},
          {"name": "Granola", "calories": 17},
        ],
        "image":
            "https://images.pexels.com/photos/1435735/pexels-photo-1435735.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "lastLogged": "1 week ago",
      },
      {
        "id": 3,
        "name": "Salmon Dinner",
        "description": "Grilled salmon, brown rice, steamed broccoli",
        "totalCalories": 425,
        "mealType": "Dinner",
        "foods": [
          {"name": "Salmon Fillet", "calories": 208},
          {"name": "Brown Rice", "calories": 111},
          {"name": "Steamed Broccoli", "calories": 106},
        ],
        "image":
            "https://images.pexels.com/photos/1516415/pexels-photo-1516415.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "lastLogged": "3 days ago",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'history',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Recent Meals',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          itemCount: recentMeals.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final meal = recentMeals[index];
            return _buildRecentMealCard(context, meal);
          },
        ),
      ],
    );
  }

  Widget _buildRecentMealCard(BuildContext context, Map<String, dynamic> meal) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onMealSelected(meal),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: meal["image"] as String,
                    width: 18.w,
                    height: 18.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              meal["name"] as String,
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildMealTypeChip(meal["mealType"] as String),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        meal["description"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Text(
                            '${meal["totalCalories"]} cal total',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            meal["lastLogged"] as String,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${(meal["foods"] as List).length} items',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomIconWidget(
                  iconName: 'add_circle_outline',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealTypeChip(String mealType) {
    Color chipColor;
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        chipColor = Colors.orange;
        break;
      case 'lunch':
        chipColor = AppTheme.lightTheme.colorScheme.primary;
        break;
      case 'dinner':
        chipColor = Colors.purple;
        break;
      case 'snacks':
        chipColor = Colors.amber;
        break;
      default:
        chipColor = AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: chipColor, width: 1),
      ),
      child: Text(
        mealType,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: chipColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
