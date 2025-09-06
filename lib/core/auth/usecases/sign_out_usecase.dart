import '../models/auth_result.dart';
import '../repository/auth_repository.dart';

/// Use case for user sign out
class SignOutUseCase {
  final AuthRepository _authRepository;

  SignOutUseCase(this._authRepository);

  /// Execute sign out
  Future<AuthResult> execute() async {
    try {
      return await _authRepository.signOut();
    } catch (e) {
      return AuthResult.failure(
        message: 'Erreur lors de la déconnexion',
        exception: e is Exception ? e : Exception(e.toString()),
      );
    }
  }
}
