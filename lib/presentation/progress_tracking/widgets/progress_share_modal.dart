import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ProgressShareModal extends StatefulWidget {
  final String selectedRange;

  const ProgressShareModal({
    super.key,
    required this.selectedRange,
  });

  @override
  State<ProgressShareModal> createState() => _ProgressShareModalState();
}

class _ProgressShareModalState extends State<ProgressShareModal> {
  bool includePersonalData = false;
  bool includeWeightData = true;
  bool includeCalorieData = true;
  bool includeMacroData = true;
  String selectedFormat = 'Image';

  final List<String> formats = ['Image', 'PDF', 'Text Summary'];
  final List<Map<String, dynamic>> shareOptions = [
    {
      'title': 'Social Media',
      'icon': 'share',
      'description': 'Share to Instagram, Facebook, Twitter',
    },
    {
      'title': 'Email',
      'icon': 'email',
      'description': 'Send via email to friends or trainer',
    },
    {
      'title': 'Save to Photos',
      'icon': 'photo_library',
      'description': 'Save to device gallery',
    },
    {
      'title': 'Copy Link',
      'icon': 'link',
      'description': 'Copy shareable link to clipboard',
    },
  ];

  void _handleShare(String option) {
    Navigator.of(context).pop();

    String message;
    switch (option) {
      case 'Social Media':
        message = 'Shared to social media successfully!';
        break;
      case 'Email':
        message = 'Email sent successfully!';
        break;
      case 'Save to Photos':
        message = 'Progress report saved to photos!';
        break;
      case 'Copy Link':
        Clipboard.setData(const ClipboardData(
            text: 'https://calorietracker.app/progress/shared/abc123'));
        message = 'Link copied to clipboard!';
        break;
      default:
        message = 'Shared successfully!';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 3.h),

          // Title
          Row(
            children: [
              CustomIconWidget(
                iconName: 'share',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Share Progress Report',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Format selection
          Text(
            'Export Format',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: formats.map((format) {
              final isSelected = selectedFormat == format;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedFormat = format),
                  child: Container(
                    margin: EdgeInsets.only(
                        right: format != formats.last ? 2.w : 0),
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      format,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 3.h),

          // Privacy controls
          Text(
            'Privacy Settings',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),

          _buildPrivacyOption(
            context,
            'Include Personal Data',
            'Name, age, and profile information',
            includePersonalData,
            (value) => setState(() => includePersonalData = value),
          ),
          _buildPrivacyOption(
            context,
            'Include Weight Data',
            'Weight progress and changes',
            includeWeightData,
            (value) => setState(() => includeWeightData = value),
          ),
          _buildPrivacyOption(
            context,
            'Include Calorie Data',
            'Daily calorie intake and goals',
            includeCalorieData,
            (value) => setState(() => includeCalorieData = value),
          ),
          _buildPrivacyOption(
            context,
            'Include Macro Data',
            'Protein, carbs, and fat breakdown',
            includeMacroData,
            (value) => setState(() => includeMacroData = value),
          ),

          SizedBox(height: 3.h),

          // Share options
          Text(
            'Share Options',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),

          ...shareOptions.map((option) => _buildShareOption(context, option)),

          SizedBox(height: 2.h),

          // Cancel button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildPrivacyOption(
    BuildContext context,
    String title,
    String description,
    bool value,
    Function(bool) onChanged,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildShareOption(BuildContext context, Map<String, dynamic> option) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: option['icon'],
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          option['title'],
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          option['description'],
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: CustomIconWidget(
          iconName: 'arrow_forward_ios',
          color: theme.colorScheme.onSurfaceVariant,
          size: 16,
        ),
        onTap: () => _handleShare(option['title']),
      ),
    );
  }
}
