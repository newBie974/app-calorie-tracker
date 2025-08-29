import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/settings_group_widget.dart';
import './widgets/settings_item_widget.dart';
import './widgets/logout_confirmation_dialog.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notificationReminders = true;
  bool _goalAchievements = true;
  bool _weeklySummaries = false;
  bool _darkMode = false;
  bool _isMetric = true;
  String _selectedMealTime = '8:00 AM';
  String _selectedFoodDatabase = 'USDA';
  double _textSize = 1.0;
  String _selectedTheme = 'Green';

  final List<String> _mealTimes = [
    '6:00 AM',
    '6:30 AM',
    '7:00 AM',
    '7:30 AM',
    '8:00 AM',
    '8:30 AM',
    '9:00 AM',
    '9:30 AM',
    '10:00 AM'
  ];

  final List<String> _foodDatabases = [
    'USDA',
    'Nutritionix',
    'FatSecret',
    'Custom'
  ];

  final List<String> _colorThemes = [
    'Green',
    'Blue',
    'Purple',
    'Orange',
    'Pink'
  ];

  void _showLogoutDialog() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => LogoutConfirmationDialog(
        onConfirm: () {
          Navigator.of(context).pop();
          _handleLogout();
        },
      ),
    );
  }

  void _handleLogout() {
    HapticFeedback.lightImpact();
    // Handle logout logic
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/welcome-screen',
      (route) => false,
    );
  }

  void _showMealTimeSelector() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SizedBox(
        height: 300,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Select Default Meal Time',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _mealTimes.length,
                itemBuilder: (context, index) {
                  final time = _mealTimes[index];
                  return ListTile(
                    title: Text(time),
                    trailing: _selectedMealTime == time
                        ? const Icon(Icons.check, color: AppTheme.primaryGreen)
                        : null,
                    onTap: () {
                      setState(() => _selectedMealTime = time);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSelector() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SizedBox(
        height: 300,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Select Color Theme',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _colorThemes.length,
                itemBuilder: (context, index) {
                  final theme = _colorThemes[index];
                  return ListTile(
                    title: Text(theme),
                    leading: CircleAvatar(
                      radius: 12,
                      backgroundColor: _getThemeColor(theme),
                    ),
                    trailing: _selectedTheme == theme
                        ? const Icon(Icons.check, color: AppTheme.primaryGreen)
                        : null,
                    onTap: () {
                      setState(() => _selectedTheme = theme);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getThemeColor(String theme) {
    switch (theme) {
      case 'Green':
        return AppTheme.primaryGreen;
      case 'Blue':
        return AppTheme.accentBlue;
      case 'Purple':
        return Colors.purple;
      case 'Orange':
        return Colors.orange;
      case 'Pink':
        return Colors.pink;
      default:
        return AppTheme.primaryGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),

            // App Preferences Section
            SettingsGroupWidget(
              title: 'App Preferences',
              children: [
                SettingsItemWidget(
                  icon: Icons.straighten_rounded,
                  title: 'Units',
                  subtitle:
                      _isMetric ? 'Metric (kg, cm)' : 'Imperial (lbs, ft)',
                  trailing: Switch.adaptive(
                    value: _isMetric,
                    activeColor: AppTheme.primaryGreen,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() => _isMetric = value);
                    },
                  ),
                ),
                SettingsItemWidget(
                  icon: Icons.access_time_rounded,
                  title: 'Default Meal Time',
                  subtitle: _selectedMealTime,
                  onTap: _showMealTimeSelector,
                ),
                SettingsItemWidget(
                  icon: Icons.restaurant_rounded,
                  title: 'Food Database',
                  subtitle: _selectedFoodDatabase,
                  onTap: () {
                    // Show food database selector
                  },
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Notifications Section
            SettingsGroupWidget(
              title: 'Notifications',
              children: [
                SettingsItemWidget(
                  icon: Icons.notifications_rounded,
                  title: 'Meal Reminders',
                  subtitle: 'Get reminded to log your meals',
                  trailing: Switch.adaptive(
                    value: _notificationReminders,
                    activeColor: AppTheme.primaryGreen,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() => _notificationReminders = value);
                    },
                  ),
                ),
                SettingsItemWidget(
                  icon: Icons.emoji_events_rounded,
                  title: 'Goal Achievements',
                  subtitle: 'Celebrate when you reach your goals',
                  trailing: Switch.adaptive(
                    value: _goalAchievements,
                    activeColor: AppTheme.primaryGreen,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() => _goalAchievements = value);
                    },
                  ),
                ),
                SettingsItemWidget(
                  icon: Icons.summarize_rounded,
                  title: 'Weekly Summaries',
                  subtitle: 'Weekly progress reports',
                  trailing: Switch.adaptive(
                    value: _weeklySummaries,
                    activeColor: AppTheme.primaryGreen,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() => _weeklySummaries = value);
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Display Settings Section
            SettingsGroupWidget(
              title: 'Display Settings',
              children: [
                SettingsItemWidget(
                  icon: Icons.dark_mode_rounded,
                  title: 'Dark Mode',
                  subtitle: 'Switch to dark theme',
                  trailing: Switch.adaptive(
                    value: _darkMode,
                    activeColor: AppTheme.primaryGreen,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      setState(() => _darkMode = value);
                    },
                  ),
                ),
                SettingsItemWidget(
                  icon: Icons.format_size_rounded,
                  title: 'Text Size',
                  subtitle: 'Adjust text size for better readability',
                  trailing: SizedBox(
                    width: 100,
                    child: Slider(
                      value: _textSize,
                      min: 0.8,
                      max: 1.4,
                      divisions: 3,
                      activeColor: AppTheme.primaryGreen,
                      onChanged: (value) {
                        HapticFeedback.lightImpact();
                        setState(() => _textSize = value);
                      },
                    ),
                  ),
                ),
                SettingsItemWidget(
                  icon: Icons.palette_rounded,
                  title: 'Color Theme',
                  subtitle: _selectedTheme,
                  onTap: _showThemeSelector,
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Privacy & Security Section
            SettingsGroupWidget(
              title: 'Privacy & Security',
              children: [
                SettingsItemWidget(
                  icon: Icons.download_rounded,
                  title: 'Export Personal Data',
                  subtitle: 'Download your data as a file',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Handle data export
                  },
                ),
                SettingsItemWidget(
                  icon: Icons.delete_forever_rounded,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  isDestructive: true,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    // Show delete account confirmation
                  },
                ),
                SettingsItemWidget(
                  icon: Icons.privacy_tip_rounded,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Open privacy policy
                  },
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Account Management Section
            SettingsGroupWidget(
              title: 'Account',
              children: [
                SettingsItemWidget(
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  isDestructive: true,
                  onTap: _showLogoutDialog,
                ),
              ],
            ),

            SizedBox(height: 4.h),

            // App Version
            Center(
              child: Column(
                children: [
                  Text(
                    'CalorieTracker',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Version 1.0.0',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textDisabled,
                        ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}