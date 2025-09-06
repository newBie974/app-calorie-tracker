import 'user_model.dart';

/// Result of authentication operations
class AuthResult {
  final bool isSuccess;
  final String? message;
  final UserModel? user;
  final String? errorCode;
  final Exception? exception;

  const AuthResult._({
    required this.isSuccess,
    this.message,
    this.user,
    this.errorCode,
    this.exception,
  });

  /// Create a successful authentication result
  factory AuthResult.success({
    UserModel? user,
    String? message,
  }) {
    return AuthResult._(
      isSuccess: true,
      user: user,
      message: message,
    );
  }

  /// Create a failed authentication result
  factory AuthResult.failure({
    required String message,
    String? errorCode,
    Exception? exception,
  }) {
    return AuthResult._(
      isSuccess: false,
      message: message,
      errorCode: errorCode,
      exception: exception,
    );
  }

  /// Check if the result is successful
  bool get isFailure => !isSuccess;

  @override
  String toString() {
    if (isSuccess) {
      return 'AuthResult.success(user: $user, message: $message)';
    } else {
      return 'AuthResult.failure(message: $message, errorCode: $errorCode)';
    }
  }
}
