import '../models/auth_result.dart';
import '../models/sign_in_request.dart';
import '../repository/auth_repository.dart';

/// Use case for user sign in
class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  /// Execute sign in with email and password
  Future<AuthResult> execute(SignInRequest request) async {
    try {
      // Validate request
      if (!request.isValid) {
        return AuthResult.failure(
          message: request.validationError ?? 'Données de connexion invalides',
        );
      }

      // Perform sign in
      return await _authRepository.signInWithEmail(request);
    } catch (e) {
      return AuthResult.failure(
        message: 'Erreur lors de la connexion',
        exception: e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}
