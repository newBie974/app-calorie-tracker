import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../theme/app_theme.dart';

class SettingsGroupWidget extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsGroupWidget({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
          ),
        ),

        SizedBox(height: 1.h),

        // Group Card with Items
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              for (int i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Container(
                    height: 0.5,
                    margin: EdgeInsets.only(left: 15.w),
                    color: Colors.grey.withValues(alpha: 0.5),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}