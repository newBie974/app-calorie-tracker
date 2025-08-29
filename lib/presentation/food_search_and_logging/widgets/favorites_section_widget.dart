import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FavoritesSectionWidget extends StatelessWidget {
  final Function(Map<String, dynamic>) onFoodSelected;

  const FavoritesSectionWidget({
    super.key,
    required this.onFoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> favoriteFoods = [
      {
        "id": 1,
        "name": "Grilled Chicken Breast",
        "brand": "Fresh Market",
        "calories": 165,
        "protein": 31.0,
        "carbs": 0.0,
        "fat": 3.6,
        "servingSize": "100g",
        "image":
            "https://images.pexels.com/photos/106343/pexels-photo-106343.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "isFavorite": true,
      },
      {
        "id": 3,
        "name": "Greek Yogurt",
        "brand": "Chobani",
        "calories": 59,
        "protein": 10.0,
        "carbs": 3.6,
        "fat": 0.4,
        "servingSize": "100g",
        "image":
            "https://images.pexels.com/photos/1435735/pexels-photo-1435735.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "isFavorite": true,
      },
      {
        "id": 7,
        "name": "Avocado",
        "brand": "Fresh Produce",
        "calories": 160,
        "protein": 2.0,
        "carbs": 8.5,
        "fat": 14.7,
        "servingSize": "100g",
        "image":
            "https://images.pexels.com/photos/557659/pexels-photo-557659.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "isFavorite": true,
      },
    ];

    if (favoriteFoods.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'favorite',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Favorites',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: favoriteFoods.length,
            itemBuilder: (context, index) {
              final food = favoriteFoods[index];
              return _buildFavoriteCard(context, food);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteCard(BuildContext context, Map<String, dynamic> food) {
    return Container(
      width: 35.w,
      margin: EdgeInsets.only(right: 3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.2),
          width: 1,
        ),
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
          onTap: () => onFoodSelected(food),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: food["image"] as String,
                        width: double.infinity,
                        height: 8.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 1.w,
                      right: 1.w,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.error,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomIconWidget(
                          iconName: 'favorite',
                          color: AppTheme.lightTheme.colorScheme.onError,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  food["name"] as String,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${food["calories"]} cal',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  food["servingSize"] as String,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
