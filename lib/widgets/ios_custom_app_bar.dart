import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../theme/app_theme.dart';

class IOSCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String greeting;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final int notificationCount;

  const IOSCustomAppBar({
    super.key,
    required this.greeting,
    this.onProfileTap,
    this.onNotificationTap,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: AppTheme.backgroundLight,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      toolbarHeight: preferredSize.height,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            children: [
              // Top row with period selector and profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Period selector
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadowLight.withValues(alpha: 0.08),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Today',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.primaryColorLight,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Weekly',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Monthly',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Profile and notifications
                  Row(
                    children: [
                      // Notifications
                      if (notificationCount > 0)
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            onNotificationTap?.call();
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 3.w),
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(2.5.w),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceLight,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.shadowLight
                                            .withValues(alpha: 0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.notifications_none_rounded,
                                    color: AppTheme.textSecondaryLight,
                                    size: 6.w,
                                  ),
                                ),
                                if (notificationCount > 0)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(1.w),
                                      decoration: const BoxDecoration(
                                        color: AppTheme.errorLight,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        notificationCount > 9
                                            ? '9+'
                                            : notificationCount.toString(),
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          fontSize: 8.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                      // Profile avatar
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          onProfileTap?.call();
                        },
                        child: Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primaryLight,
                                AppTheme.secondaryLight,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryLight
                                    .withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 6.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Greeting and edit button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimaryLight,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        DateTime.now().day.toString().padLeft(2, '0') +
                            ' ${_getMonthName(DateTime.now().month)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),

                  // Edit button
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLight,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadowLight.withValues(alpha: 0.08),
                          blurRadius: 10,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'Edit',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }

  @override
  Size get preferredSize => Size.fromHeight(18.h);
}
