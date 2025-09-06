import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auth_result.dart';
import '../models/sign_in_request.dart';
import '../models/sign_up_request.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

/// Supabase implementation of AuthRepository
class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _supabase;

  SupabaseAuthRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        return UserModel.fromSupabaseUser(user);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }

  @override
  Future<AuthResult> signInWithEmail(SignInRequest request) async {
    try {
      if (!request.isValid) {
        return AuthResult.failure(
          message: request.validationError ?? 'Données de connexion invalides',
        );
      }

      final response = await _supabase.auth.signInWithPassword(
        email: request.email,
        password: request.password,
      );

      if (response.user != null) {
        final user = UserModel.fromSupabaseUser(response.user!);
        return AuthResult.success(
          user: user,
          message: 'Connexion réussie',
        );
      } else {
        return AuthResult.failure(
          message: 'Échec de la connexion',
        );
      }
    } on AuthException catch (e) {
      return AuthResult.failure(
        message: _getAuthErrorMessage(e),
        errorCode: e.statusCode,
        exception: e,
      );
    } catch (e) {
      return AuthResult.failure(
        message: 'Erreur réseau. Vérifiez votre connexion et réessayez.',
        exception: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  @override
  Future<AuthResult> signUpWithEmail(SignUpRequest request) async {
    try {
      if (!request.isValid) {
        return AuthResult.failure(
          message:
              request.validationError ?? 'Données d\'inscription invalides',
        );
      }

      final response = await _supabase.auth.signUp(
        email: request.email,
        password: request.password,
        data: {
          'full_name': request.fullName,
        },
      );

      if (response.user != null) {
        final user = UserModel.fromSupabaseUser(response.user!);
        return AuthResult.success(
          user: user,
          message: 'Compte créé avec succès',
        );
      } else {
        return AuthResult.failure(
          message: 'Échec de la création du compte',
        );
      }
    } on AuthException catch (e) {
      return AuthResult.failure(
        message: _getAuthErrorMessage(e),
        errorCode: e.statusCode,
        exception: e,
      );
    } catch (e) {
      return AuthResult.failure(
        message: 'Erreur réseau. Vérifiez votre connexion et réessayez.',
        exception: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  @override
  Future<AuthResult> signOut() async {
    try {
      await _supabase.auth.signOut();
      return AuthResult.success(
        user: null,
        message: 'Déconnexion réussie',
      );
    } catch (e) {
      return AuthResult.failure(
        message: 'Erreur lors de la déconnexion',
        exception: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  @override
  Future<AuthResult> resetPassword(String email) async {
    try {
      if (email.isEmpty ||
          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        return AuthResult.failure(
          message: 'Veuillez saisir une adresse e-mail valide',
        );
      }

      await _supabase.auth.resetPasswordForEmail(email);
      return AuthResult.success(
        user: null,
        message: 'E-mail de réinitialisation envoyé',
      );
    } on AuthException catch (e) {
      return AuthResult.failure(
        message: _getAuthErrorMessage(e),
        errorCode: e.statusCode,
        exception: e,
      );
    } catch (e) {
      return AuthResult.failure(
        message: 'Erreur lors de l\'envoi de l\'e-mail de réinitialisation',
        exception: e is Exception ? e : Exception(e.toString()),
      );
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.map((data) {
      if (data.session?.user != null) {
        return UserModel.fromSupabaseUser(data.session!.user);
      }
      return null;
    });
  }

  @override
  bool get isAuthenticated {
    return _supabase.auth.currentUser != null;
  }

  /// Convert Supabase AuthException to user-friendly error message
  String _getAuthErrorMessage(AuthException e) {
    switch (e.statusCode) {
      case 'invalid_credentials':
        return 'Adresse e-mail ou mot de passe incorrect';
      case 'email_not_confirmed':
        return 'Veuillez confirmer votre adresse e-mail avant de vous connecter';
      case 'user_not_found':
        return 'Aucun compte trouvé avec cette adresse e-mail';
      case 'email_address_invalid':
        return 'Adresse e-mail invalide';
      case 'password_too_short':
        return 'Le mot de passe doit contenir au moins 6 caractères';
      case 'signup_disabled':
        return 'L\'inscription est temporairement désactivée';
      case 'email_address_already_registered':
        return 'Un compte avec cette adresse e-mail existe déjà';
      case 'weak_password':
        return 'Le mot de passe est trop faible. Utilisez un mot de passe plus fort';
      case 'too_many_requests':
        return 'Trop de tentatives. Veuillez réessayer plus tard';
      default:
        return e.message.isNotEmpty
            ? e.message
            : 'Une erreur d\'authentification s\'est produite';
    }
  }
}
