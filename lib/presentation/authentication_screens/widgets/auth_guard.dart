import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

/// Widget that guards routes based on authentication state
class AuthGuard extends StatefulWidget {
  final Widget authenticatedChild;
  final Widget unauthenticatedChild;
  final Widget? loadingChild;

  const AuthGuard({
    super.key,
    required this.authenticatedChild,
    required this.unauthenticatedChild,
    this.loadingChild,
  });

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthDI.authService;
    _authService.addListener(_onAuthStateChanged);
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthStateChanged);
    super.dispose();
  }

  void _onAuthStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state while checking authentication
    if (_authService.isLoading) {
      return widget.loadingChild ?? const _LoadingWidget();
    }

    // Show appropriate child based on authentication state
    if (_authService.isAuthenticated) {
      return widget.authenticatedChild;
    } else {
      return widget.unauthenticatedChild;
    }
  }
}

/// Default loading widget for authentication
class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withAlpha(77),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'CalorieTracker',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Chargement...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
