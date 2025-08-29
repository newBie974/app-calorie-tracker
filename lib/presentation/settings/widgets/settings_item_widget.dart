import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class SettingsItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDestructive;

  const SettingsItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDestructive ? Colors.red : AppTheme.textPrimary;

    final iconColor =
        isDestructive ? Colors.red : AppTheme.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          child: Row(
            children: [
              // Icon
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 5.w,
                ),
              ),

              SizedBox(width: 4.w),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            color: AppTheme.textSecondary,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Trailing widget or chevron
              trailing ??
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.textDisabled,
                    size: 6.w,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}