import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchResultsWidget extends StatelessWidget {
  final String searchQuery;
  final Function(Map<String, dynamic>) onFoodSelected;
  final Function(Map<String, dynamic>) onToggleFavorite;

  const SearchResultsWidget({
    super.key,
    required this.searchQuery,
    required this.onFoodSelected,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (searchQuery.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<Map<String, dynamic>> searchResults =
        _getFilteredResults(searchQuery);

    if (searchResults.isEmpty) {
      return _buildNoResultsWidget();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Text(
            'Search Results (${searchResults.length})',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          itemCount: searchResults.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final food = searchResults[index];
            return _buildSearchResultCard(context, food);
          },
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getFilteredResults(String query) {
    final List<Map<String, dynamic>> allFoods = [
      {
        "id": 1,
        "name": "Grilled Chicken Breast",
        "brand": "Fresh Market",
        "calories": 165,
        "protein": 31.0,
        "carbs": 0.0,
        "fat": 3.6,
        "servingSize": "100g",
        "nutritionGrade": "A",
        "image":
            "https://images.pexels.com/photos/106343/pexels-photo-106343.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "isFavorite": true,
      },
      {
        "id": 2,
        "name": "Brown Rice",
        "brand": "Organic Valley",
        "calories": 111,
        "protein": 2.6,
        "carbs": 23.0,
        "fat": 0.9,
        "servingSize": "100g",
        "nutritionGrade": "B",
        "image":
            "https://images.pexels.com/photos/723198/pexels-photo-723198.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "isFavorite": false,
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
        "nutritionGrade": "A",
        "image":
            "https://images.pexels.com/photos/1435735/pexels-photo-1435735.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "isFavorite": true,
      },
      {
        "id": 4,
        "name": "Banana",
        "brand": "Fresh Produce",
        "calories": 89,
        "protein": 1.1,
        "carbs": 22.8,
        "fat": 0.3,
        "servingSize": "1 medium",
        "nutritionGrade": "A",
        "image":
            "https://images.pexels.com/photos/2872755/pexels-photo-2872755.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "isFavorite": false,
      },
      {
        "id": 5,
        "name": "Salmon Fillet",
        "brand": "Ocean Fresh",
        "calories": 208,
        "protein": 25.4,
        "carbs": 0.0,
        "fat": 12.4,
        "servingSize": "100g",
        "nutritionGrade": "A",
        "image":
            "https://images.pexels.com/photos/1516415/pexels-photo-1516415.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "isFavorite": false,
      },
      {
        "id": 6,
        "name": "Quinoa",
        "brand": "Organic Grains",
        "calories": 120,
        "protein": 4.4,
        "carbs": 22.0,
        "fat": 1.9,
        "servingSize": "100g",
        "nutritionGrade": "A",
        "image":
            "https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "isFavorite": false,
      },
    ];

    return (allFoods as List)
        .where((food) {
          final name = (food["name"] as String).toLowerCase();
          final brand = (food["brand"] as String).toLowerCase();
          final queryLower = query.toLowerCase();
          return name.contains(queryLower) || brand.contains(queryLower);
        })
        .cast<Map<String, dynamic>>()
        .toList();
  }

  Widget _buildNoResultsWidget() {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No foods found',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Try searching with different keywords or add a custom entry',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(
      BuildContext context, Map<String, dynamic> food) {
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
          onTap: () => onFoodSelected(food),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomImageWidget(
                    imageUrl: food["image"] as String,
                    width: 15.w,
                    height: 15.w,
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
                              food["name"] as String,
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildNutritionGrade(
                              food["nutritionGrade"] as String),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        food["brand"] as String,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Text(
                            '${food["calories"]} cal',
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'per ${food["servingSize"]}',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          _buildMacroChip('P: ${food["protein"]}g'),
                          SizedBox(width: 2.w),
                          _buildMacroChip('C: ${food["carbs"]}g'),
                          SizedBox(width: 2.w),
                          _buildMacroChip('F: ${food["fat"]}g'),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => onToggleFavorite(food),
                  icon: CustomIconWidget(
                    iconName: (food["isFavorite"] as bool)
                        ? 'favorite'
                        : 'favorite_border',
                    color: (food["isFavorite"] as bool)
                        ? AppTheme.lightTheme.colorScheme.error
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionGrade(String grade) {
    Color gradeColor;
    switch (grade) {
      case 'A':
        gradeColor = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      case 'B':
        gradeColor = Colors.orange;
        break;
      case 'C':
        gradeColor = Colors.amber;
        break;
      default:
        gradeColor = AppTheme.lightTheme.colorScheme.error;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: gradeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: gradeColor, width: 1),
      ),
      child: Text(
        grade,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: gradeColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildMacroChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primaryContainer
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
          color: AppTheme.lightTheme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
