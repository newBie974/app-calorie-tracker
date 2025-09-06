import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegisterFormWidget extends StatefulWidget {
  final VoidCallback? onRegisterSuccess;
  final VoidCallback? onSwitchToLogin;

  const RegisterFormWidget({
    super.key,
    this.onRegisterSuccess,
    this.onSwitchToLogin,
  });

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late AnimationController _buttonController;
  late AnimationController _checkboxController;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _checkboxScaleAnimation;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _checkboxController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));

    _checkboxScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _checkboxController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _buttonController.dispose();
    _checkboxController.dispose();
    super.dispose();
  }

  void _validateName(String value) {
    setState(() {
      if (value.isEmpty) {
        _nameError = 'Le nom est requis';
      } else if (value.length < 2) {
        _nameError = 'Le nom doit contenir au moins 2 caractères';
      } else {
        _nameError = null;
      }
    });
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = 'L\'adresse e-mail est requise';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _emailError = 'Veuillez saisir une adresse e-mail valide';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'Le mot de passe est requis';
      } else if (value.length < 6) {
        _passwordError = 'Le mot de passe doit contenir au moins 6 caractères';
      } else if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
        _passwordError =
            'Le mot de passe doit contenir des lettres et des chiffres';
      } else {
        _passwordError = null;
      }
    });

    // Re-validate confirm password if it has content
    if (_confirmPasswordController.text.isNotEmpty) {
      _validateConfirmPassword(_confirmPasswordController.text);
    }
  }

  void _validateConfirmPassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPasswordError = 'Veuillez confirmer votre mot de passe';
      } else if (value != _passwordController.text) {
        _confirmPasswordError = 'Les mots de passe ne correspondent pas';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  bool get _isFormValid =>
      _nameError == null &&
      _emailError == null &&
      _passwordError == null &&
      _confirmPasswordError == null &&
      _nameController.text.isNotEmpty &&
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty &&
      _acceptTerms;

  Future<void> _handleRegister() async {
    if (!_isFormValid) return;

    // Button press animation
    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });

    setState(() => _isLoading = true);

    try {
      // Create sign up request
      final signUpRequest = SignUpRequest(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      // Perform registration using AuthService
      final authService = AuthDI.authService;
      final result = await authService.signUpWithEmail(signUpRequest);

      if (result.isSuccess) {
        HapticFeedback.lightImpact();
        widget.onRegisterSuccess?.call();
      } else {
        _showErrorMessage(result.message ?? 'Erreur d\'inscription');
      }
    } catch (e) {
      _showErrorMessage('L\'inscription a échoué. Veuillez réessayer.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                color: AppTheme.lightTheme.colorScheme.error,
                size: 4.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String iconName,
    required String? errorText,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool obscureText = false,
    Widget? suffixIcon,
    Function(String)? onFieldSubmitted,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(128),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: errorText != null
                  ? theme.colorScheme.error.withAlpha(128)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            obscureText: obscureText,
            enabled: !_isLoading,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: Padding(
                padding: EdgeInsets.all(4.w),
                child: CustomIconWidget(
                  iconName: iconName,
                  color: errorText != null
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
              suffixIcon: suffixIcon,
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 2.h,
              ),
              errorText: null,
            ),
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: 4.w,
                  color: theme.colorScheme.error,
                ),
                SizedBox(width: 2.w),
                Text(
                  errorText,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Name Field
          _buildInputField(
            controller: _nameController,
            label: 'Nom Complet',
            hint: 'Saisissez votre nom complet',
            iconName: 'person',
            errorText: _nameError,
            onChanged: _validateName,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
          ),

          SizedBox(height: 3.h),

          // Email Field
          _buildInputField(
            controller: _emailController,
            label: 'Adresse E-mail',
            hint: 'Saisissez votre adresse e-mail',
            iconName: 'email',
            errorText: _emailError,
            onChanged: _validateEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),

          SizedBox(height: 3.h),

          // Password Field
          _buildInputField(
            controller: _passwordController,
            label: 'Mot de Passe',
            hint: 'Créez un mot de passe fort',
            iconName: 'lock',
            errorText: _passwordError,
            onChanged: _validatePassword,
            textInputAction: TextInputAction.next,
            obscureText: !_isPasswordVisible,
            suffixIcon: Container(
              margin: EdgeInsets.only(right: 2.w),
              child: IconButton(
                icon: CustomIconWidget(
                  iconName:
                      _isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Confirm Password Field
          _buildInputField(
            controller: _confirmPasswordController,
            label: 'Confirmer le Mot de Passe',
            hint: 'Ressaisissez votre mot de passe',
            iconName: 'lock',
            errorText: _confirmPasswordError,
            onChanged: _validateConfirmPassword,
            textInputAction: TextInputAction.done,
            obscureText: !_isConfirmPasswordVisible,
            onFieldSubmitted: (_) => _handleRegister(),
            suffixIcon: Container(
              margin: EdgeInsets.only(right: 2.w),
              child: IconButton(
                icon: CustomIconWidget(
                  iconName: _isConfirmPasswordVisible
                      ? 'visibility_off'
                      : 'visibility',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Enhanced Terms and Conditions Checkbox
          ScaleTransition(
            scale: _checkboxScaleAnimation,
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withAlpha(128),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    margin: EdgeInsets.only(top: 1.w),
                    child: Transform.scale(
                      scale: 1.2,
                      child: Checkbox(
                        value: _acceptTerms,
                        onChanged: _isLoading
                            ? null
                            : (value) {
                                HapticFeedback.selectionClick();
                                _checkboxController.forward().then((_) {
                                  _checkboxController.reverse();
                                });
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                        activeColor: AppTheme.primaryGreen,
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () {
                              HapticFeedback.selectionClick();
                              _checkboxController.forward().then((_) {
                                _checkboxController.reverse();
                              });
                              setState(() {
                                _acceptTerms = !_acceptTerms;
                              });
                            },
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.5.w),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                            children: [
                              const TextSpan(text: 'J\'accepte les '),
                              TextSpan(
                                text: 'Conditions d\'Utilisation',
                                style: GoogleFonts.inter(
                                  color: AppTheme.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      AppTheme.primaryGreen.withAlpha(128),
                                ),
                              ),
                              const TextSpan(text: ' et la '),
                              TextSpan(
                                text: 'Politique de Confidentialité',
                                style: GoogleFonts.inter(
                                  color: AppTheme.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor:
                                      AppTheme.primaryGreen.withAlpha(128),
                                ),
                              ),
                              const TextSpan(text: ' de CalorieTracker'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Enhanced Create Account Button with Animation
          ScaleTransition(
            scale: _buttonScaleAnimation,
            child: Container(
              height: 7.h,
              decoration: BoxDecoration(
                gradient: _isFormValid && !_isLoading
                    ? AppTheme.primaryGradient
                    : LinearGradient(
                        colors: [
                          theme.colorScheme.surfaceContainerHighest,
                          theme.colorScheme.surfaceContainerHighest,
                        ],
                      ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: _isFormValid && !_isLoading
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withAlpha(77),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              child: ElevatedButton(
                onPressed: _isFormValid && !_isLoading ? _handleRegister : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 5.w,
                        width: 5.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Créer un Compte',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: _isFormValid && !_isLoading
                                  ? Colors.white
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.1,
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: _isFormValid && !_isLoading
                                ? Colors.white
                                : theme.colorScheme.onSurfaceVariant,
                            size: 5.w,
                          ),
                        ],
                      ),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Enhanced Switch to Login
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Vous avez déjà un compte ? ',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextButton(
                onPressed: _isLoading ? null : widget.onSwitchToLogin,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Se Connecter',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: AppTheme.primaryGreen.withAlpha(128),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
