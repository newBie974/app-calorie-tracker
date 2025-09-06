import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom bottom navigation bar implementing Contemporary Wellness Minimalism
/// with adaptive navigation patterns for health tracking application
class CustomBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onTap;
  final bool showLabels;

  const CustomBottomBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
    this.showLabels = true,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap(int index) {
    if (index == widget.currentIndex) return;

    // Haptic feedback for successful navigation
    HapticFeedback.lightImpact();

    // Scale animation for tap feedback
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Call external onTap callback instead of navigating directly
    widget.onTap?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow,
                  offset: const Offset(0, -2),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: SafeArea(
              child: Container(
                height: 80,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context: context,
                      index: 0,
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home,
                      label: 'Home',
                    ),
                    _buildNavItem(
                      context: context,
                      index: 1,
                      icon: Icons.search_outlined,
                      activeIcon: Icons.search,
                      label: 'Log Food',
                    ),
                    _buildNavItem(
                      context: context,
                      index: 2,
                      icon: Icons.trending_up_outlined,
                      activeIcon: Icons.trending_up,
                      label: 'Progress',
                    ),
                    _buildNavItem(
                      context: context,
                      index: 3,
                      icon: Icons.qr_code_scanner_outlined,
                      activeIcon: Icons.qr_code_scanner,
                      label: 'QR Scanner',
                    ),
                    _buildNavItem(
                      context: context,
                      index: 4,
                      icon: Icons.chat_outlined,
                      activeIcon: Icons.chat,
                      label: 'AI Chat',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = widget.currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _handleTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with smooth transition
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  isSelected ? activeIcon : icon,
                  key: ValueKey(isSelected),
                  size: 24,
                  color:
                      isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                ),
              ),

              // Label with fade transition
              if (widget.showLabels) ...[
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: theme.textTheme.labelSmall!.copyWith(
                    color:
                        isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],

              // Active indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                margin: const EdgeInsets.only(top: 2),
                height: 2,
                width: isSelected ? 20 : 0,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
