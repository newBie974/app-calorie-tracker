/// Request model for sign up operations
class SignUpRequest {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;

  const SignUpRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  /// Validate the sign up request
  bool get isValid {
    return fullName.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        _isValidEmail(email) &&
        _isValidPassword(password) &&
        password == confirmPassword;
  }

  /// Check if email format is valid
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Check if password meets requirements
  bool _isValidPassword(String password) {
    return password.length >= 6 &&
        RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(password);
  }

  /// Get validation error message
  String? get validationError {
    if (fullName.isEmpty) return 'Le nom est requis';
    if (fullName.length < 2)
      return 'Le nom doit contenir au moins 2 caractères';
    if (email.isEmpty) return 'L\'adresse e-mail est requise';
    if (!_isValidEmail(email))
      return 'Veuillez saisir une adresse e-mail valide';
    if (password.isEmpty) return 'Le mot de passe est requis';
    if (password.length < 6)
      return 'Le mot de passe doit contenir au moins 6 caractères';
    if (!_isValidPassword(password))
      return 'Le mot de passe doit contenir des lettres et des chiffres';
    if (confirmPassword.isEmpty) return 'Veuillez confirmer votre mot de passe';
    if (password != confirmPassword)
      return 'Les mots de passe ne correspondent pas';
    return null;
  }

  @override
  String toString() {
    return 'SignUpRequest(fullName: $fullName, email: $email, password: [HIDDEN], confirmPassword: [HIDDEN])';
  }
}
