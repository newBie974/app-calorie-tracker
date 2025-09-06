import '../models/auth_result.dart';
import '../models/sign_up_request.dart';
import '../repository/auth_repository.dart';

/// Use case for user sign up
class SignUpUseCase {
  final AuthRepository _authRepository;

  SignUpUseCase(this._authRepository);

  /// Execute sign up with email and password
  Future<AuthResult> execute(SignUpRequest request) async {
    try {
      // Validate request
      if (!request.isValid) {
        return AuthResult.failure(
          message:
              request.validationError ?? 'Données d\'inscription invalides',
        );
      }

      // Perform sign up
      return await _authRepository.signUpWithEmail(request);
    } catch (e) {
      return AuthResult.failure(
        message: 'Erreur lors de l\'inscription',
        exception: e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}
