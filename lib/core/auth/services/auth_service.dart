import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/auth_result.dart';
import '../models/sign_in_request.dart';
import '../models/sign_up_request.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';
import '../usecases/get_current_user_usecase.dart';
import '../usecases/reset_password_usecase.dart';
import '../usecases/sign_in_usecase.dart';
import '../usecases/sign_out_usecase.dart';
import '../usecases/sign_up_usecase.dart';

/// Authentication service that coordinates all authentication operations
class AuthService extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<UserModel?>? _authStateSubscription;

  AuthService({
    required AuthRepository authRepository,
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
  })  : _authRepository = authRepository,
        _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _signOutUseCase = signOutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _resetPasswordUseCase = resetPasswordUseCase {
    _initializeAuth();
  }

  /// Current authenticated user
  UserModel? get currentUser => _currentUser;

  /// Whether user is authenticated
  bool get isAuthenticated => _currentUser != null;

  /// Whether authentication operation is in progress
  bool get isLoading => _isLoading;

  /// Current error message
  String? get errorMessage => _errorMessage;

  /// Initialize authentication state
  Future<void> _initializeAuth() async {
    _setLoading(true);
    try {
      // Get current user
      _currentUser = await _getCurrentUserUseCase.execute();

      // Listen to auth state changes
      _authStateSubscription = _authRepository.authStateChanges.listen(
        (user) {
          _currentUser = user;
          notifyListeners();
        },
        onError: (error) {
          debugPrint('Auth state change error: $error');
          _setError('Authentication error occurred');
        },
      );
    } catch (e) {
      debugPrint('Error initializing auth: $e');
      _setError('Failed to initialize authentication');
    } finally {
      _setLoading(false);
    }
  }

  /// Sign in with email and password
  Future<AuthResult> signInWithEmail(SignInRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _signInUseCase.execute(request);

      if (result.isSuccess) {
        _currentUser = result.user;
        notifyListeners();
      } else {
        _setError(result.message ?? 'Erreur de connexion');
      }

      return result;
    } catch (e) {
      final errorMessage = 'Erreur lors de la connexion';
      _setError(errorMessage);
      return AuthResult.failure(
        message: errorMessage,
        exception: e is Exception ? e : Exception(e.toString()),
      );
    } finally {
      _setLoading(false);
    }
  }

  /// Sign up with email and password
  Future<AuthResult> signUpWithEmail(SignUpRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _signUpUseCase.execute(request);

      if (result.isSuccess) {
        _currentUser = result.user;
        notifyListeners();
      } else {
        _setError(result.message ?? 'Erreur d\'inscription');
      }

      return result;
    } catch (e) {
      final errorMessage = 'Erreur lors de l\'inscription';
      _setError(errorMessage);
      return AuthResult.failure(
        message: errorMessage,
        exception: e is Exception ? e : Exception(e.toString()),
      );
    } finally {
      _setLoading(false);
    }
  }

  /// Sign out current user
  Future<AuthResult> signOut() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _signOutUseCase.execute();

      if (result.isSuccess) {
        _currentUser = null;
        notifyListeners();
      } else {
        _setError(result.message ?? 'Erreur de déconnexion');
      }

      return result;
    } catch (e) {
      final errorMessage = 'Erreur lors de la déconnexion';
      _setError(errorMessage);
      return AuthResult.failure(
        message: errorMessage,
        exception: e is Exception ? e : Exception(e.toString()),
      );
    } finally {
      _setLoading(false);
    }
  }

  /// Reset password
  Future<AuthResult> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _resetPasswordUseCase.execute(email);

      if (result.isFailure) {
        _setError(result.message ?? 'Erreur lors de la réinitialisation');
      }

      return result;
    } catch (e) {
      final errorMessage = 'Erreur lors de la réinitialisation du mot de passe';
      _setError(errorMessage);
      return AuthResult.failure(
        message: errorMessage,
        exception: e is Exception ? e : Exception(e.toString()),
      );
    } finally {
      _setLoading(false);
    }
  }

  /// Clear current error
  void clearError() {
    _clearError();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}
