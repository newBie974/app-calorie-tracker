import '../models/auth_result.dart';
import '../repository/auth_repository.dart';

/// Use case for password reset
class ResetPasswordUseCase {
  final AuthRepository _authRepository;

  ResetPasswordUseCase(this._authRepository);

  /// Execute password reset
  Future<AuthResult> execute(String email) async {
    try {
      // Validate email
      if (email.isEmpty) {
        return AuthResult.failure(
          message: 'L\'adresse e-mail est requise',
        );
      }

      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        return AuthResult.failure(
          message: 'Veuillez saisir une adresse e-mail valide',
        );
      }

      return await _authRepository.resetPassword(email);
    } catch (e) {
      return AuthResult.failure(
        message: 'Erreur lors de la réinitialisation du mot de passe',
        exception: e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}
