import '../models/auth_result.dart';
import '../models/sign_in_request.dart';
import '../models/sign_up_request.dart';
import '../models/user_model.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Get the current authenticated user
  Future<UserModel?> getCurrentUser();

  /// Sign in with email and password
  Future<AuthResult> signInWithEmail(SignInRequest request);

  /// Sign up with email and password
  Future<AuthResult> signUpWithEmail(SignUpRequest request);

  /// Sign out the current user
  Future<AuthResult> signOut();

  /// Send password reset email
  Future<AuthResult> resetPassword(String email);

  /// Listen to authentication state changes
  Stream<UserModel?> get authStateChanges;

  /// Check if user is currently authenticated
  bool get isAuthenticated;
}
