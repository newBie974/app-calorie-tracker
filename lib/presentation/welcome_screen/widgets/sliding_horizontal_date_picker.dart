import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_theme.dart';

class SlidingHorizontalDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime)? onDateSelected;
  final Function(DateTime)? onScrollChanged;
  final Color backgroundColor;
  final Color selectedColor;
  final Color todayColor;
  final double height;

  const SlidingHorizontalDatePicker({
    super.key,
    this.initialDate,
    this.onDateSelected,
    this.onScrollChanged,
    this.backgroundColor = Colors.white,
    this.selectedColor = const Color(0xFFDFFF9C), // Pastel green from specs
    this.todayColor = AppTheme.primaryGreen,
    this.height = 140,
  });

  @override
  State<SlidingHorizontalDatePicker> createState() =>
      _SlidingHorizontalDatePickerState();
}

class _SlidingHorizontalDatePickerState
    extends State<SlidingHorizontalDatePicker> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _headerAnimationController;
  late AnimationController _selectionAnimationController;

  DateTime _selectedDate = DateTime.now();
  DateTime _today = DateTime.now();
  DateTime _currentDisplayMonth = DateTime.now();
  List<DateTime> _visibleDates = [];

  // Configuration constants
  static const int _daysToShow = 42; // 3 weeks before + 3 weeks after = 6 weeks
  static const int _centerIndex = 21; // Middle of the list
  static const double _itemWidth = 64.0; // Cell width from specs (56-64px)

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _today = DateTime.now();

    _setupAnimations();
    _generateVisibleDates();
    _initializePageController();
  }

  void _setupAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _selectionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  void _generateVisibleDates() {
    _visibleDates.clear();
    final startDate = _selectedDate.subtract(Duration(days: _centerIndex));

    for (int i = 0; i < _daysToShow; i++) {
      _visibleDates.add(startDate.add(Duration(days: i)));
    }

    _updateCurrentDisplayMonth();
  }

  void _initializePageController() {
    _pageController = PageController(
      initialPage: _centerIndex,
      viewportFraction: _itemWidth / (100.w - 32), // Account for padding
    );

    // Auto-center on today when first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerOnToday();
    });
  }

  void _updateCurrentDisplayMonth() {
    if (_visibleDates.isNotEmpty) {
      final centerDate = _visibleDates[_centerIndex];
      if (_currentDisplayMonth.month != centerDate.month ||
          _currentDisplayMonth.year != centerDate.year) {
        setState(() {
          _currentDisplayMonth = centerDate;
        });
        _headerAnimationController.forward(from: 0);
      }
    }
  }

  void _centerOnToday() {
    final todayIndex = _visibleDates.indexWhere((date) =>
        date.year == _today.year &&
        date.month == _today.month &&
        date.day == _today.day);

    if (todayIndex != -1) {
      _pageController.animateToPage(
        todayIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _selectDate(DateTime date, int index) {
    HapticFeedback.selectionClick();

    setState(() {
      _selectedDate = date;
    });

    // Animate to selected date
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );

    // Trigger selection animation
    _selectionAnimationController.forward(from: 0);

    // Call callback
    widget.onDateSelected?.call(date);
  }

  void _navigateWeek(bool isNext) {
    HapticFeedback.lightImpact();

    final currentPage = _pageController.page?.round() ?? _centerIndex;
    final targetPage = isNext ? currentPage + 7 : currentPage - 7;

    // Ensure we don't go out of bounds
    final clampedPage = targetPage.clamp(0, _visibleDates.length - 1);

    _pageController.animateToPage(
      clampedPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPageChanged(int page) {
    if (page < _visibleDates.length) {
      final centeredDate = _visibleDates[page];
      widget.onScrollChanged?.call(centeredDate);

      // Update display month if needed
      if (_currentDisplayMonth.month != centeredDate.month ||
          _currentDisplayMonth.year != centeredDate.year) {
        setState(() {
          _currentDisplayMonth = centeredDate;
        });
        _headerAnimationController.forward(from: 0);
      }

      // Implement infinite scroll by regenerating dates when nearing edges
      if (page <= 5 || page >= _visibleDates.length - 5) {
        _extendVisibleDates(page <= 5);
      }
    }
  }

  void _extendVisibleDates(bool extendBackward) {
    if (extendBackward) {
      // Add more dates to the beginning
      final firstDate = _visibleDates.first;
      for (int i = 14; i > 0; i--) {
        _visibleDates.insert(0, firstDate.subtract(Duration(days: i)));
      }
    } else {
      // Add more dates to the end
      final lastDate = _visibleDates.last;
      for (int i = 1; i <= 14; i++) {
        _visibleDates.add(lastDate.add(Duration(days: i)));
      }
    }
    setState(() {});
  }

  bool _isToday(DateTime date) {
    return date.year == _today.year &&
        date.month == _today.month &&
        date.day == _today.day;
  }

  bool _isSelected(DateTime date) {
    return date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _headerAnimationController.dispose();
    _selectionAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStickyHeader(),
          Expanded(
            child: _buildDateList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyHeader() {
    final monthYear = DateFormat('MMMM yyyy').format(_currentDisplayMonth);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          bottom: BorderSide(
            color: AppTheme.textDisabled.withAlpha(26),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left arrow
          Semantics(
            label: 'Previous week',
            button: true,
            child: IconButton(
              onPressed: () => _navigateWeek(false),
              icon: Icon(
                Icons.chevron_left_rounded,
                size: 6.w,
                color: AppTheme.textPrimary,
              ),
              style: IconButton.styleFrom(
                padding: EdgeInsets.all(2.w),
                minimumSize: Size(10.w, 10.w),
              ),
            ),
          ),

          // Month + Year label
          Text(
            monthYear,
            style: GoogleFonts.inter(
              fontSize: 4.5.w,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          )
              .animate(controller: _headerAnimationController)
              .fadeIn(duration: 200.ms)
              .slideY(begin: -0.3, end: 0, duration: 300.ms),

          // Right arrow
          Semantics(
            label: 'Next week',
            button: true,
            child: IconButton(
              onPressed: () => _navigateWeek(true),
              icon: Icon(
                Icons.chevron_right_rounded,
                size: 6.w,
                color: AppTheme.textPrimary,
              ),
              style: IconButton.styleFrom(
                padding: EdgeInsets.all(2.w),
                minimumSize: Size(10.w, 10.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: _visibleDates.length,
        itemBuilder: (context, index) {
          final date = _visibleDates[index];
          final isToday = _isToday(date);
          final isSelected = _isSelected(date);

          return Container(
            width: _itemWidth,
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            child: _buildDateCell(date, index, isToday, isSelected),
          );
        },
      ),
    );
  }

  Widget _buildDateCell(
      DateTime date, int index, bool isToday, bool isSelected) {
    final dayAbbr = DateFormat('E').format(date).toUpperCase().substring(0, 3);
    final dayNumber = date.day.toString();

    return Semantics(
      label: DateFormat('EEEE, MMMM d, yyyy').format(date),
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: () => _selectDate(date, index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? widget.selectedColor : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Day abbreviation
              Text(
                dayAbbr,
                style: GoogleFonts.inter(
                  fontSize: 3.w,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? AppTheme.textPrimary
                      : const Color(0xFFA0A0A0), // Grey from specs
                  letterSpacing: 0.5,
                ),
              ),

              SizedBox(height: 0.5.h),

              // Date number with today indicator
              Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    dayNumber,
                    style: GoogleFonts.inter(
                      fontSize: 4.w,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                      color: isSelected || isToday
                          ? AppTheme.textPrimary
                          : const Color(0xFF222222), // Dark from specs
                    ),
                  ),

                  // Today indicator (underline or dot)
                  if (isToday && !isSelected)
                    Positioned(
                      bottom: -0.8.h,
                      child: Container(
                        width: 1.w,
                        height: 1.w,
                        decoration: BoxDecoration(
                          color: widget.todayColor,
                          shape: BoxShape.circle,
                        ),
                      )
                          .animate(
                              onPlay: (controller) =>
                                  controller.repeat(reverse: true))
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1.2, 1.2),
                            duration: 1000.ms,
                            curve: Curves.easeInOut,
                          ),
                    ),
                ],
              ),
            ],
          ),
        )
            .animate(target: isSelected ? 1.0 : 0.0)
            .scale(
              begin: const Offset(1.0, 1.0),
              end: const Offset(1.05, 1.05),
              duration: 200.ms,
              curve: Curves.easeOut,
            )
            .animate(controller: _selectionAnimationController)
            .shimmer(
              duration: 400.ms,
              color: widget.selectedColor.withAlpha(128),
            ),
      ),
    );
  }
}
