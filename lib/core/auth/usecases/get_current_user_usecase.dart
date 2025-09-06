import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../repository/auth_repository.dart';

/// Use case for getting current authenticated user
class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  GetCurrentUserUseCase(this._authRepository);

  /// Execute getting current user
  Future<UserModel?> execute() async {
    try {
      return await _authRepository.getCurrentUser();
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }
}
