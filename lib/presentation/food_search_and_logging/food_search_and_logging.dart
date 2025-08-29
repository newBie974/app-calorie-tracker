import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/custom_entry_widget.dart';
import './widgets/favorites_section_widget.dart';
import './widgets/meal_category_tabs_widget.dart';
import './widgets/portion_selector_bottom_sheet.dart';
import './widgets/recent_foods_widget.dart';
import './widgets/recent_meals_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/search_results_widget.dart';

class FoodSearchAndLogging extends StatefulWidget {
  const FoodSearchAndLogging({super.key});

  @override
  State<FoodSearchAndLogging> createState() => _FoodSearchAndLoggingState();
}

class _FoodSearchAndLoggingState extends State<FoodSearchAndLogging> {
  String _searchQuery = '';
  String _selectedMealCategory = 'Breakfast';
  final List<Map<String, dynamic>> _loggedFoods = [];

  @override
  void initState() {
    super.initState();
    _setInitialMealCategory();
  }

  void _setInitialMealCategory() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 11) {
      _selectedMealCategory = 'Breakfast';
    } else if (hour >= 11 && hour < 16) {
      _selectedMealCategory = 'Lunch';
    } else if (hour >= 16 && hour < 21) {
      _selectedMealCategory = 'Dinner';
    } else {
      _selectedMealCategory = 'Snacks';
    }
  }

  void _handleSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _handleMealCategoryChanged(String category) {
    setState(() {
      _selectedMealCategory = category;
    });
  }

  void _handleFoodSelected(Map<String, dynamic> food) {
    HapticFeedback.lightImpact();
    _showPortionSelector(food);
  }

  void _handleMealSelected(Map<String, dynamic> meal) {
    HapticFeedback.lightImpact();

    // Add all foods from the meal to log
    final foods = meal["foods"] as List;
    for (final food in foods) {
      final logEntry = {
        'id': DateTime.now().millisecondsSinceEpoch + foods.indexOf(food),
        'name': food["name"],
        'brand': 'From ${meal["name"]}',
        'calories': food["calories"],
        'protein': 0.0,
        'carbs': 0.0,
        'fat': 0.0,
        'servingSize': '1 serving',
        'mealCategory': _selectedMealCategory,
        'timestamp': DateTime.now(),
      };
      _loggedFoods.add(logEntry);
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${meal["name"]} to $_selectedMealCategory'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            Navigator.pushNamed(context, '/home-dashboard');
          },
        ),
      ),
    );
  }

  void _handleToggleFavorite(Map<String, dynamic> food) {
    HapticFeedback.lightImpact();
    setState(() {
      food["isFavorite"] = !(food["isFavorite"] as bool);
    });

    final message = (food["isFavorite"] as bool)
        ? 'Added to favorites'
        : 'Removed from favorites';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleAddToLog(Map<String, dynamic> logEntry) {
    final updatedEntry = {
      ...logEntry,
      'mealCategory': _selectedMealCategory,
    };

    setState(() {
      _loggedFoods.add(updatedEntry);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${logEntry["name"]} to $_selectedMealCategory'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            Navigator.pushNamed(context, '/home-dashboard');
          },
        ),
      ),
    );
  }

  void _handleCustomEntry(Map<String, dynamic> customEntry) {
    _handleAddToLog(customEntry);
  }

  void _handleVoiceSearch() {
    HapticFeedback.lightImpact();
    // Voice search functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice search feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleBarcodeScanner() {
    HapticFeedback.lightImpact();
    // Barcode scanner functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Barcode scanner feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showPortionSelector(Map<String, dynamic> food) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: PortionSelectorBottomSheet(
          food: food,
          onAddToLog: _handleAddToLog,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: CustomFoodLogAppBar(
        onSearchTap: () {
          // Focus search bar or show search suggestions
        },
        onScanTap: _handleBarcodeScanner,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            SearchBarWidget(
              onSearchChanged: _handleSearchChanged,
              onVoiceSearch: _handleVoiceSearch,
              hintText: 'Search for foods, brands, or meals...',
            ),

            // Meal category tabs
            MealCategoryTabsWidget(
              onCategoryChanged: _handleMealCategoryChanged,
              selectedCategory: _selectedMealCategory,
            ),

            SizedBox(height: 2.h),

            // Content area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Search results (when searching)
                    if (_searchQuery.isNotEmpty)
                      SearchResultsWidget(
                        searchQuery: _searchQuery,
                        onFoodSelected: _handleFoodSelected,
                        onToggleFavorite: _handleToggleFavorite,
                      )
                    else ...[
                      // Recent foods
                      RecentFoodsWidget(
                        onFoodSelected: _handleFoodSelected,
                      ),

                      SizedBox(height: 2.h),

                      // Favorites section
                      FavoritesSectionWidget(
                        onFoodSelected: _handleFoodSelected,
                      ),

                      SizedBox(height: 2.h),

                      // Custom entry widget
                      CustomEntryWidget(
                        onAddCustomEntry: _handleCustomEntry,
                      ),

                      SizedBox(height: 2.h),

                      // Recent meals
                      RecentMealsWidget(
                        onMealSelected: _handleMealSelected,
                      ),
                    ],

                    SizedBox(height: 10.h), // Bottom padding for navigation
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 1),
      floatingActionButton: _loggedFoods.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/home-dashboard');
              },
              icon: CustomIconWidget(
                iconName: 'check',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text(
                'View Log (${_loggedFoods.length})',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }
}
