import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onSwitchToRegister;

  const LoginFormWidget({
    super.key,
    this.onLoginSuccess,
    this.onForgotPassword,
    this.onSwitchToRegister,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _buttonController;
  late Animation<double> _buttonScaleAnimation;

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _buttonController.dispose();
    super.dispose();
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
      } else {
        _passwordError = null;
      }
    });
  }

  bool get _isFormValid =>
      _emailError == null &&
      _passwordError == null &&
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty;

  Future<void> _handleLogin() async {
    if (!_isFormValid) return;

    // Button press animation
    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });

    setState(() => _isLoading = true);

    try {
      // Mock authentication - replace with actual authentication logic
      await Future.delayed(const Duration(seconds: 2));

      // Mock credentials for testing
      const mockEmail = 'user@example.com';
      const mockPassword = 'password123';

      if (_emailController.text == mockEmail &&
          _passwordController.text == mockPassword) {
        HapticFeedback.lightImpact();
        widget.onLoginSuccess?.call();
      } else {
        _showErrorMessage(
            'Adresse e-mail ou mot de passe incorrect. Veuillez réessayer.');
      }
    } catch (e) {
      _showErrorMessage(
          'Erreur réseau. Vérifiez votre connexion et réessayez.');
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Enhanced Email Field with Modern Design
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.surfaceContainerHighest.withAlpha(128),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _emailError != null
                        ? theme.colorScheme.error.withAlpha(128)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !_isLoading,
                  onChanged: _validateEmail,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Adresse E-mail',
                    hintText: 'Saisissez votre adresse e-mail',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: CustomIconWidget(
                        iconName: 'email',
                        color: _emailError != null
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                    ),
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
              if (_emailError != null) ...[
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
                        _emailError!,
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
          ),

          SizedBox(height: 4.h),

          // Enhanced Password Field with Modern Design
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.surfaceContainerHighest.withAlpha(128),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _passwordError != null
                        ? theme.colorScheme.error.withAlpha(128)
                        : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  textInputAction: TextInputAction.done,
                  enabled: !_isLoading,
                  onChanged: _validatePassword,
                  onFieldSubmitted: (_) => _handleLogin(),
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Mot de Passe',
                    hintText: 'Saisissez votre mot de passe',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: CustomIconWidget(
                        iconName: 'lock',
                        color: _passwordError != null
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurfaceVariant,
                        size: 5.w,
                      ),
                    ),
                    suffixIcon: Container(
                      margin: EdgeInsets.only(right: 2.w),
                      child: IconButton(
                        icon: CustomIconWidget(
                          iconName: _isPasswordVisible
                              ? 'visibility_off'
                              : 'visibility',
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
              if (_passwordError != null) ...[
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
                        _passwordError!,
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
          ),

          SizedBox(height: 3.h),

          // Enhanced Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _isLoading ? null : widget.onForgotPassword,
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Mot de Passe Oublié ?',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  decorationColor: AppTheme.primaryGreen.withAlpha(128),
                ),
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Enhanced Sign In Button with Animation
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
                onPressed: _isFormValid && !_isLoading ? _handleLogin : null,
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
                            'Se Connecter',
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

          // Enhanced Switch to Register
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Vous n'avez pas de compte ? ",
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextButton(
                onPressed: _isLoading ? null : widget.onSwitchToRegister,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'S\'inscrire',
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
