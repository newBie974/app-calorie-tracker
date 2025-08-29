import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/achievement_badges.dart';
import './widgets/date_range_selector.dart';
import './widgets/macro_pie_chart.dart';
import './widgets/progress_share_modal.dart';
import './widgets/statistics_cards.dart';
import './widgets/weekly_calorie_chart.dart';
import './widgets/weight_tracking_chart.dart';

class ProgressTracking extends StatefulWidget {
  const ProgressTracking({super.key});

  @override
  State<ProgressTracking> createState() => _ProgressTrackingState();
}

class _ProgressTrackingState extends State<ProgressTracking>
    with TickerProviderStateMixin {
  String selectedRange = 'Week';
  bool isLoading = false;
  DateTime lastSyncTime = DateTime.now().subtract(const Duration(minutes: 5));

  void _onRangeChanged(String range) {
    setState(() {
      selectedRange = range;
      isLoading = true;
    });

    // Simulate data loading
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void _showShareModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProgressShareModal(selectedRange: selectedRange),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      isLoading = true;
    });

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        isLoading = false;
        lastSyncTime = DateTime.now();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Progress data updated successfully!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  String _getDateRangeText() {
    final now = DateTime.now();
    switch (selectedRange) {
      case 'Week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        return '${startOfWeek.day}/${startOfWeek.month} - ${endOfWeek.day}/${endOfWeek.month}';
      case 'Month':
        return '${now.month}/${now.year}';
      case '3 Months':
        final threeMonthsAgo = DateTime(now.year, now.month - 2, 1);
        return '${threeMonthsAgo.month}/${threeMonthsAgo.year} - ${now.month}/${now.year}';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomProgressAppBar(
        dateRange: _getDateRangeText(),
        onDateTap: () {
          // Show date picker functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Date picker functionality')),
          );
        },
        onShareTap: _showShareModal,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            // Date range selector
            SliverToBoxAdapter(
              child: DateRangeSelector(
                selectedRange: selectedRange,
                onRangeChanged: _onRangeChanged,
              ),
            ),

            // Last sync info
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'sync',
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Last updated: ${lastSyncTime.hour.toString().padLeft(2, '0')}:${lastSyncTime.minute.toString().padLeft(2, '0')}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Loading indicator or content
            if (isLoading) ...[
              SliverToBoxAdapter(
                child: Container(
                  height: 50.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Loading progress data...',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Weekly calorie chart
              SliverToBoxAdapter(
                child: WeeklyCalorieChart(selectedRange: selectedRange),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 3.h)),

              // Weight tracking chart
              SliverToBoxAdapter(
                child: WeightTrackingChart(selectedRange: selectedRange),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 3.h)),

              // Macro pie chart
              SliverToBoxAdapter(
                child: MacroPieChart(selectedRange: selectedRange),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 3.h)),

              // Achievement badges
              SliverToBoxAdapter(
                child: AchievementBadges(),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 3.h)),

              // Statistics cards
              SliverToBoxAdapter(
                child: StatisticsCards(selectedRange: selectedRange),
              ),

              // Bottom padding
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 2),
    );
  }
}
