import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../authentication_screens/authentication_screens.dart';

enum OnboardingGoal { lose, maintain, gain }

enum Gender { male, female, other }

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  late List<AnimationController> _cardControllers;

  int _currentPage = 0;
  OnboardingGoal? _selectedGoal;
  Gender? _selectedGender;
  double _age = 25;
  double _weight = 70;
  double _height = 170;
  int _dailyCalories = 2000;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _calculateCalories();
  }

  void _setupAnimations() {
    _pageController = PageController();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _cardControllers = List.generate(
      4,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      ),
    );

    // Start first page animation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _cardControllers[0].forward();
      }
    });
  }

  void _calculateCalories() {
    if (_selectedGender == null) return;

    // Basic BMR calculation using Mifflin-St Jeor Equation
    double bmr;
    if (_selectedGender == Gender.male) {
      bmr = (10 * _weight) + (6.25 * _height) - (5 * _age) + 5;
    } else {
      bmr = (10 * _weight) + (6.25 * _height) - (5 * _age) - 161;
    }

    // Apply activity factor (assuming lightly active)
    double tdee = bmr * 1.375;

    // Adjust based on goal
    switch (_selectedGoal) {
      case OnboardingGoal.lose:
        _dailyCalories = (tdee - 500).round(); // 500 calorie deficit
        break;
      case OnboardingGoal.gain:
        _dailyCalories = (tdee + 300).round(); // 300 calorie surplus
        break;
      case OnboardingGoal.maintain:
      default:
        _dailyCalories = tdee.round();
        break;
    }

    setState(() {});
  }

  void _nextPage() {
    if (_currentPage < 3) {
      HapticFeedback.lightImpact();
      _currentPage++;
      _progressController.animateTo(_currentPage / 3);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

      // Start animation for new page
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && _currentPage < _cardControllers.length) {
          _cardControllers[_currentPage].forward();
        }
      });
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      HapticFeedback.lightImpact();
      _currentPage--;
      _progressController.animateTo(_currentPage / 3);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: const AuthenticationScreens(),
        duration: const Duration(milliseconds: 600),
      ),
    );
  }

  void _completeOnboarding() {
    HapticFeedback.heavyImpact();
    Navigator.pushReplacement(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: const AuthenticationScreens(),
        duration: const Duration(milliseconds: 600),
      ),
    );
  }

  bool get _canProceed {
    switch (_currentPage) {
      case 0:
        return _selectedGoal != null;
      case 1:
        return _selectedGender != null;
      case 2:
        return true; // Age/weight/height always have values
      case 3:
        return true; // Calorie target is calculated
      default:
        return false;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppTheme.backgroundLight,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              // Header with progress and skip
              _buildHeader(),

              // Main content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    _buildGoalPage(),
                    _buildGenderAgePage(),
                    _buildPhysicalStatsPage(),
                    _buildCalorieTargetPage(),
                  ],
                ),
              ),

              // Navigation buttons
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(6.w),
      child: Row(
        children: [
          // Progress indicator
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${_currentPage + 1} of 4',
                  style: GoogleFonts.inter(
                    fontSize: 3.5.w,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textSecondary,
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  height: 0.8.h,
                  decoration: BoxDecoration(
                    color: AppTheme.softGreen,
                    borderRadius: BorderRadius.circular(1.h),
                  ),
                  child: AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: (_currentPage + 1) / 4,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(1.h),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Skip button
          TextButton(
            onPressed: _skipOnboarding,
            child: Text(
              'Skip',
              style: GoogleFonts.inter(
                fontSize: 4.w,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          SizedBox(height: 4.h),
          Text(
            'What\'s your goal?',
            style: GoogleFonts.inter(
              fontSize: 8.w,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          )
              .animate(controller: _cardControllers[0])
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.3, end: 0, duration: 400.ms),
          SizedBox(height: 2.h),
          Text(
            'Choose your primary nutrition goal to get personalized recommendations',
            style: GoogleFonts.inter(
              fontSize: 4.w,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          )
              .animate(controller: _cardControllers[0])
              .fadeIn(duration: 400.ms, delay: 200.ms),
          SizedBox(height: 6.h),
          Expanded(
            child: Column(
              children: [
                _buildGoalCard(
                  goal: OnboardingGoal.lose,
                  icon: Icons.trending_down_rounded,
                  title: 'Lose Weight',
                  subtitle: 'Create a calorie deficit to shed pounds',
                  color: AppTheme.accentBlue,
                  gradient: AppTheme.blueGradient,
                ),
                SizedBox(height: 3.h),
                _buildGoalCard(
                  goal: OnboardingGoal.maintain,
                  icon: Icons.balance_rounded,
                  title: 'Maintain Weight',
                  subtitle: 'Keep your current weight with balanced nutrition',
                  color: AppTheme.primaryGreen,
                  gradient: AppTheme.primaryGradient,
                ),
                SizedBox(height: 3.h),
                _buildGoalCard(
                  goal: OnboardingGoal.gain,
                  icon: Icons.trending_up_rounded,
                  title: 'Gain Weight',
                  subtitle: 'Build muscle and gain healthy weight',
                  color: AppTheme.accentPurple,
                  gradient: AppTheme.purpleGradient,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard({
    required OnboardingGoal goal,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required LinearGradient gradient,
  }) {
    final isSelected = _selectedGoal == goal;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedGoal = goal;
        });
        _calculateCalories();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          gradient: isSelected ? gradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppTheme.softGreen,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withAlpha(77),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withAlpha(51)
                    : color.withAlpha(26),
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Icon(
                icon,
                size: 8.w,
                color: isSelected ? Colors.white : color,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 5.w,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 3.5.w,
                      fontWeight: FontWeight.w400,
                      color: isSelected
                          ? Colors.white.withAlpha(230)
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                size: 6.w,
                color: Colors.white,
              ),
          ],
        ),
      )
          .animate(controller: _cardControllers[0])
          .scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1.0, 1.0),
            duration: 400.ms,
            delay: (300 + (OnboardingGoal.values.indexOf(goal) * 100)).ms,
            curve: Curves.easeOut,
          )
          .fadeIn(
            duration: 400.ms,
            delay: (300 + (OnboardingGoal.values.indexOf(goal) * 100)).ms,
          ),
    );
  }

  Widget _buildGenderAgePage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          SizedBox(height: 4.h),

          Text(
            'Tell us about yourself',
            style: GoogleFonts.inter(
              fontSize: 8.w,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          )
              .animate(controller: _cardControllers[1])
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.3, end: 0, duration: 400.ms),

          SizedBox(height: 6.h),

          // Gender selection
          Text(
            'Gender',
            style: GoogleFonts.inter(
              fontSize: 5.w,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          )
              .animate(controller: _cardControllers[1])
              .fadeIn(duration: 400.ms, delay: 200.ms),

          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child:
                    _buildGenderCard(Gender.male, 'Male', Icons.male_rounded),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildGenderCard(
                    Gender.female, 'Female', Icons.female_rounded),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildGenderCard(
                    Gender.other, 'Other', Icons.person_rounded),
              ),
            ],
          )
              .animate(controller: _cardControllers[1])
              .fadeIn(duration: 400.ms, delay: 300.ms),

          SizedBox(height: 6.h),

          // Age slider
          _buildSliderSection(
            title: 'Age',
            value: _age,
            min: 13,
            max: 100,
            divisions: 87,
            suffix: 'years',
            onChanged: (value) {
              setState(() {
                _age = value;
              });
              _calculateCalories();
            },
          )
              .animate(controller: _cardControllers[1])
              .fadeIn(duration: 400.ms, delay: 400.ms)
              .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: 400.ms),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildGenderCard(Gender gender, String label, IconData icon) {
    final isSelected = _selectedGender == gender;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _selectedGender = gender;
        });
        _calculateCalories();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppTheme.softGreen,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withAlpha(77),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 8.w,
              color: isSelected ? Colors.white : AppTheme.primaryGreen,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 4.w,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhysicalStatsPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          SizedBox(height: 4.h),

          Text(
            'Physical stats',
            style: GoogleFonts.inter(
              fontSize: 8.w,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          )
              .animate(controller: _cardControllers[2])
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.3, end: 0, duration: 400.ms),

          SizedBox(height: 2.h),

          Text(
            'Help us calculate your personalized calorie target',
            style: GoogleFonts.inter(
              fontSize: 4.w,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          )
              .animate(controller: _cardControllers[2])
              .fadeIn(duration: 400.ms, delay: 200.ms),

          SizedBox(height: 6.h),

          // Weight slider
          _buildSliderSection(
            title: 'Weight',
            value: _weight,
            min: 30,
            max: 200,
            divisions: 170,
            suffix: 'kg',
            onChanged: (value) {
              setState(() {
                _weight = value;
              });
              _calculateCalories();
            },
          )
              .animate(controller: _cardControllers[2])
              .fadeIn(duration: 400.ms, delay: 300.ms)
              .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: 300.ms),

          SizedBox(height: 4.h),

          // Height slider
          _buildSliderSection(
            title: 'Height',
            value: _height,
            min: 120,
            max: 220,
            divisions: 100,
            suffix: 'cm',
            onChanged: (value) {
              setState(() {
                _height = value;
              });
              _calculateCalories();
            },
          )
              .animate(controller: _cardControllers[2])
              .fadeIn(duration: 400.ms, delay: 400.ms)
              .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: 400.ms),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildSliderSection({
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String suffix,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 5.w,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 1.h,
                ),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${value.round()} $suffix',
                  style: GoogleFonts.inter(
                    fontSize: 4.5.w,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.primaryGreen,
              inactiveTrackColor: AppTheme.softGreen,
              thumbColor: AppTheme.primaryGreen,
              overlayColor: AppTheme.primaryGreen.withAlpha(51),
              trackHeight: 1.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 3.w),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieTargetPage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          SizedBox(height: 4.h),

          Text(
            'Your daily target',
            style: GoogleFonts.inter(
              fontSize: 8.w,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          )
              .animate(controller: _cardControllers[3])
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.3, end: 0, duration: 400.ms),

          SizedBox(height: 6.h),

          // Animated calorie ring
          Container(
            width: 60.w,
            height: 60.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background ring
                Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.softGreen,
                        AppTheme.softGreen.withAlpha(77),
                      ],
                    ),
                  ),
                ),

                // Progress ring (animated)
                SizedBox(
                  width: 50.w,
                  height: 50.w,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 2.w,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryGreen,
                    ),
                    backgroundColor: AppTheme.softGreen,
                  ).animate(controller: _cardControllers[3]).scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1.0, 1.0),
                        duration: 800.ms,
                        delay: 400.ms,
                        curve: Curves.elasticOut,
                      ),
                ),

                // Calorie text
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_dailyCalories',
                      style: GoogleFonts.inter(
                        fontSize: 15.w,
                        fontWeight: FontWeight.w900,
                        color: AppTheme.primaryGreen,
                        height: 0.9,
                      ),
                    )
                        .animate(controller: _cardControllers[3])
                        .fadeIn(
                          duration: 600.ms,
                          delay: 800.ms,
                        )
                        .slideY(
                          begin: 0.5,
                          end: 0,
                          duration: 600.ms,
                          delay: 800.ms,
                        ),
                    Text(
                      'calories/day',
                      style: GoogleFonts.inter(
                        fontSize: 4.w,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textSecondary,
                      ),
                    ).animate(controller: _cardControllers[3]).fadeIn(
                          duration: 600.ms,
                          delay: 1000.ms,
                        ),
                  ],
                ),
              ],
            ),
          ).animate(controller: _cardControllers[3]).scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 600.ms,
                delay: 200.ms,
                curve: Curves.easeOut,
              ),

          SizedBox(height: 6.h),

          // Goal summary
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.softGreen,
                  AppTheme.softBlue,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(
                  '🎯 Goal: ${_getGoalText()}',
                  style: GoogleFonts.inter(
                    fontSize: 4.5.w,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Based on your stats, this target will help you achieve your nutrition goals safely and effectively.',
                  style: GoogleFonts.inter(
                    fontSize: 3.8.w,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
              .animate(controller: _cardControllers[3])
              .fadeIn(
                duration: 600.ms,
                delay: 1200.ms,
              )
              .slideY(
                begin: 0.3,
                end: 0,
                duration: 600.ms,
                delay: 1200.ms,
              ),
        ],
      ),
    );
  }

  String _getGoalText() {
    switch (_selectedGoal) {
      case OnboardingGoal.lose:
        return 'Lose Weight';
      case OnboardingGoal.gain:
        return 'Gain Weight';
      case OnboardingGoal.maintain:
      default:
        return 'Maintain Weight';
    }
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: EdgeInsets.all(6.w),
      child: Row(
        children: [
          // Back button
          if (_currentPage > 0)
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: _previousPage,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  side: const BorderSide(
                    color: AppTheme.textSecondary,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Back',
                  style: GoogleFonts.inter(
                    fontSize: 4.w,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ),

          if (_currentPage > 0) SizedBox(width: 4.w),

          // Next/Complete button
          Expanded(
            flex: 2,
            child: Container(
              height: 7.h,
              decoration: BoxDecoration(
                gradient: _canProceed ? AppTheme.primaryGradient : null,
                color: _canProceed ? null : AppTheme.textDisabled,
                borderRadius: BorderRadius.circular(16),
                boxShadow: _canProceed
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withAlpha(77),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: ElevatedButton(
                onPressed: _canProceed ? _nextPage : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _currentPage == 3 ? 'Complete Setup' : 'Continue',
                  style: GoogleFonts.inter(
                    fontSize: 4.5.w,
                    fontWeight: FontWeight.w600,
                    color: _canProceed ? Colors.white : Colors.white70,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}