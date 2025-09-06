/// Request model for sign in operations
class SignInRequest {
  final String email;
  final String password;

  const SignInRequest({
    required this.email,
    required this.password,
  });

  /// Validate the sign in request
  bool get isValid {
    return email.isNotEmpty &&
        password.isNotEmpty &&
        _isValidEmail(email) &&
        password.length >= 6;
  }

  /// Check if email format is valid
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Get validation error message
  String? get validationError {
    if (email.isEmpty) return 'L\'adresse e-mail est requise';
    if (!_isValidEmail(email))
      return 'Veuillez saisir une adresse e-mail valide';
    if (password.isEmpty) return 'Le mot de passe est requis';
    if (password.length < 6)
      return 'Le mot de passe doit contenir au moins 6 caractères';
    return null;
  }

  @override
  String toString() {
    return 'SignInRequest(email: $email, password: [HIDDEN])';
  }
}
