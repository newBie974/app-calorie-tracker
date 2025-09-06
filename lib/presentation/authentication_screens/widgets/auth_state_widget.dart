import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

/// Widget that manages authentication state and navigation
class AuthStateWidget extends StatefulWidget {
  final Widget child;

  const AuthStateWidget({
    super.key,
    required this.child,
  });

  @override
  State<AuthStateWidget> createState() => _AuthStateWidgetState();
}

class _AuthStateWidgetState extends State<AuthStateWidget> {
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
    return widget.child;
  }
}

/// Mixin to provide authentication state to widgets
mixin AuthStateMixin<T extends StatefulWidget> on State<T> {
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

  /// Get the current authenticated user
  UserModel? get currentUser => _authService.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _authService.isAuthenticated;

  /// Check if authentication is loading
  bool get isAuthLoading => _authService.isLoading;

  /// Get current error message
  String? get authErrorMessage => _authService.errorMessage;

  /// Clear authentication error
  void clearAuthError() => _authService.clearError();
}
