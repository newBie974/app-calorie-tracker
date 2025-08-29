import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom app bar implementing Contemporary Wellness Minimalism design
/// with clean, minimal styling optimized for health tracking applications
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.bottom,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canPop = Navigator.of(context).canPop();

    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      actions: _buildActions(context),
      leading: _buildLeading(context, canPop),
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      shadowColor: colorScheme.shadow,
      bottom: bottom,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        statusBarBrightness: theme.brightness,
      ),
      titleTextStyle: theme.textTheme.titleLarge?.copyWith(
        color: foregroundColor ?? colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context, bool canPop) {
    if (leading != null) return leading;

    if (showBackButton || (automaticallyImplyLeading && canPop)) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () {
          HapticFeedback.lightImpact();
          if (onBackPressed != null) {
            onBackPressed!();
          } else {
            Navigator.of(context).pop();
          }
        },
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    if (actions == null || actions!.isEmpty) return null;

    return actions!.map((action) {
      if (action is IconButton) {
        return IconButton(
          icon: action.icon,
          onPressed: () {
            HapticFeedback.lightImpact();
            action.onPressed?.call();
          },
          tooltip: action.tooltip,
        );
      }
      return action;
    }).toList();
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}

/// Home dashboard app bar with profile and notifications
class CustomHomeAppBar extends CustomAppBar {
  CustomHomeAppBar({
    super.key,
    String? greeting,
    VoidCallback? onProfileTap,
    VoidCallback? onNotificationTap,
    int notificationCount = 0,
  }) : super(
          titleWidget: greeting != null
              ? _HomeTitle(greeting: greeting)
              : const _HomeTitle(greeting: 'Good morning'),
          centerTitle: false,
          actions: [
            _NotificationButton(
              onTap: onNotificationTap,
              count: notificationCount,
            ),
            _ProfileButton(onTap: onProfileTap),
          ],
        );
}

/// Food logging app bar with search functionality
class CustomFoodLogAppBar extends CustomAppBar {
  CustomFoodLogAppBar({
    super.key,
    VoidCallback? onSearchTap,
    VoidCallback? onScanTap,
  }) : super(
          title: 'Log Food',
          actions: [
            IconButton(
              icon: const Icon(Icons.qr_code_scanner_outlined),
              onPressed: onScanTap,
              tooltip: 'Scan barcode',
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: onSearchTap,
              tooltip: 'Search food',
            ),
          ],
        );
}

/// Progress tracking app bar with date picker
class CustomProgressAppBar extends CustomAppBar {
  CustomProgressAppBar({
    super.key,
    String? dateRange,
    VoidCallback? onDateTap,
    VoidCallback? onShareTap,
  }) : super(
          title: 'Progress',
          actions: [
            if (dateRange != null)
              TextButton.icon(
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(dateRange),
                onPressed: onDateTap,
              ),
            if (onShareTap != null)
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: onShareTap,
                tooltip: 'Share progress',
              ),
          ],
        );
}

// Private helper widgets

class _HomeTitle extends StatelessWidget {
  final String greeting;

  const _HomeTitle({required this.greeting});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          greeting,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          'Ready to track your nutrition?',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final VoidCallback? onTap;
  final int count;

  const _NotificationButton({
    this.onTap,
    this.count = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            HapticFeedback.lightImpact();
            onTap?.call();
          },
          tooltip: 'Notifications',
        ),
        if (count > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onError,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

class _ProfileButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _ProfileButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap?.call();
        },
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.person_outline,
            size: 20,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}