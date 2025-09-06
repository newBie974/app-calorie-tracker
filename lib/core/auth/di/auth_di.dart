import 'package:flutter/foundation.dart';
import '../models/auth_result.dart';
import '../models/sign_in_request.dart';
import '../models/sign_up_request.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';
import '../repository/supabase_auth_repository.dart';
import '../services/auth_service.dart';
import '../usecases/get_current_user_usecase.dart';
import '../usecases/reset_password_usecase.dart';
import '../usecases/sign_in_usecase.dart';
import '../usecases/sign_out_usecase.dart';
import '../usecases/sign_up_usecase.dart';

/// Dependency injection container for authentication
class AuthDI {
  static AuthService? _authService;
  static AuthRepository? _authRepository;

  /// Get the authentication service singleton
  static AuthService get authService {
    _authService ??= _createAuthService();
    return _authService!;
  }

  /// Get the authentication repository singleton
  static AuthRepository get authRepository {
    _authRepository ??= _createAuthRepository();
    return _authRepository!;
  }

  /// Create authentication service with all dependencies
  static AuthService _createAuthService() {
    final authRepository = _createAuthRepository();

    final signInUseCase = SignInUseCase(authRepository);
    final signUpUseCase = SignUpUseCase(authRepository);
    final signOutUseCase = SignOutUseCase(authRepository);
    final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);
    final resetPasswordUseCase = ResetPasswordUseCase(authRepository);

    return AuthService(
      authRepository: authRepository,
      signInUseCase: signInUseCase,
      signUpUseCase: signUpUseCase,
      signOutUseCase: signOutUseCase,
      getCurrentUserUseCase: getCurrentUserUseCase,
      resetPasswordUseCase: resetPasswordUseCase,
    );
  }

  /// Create authentication repository
  static AuthRepository _createAuthRepository() {
    try {
      return SupabaseAuthRepository();
    } catch (e) {
      debugPrint('Error creating Supabase repository: $e');
      // Return a mock repository that always fails gracefully
      return _MockAuthRepository();
    }
  }
}

/// Mock repository for when Supabase is not available
class _MockAuthRepository implements AuthRepository {
  @override
  Future<UserModel?> getCurrentUser() async => null;

  @override
  Future<AuthResult> signInWithEmail(SignInRequest request) async {
    return AuthResult.failure(
      message:
          'Authentication service not available. Please check your internet connection.',
    );
  }

  @override
  Future<AuthResult> signUpWithEmail(SignUpRequest request) async {
    return AuthResult.failure(
      message:
          'Authentication service not available. Please check your internet connection.',
    );
  }

  @override
  Future<AuthResult> signOut() async {
    return AuthResult.failure(
      message: 'Authentication service not available.',
    );
  }

  @override
  Future<AuthResult> resetPassword(String email) async {
    return AuthResult.failure(
      message:
          'Authentication service not available. Please check your internet connection.',
    );
  }

  @override
  Stream<UserModel?> get authStateChanges => Stream.value(null);

  @override
  bool get isAuthenticated => false;

  /// Reset all singletons (useful for testing)
  static void reset() {
    AuthDI._authService?.dispose();
    AuthDI._authService = null;
    AuthDI._authRepository = null;
  }
}
