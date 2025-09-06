import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';


/// Horizontal Date Picker Component following exact technical specifications
class NutritionCalendarWidget extends StatefulWidget {
  final Function(DateTime)? onDaySelected;
  final Function(DateTime)? onMonthChanged;

  const NutritionCalendarWidget({
    super.key,
    this.onDaySelected,
    this.onMonthChanged,
  });

  @override
  State<NutritionCalendarWidget> createState() =>
      _NutritionCalendarWidgetState();
}

class _NutritionCalendarWidgetState extends State<NutritionCalendarWidget>
    with TickerProviderStateMixin {
  late DateTime _selectedDate;
  late DateTime _currentMonth;
  late List<DateTime> _currentWeekDates;
  late AnimationController _slideAnimationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _currentMonth = DateTime.now();
    _updateCurrentWeek();

    // Animation setup for smooth transitions
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    super.dispose();
  }

  void _updateCurrentWeek() {
    // Get the start of the current week (Monday)
    final now = _currentMonth;
    final mondayOfWeek = now.subtract(Duration(days: (now.weekday - 1) % 7));

    _currentWeekDates = List.generate(7, (index) {
      return mondayOfWeek.add(Duration(days: index));
    });
  }

  String _getMonthName(int month) {
    const months = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];
    return months[month - 1];
  }

  List<String> _getDayAbbreviations() {
    return ['LUN', 'MAR', 'MER', 'JEU', 'VEN', 'SAM', 'DIM'];
  }

  Future<void> _navigateToPreviousWeek() async {
    HapticFeedback.lightImpact();

    // Animate slide to left
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.0, 0),
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeInOut,
    ));

    await _slideAnimationController.forward();

    setState(() {
      _currentMonth = DateTime(
          _currentMonth.year, _currentMonth.month, _currentMonth.day - 7);
      _updateCurrentWeek();
    });

    if (widget.onMonthChanged != null &&
        _currentMonth.month != DateTime.now().month) {
      widget.onMonthChanged!(_currentMonth);
    }

    // Animate slide in from right
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimationController.reset();
    await _slideAnimationController.forward();
  }

  Future<void> _navigateToNextWeek() async {
    HapticFeedback.lightImpact();

    // Animate slide to right
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.0, 0),
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeInOut,
    ));

    await _slideAnimationController.forward();

    setState(() {
      _currentMonth = DateTime(
          _currentMonth.year, _currentMonth.month, _currentMonth.day + 7);
      _updateCurrentWeek();
    });

    if (widget.onMonthChanged != null &&
        _currentMonth.month != DateTime.now().month) {
      widget.onMonthChanged!(_currentMonth);
    }

    // Animate slide in from left
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimationController.reset();
    await _slideAnimationController.forward();
  }

  void _onDateSelected(DateTime date) {
    HapticFeedback.lightImpact();

    setState(() {
      _selectedDate = date;
    });

    if (widget.onDaySelected != null) {
      widget.onDaySelected!(date);
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  bool _isDateOutsideCurrentMonth(DateTime date) {
    return date.month != _currentMonth.month;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.white, // #FFFFFF background
        borderRadius: BorderRadius.circular(18), // 16-20px rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13), // Subtle shadow
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row with navigation arrows and month+year
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12), // Horizontal padding 16px, Vertical padding 12px
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left arrow button
                GestureDetector(
                  onTap: _navigateToPreviousWeek,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      size: 24,
                      color: Color(0xFF222222), // Dark color
                    ),
                  ),
                ),

                // Month + Year label, centered
                Text(
                  '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                  style: GoogleFonts.inter(
                    fontSize: 18, // 16-18pt bold
                    fontWeight: FontWeight.w700, // Bold
                    color: const Color(0xFF222222), // Dark text
                  ),
                ),

                // Right arrow button
                GestureDetector(
                  onTap: _navigateToNextWeek,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: Color(0xFF222222), // Dark color
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Days row with animation
          SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (index) {
                  final date = _currentWeekDates[index];
                  final dayAbbr = _getDayAbbreviations()[index];
                  final isSelected = _isSameDay(date, _selectedDate);
                  final isOutsideMonth = _isDateOutsideCurrentMonth(date);

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _onDateSelected(date),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Day abbreviation
                            Text(
                              dayAbbr,
                              style: GoogleFonts.inter(
                                fontSize: 13, // 12-14pt
                                fontWeight: FontWeight.w500, // Medium
                                color: const Color(0xFFA0A0A0), // Grey #A0A0A0
                                letterSpacing: 0.5,
                              ),
                            ),

                            const SizedBox(height: 4), // 4px gap

                            // Date number with highlighting
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(
                                        0xFFDFFF9C) // Pastel green highlight #DFFF9C
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                    10), // 8-12px radius pill
                              ),
                              child: Center(
                                child: Text(
                                  '${date.day}',
                                  style: GoogleFonts.inter(
                                    fontSize: 15, // 14-16pt
                                    fontWeight: FontWeight.w400, // Regular
                                    color: isOutsideMonth
                                        ? const Color(
                                            0xFFC0C0C0) // Disabled/greyed #C0C0C0
                                        : const Color(0xFF222222), // Dark #222
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 8), // Bottom spacing
        ],
      ),
    );
  }
}
