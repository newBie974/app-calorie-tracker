import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MealCategoryTabsWidget extends StatefulWidget {
  final Function(String) onCategoryChanged;
  final String selectedCategory;

  const MealCategoryTabsWidget({
    super.key,
    required this.onCategoryChanged,
    this.selectedCategory = 'Breakfast',
  });

  @override
  State<MealCategoryTabsWidget> createState() => _MealCategoryTabsWidgetState();
}

class _MealCategoryTabsWidgetState extends State<MealCategoryTabsWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _categories = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _categories.length,
      vsync: this,
      initialIndex: _categories.indexOf(widget.selectedCategory),
    );
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      widget.onCategoryChanged(_categories[_tabController.index]);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: _categories.map((category) => Tab(text: category)).toList(),
        labelColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedLabelColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        indicator: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(6),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle:
            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        padding: EdgeInsets.all(1.w),
      ),
    );
  }
}
