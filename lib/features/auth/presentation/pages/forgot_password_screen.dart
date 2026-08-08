import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _showToast = false;
  String? _toastError;
  bool _resetStep = false;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showToastMessage(String message, {String? error}) {
    setState(() {
      _showToast = true;
      _toastError = error;
    });
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        setState(() => _showToast = false);
      }
    });
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;

    if (!_resetStep) {
      final email = _emailController.text.trim();
      final success = await ref.read(authProvider.notifier).resetPassword(email);
      if (!mounted) return;
      if (success) {
        setState(() => _resetStep = true);
        _showToastMessage('Reset code sent. Check your email.');
      } else {
        _showToastMessage(
          ref.read(authProvider).error ?? 'Something went wrong.',
          error: ref.read(authProvider).error,
        );
      }
      return;
    }

    final email = _emailController.text.trim();
    final code = _codeController.text.trim();
    final newPassword = _newPasswordController.text;
    final success = await ref.read(authProvider.notifier).completeResetPassword(
          email: email,
          token: code,
          newPassword: newPassword,
        );
    if (!mounted) return;
    if (success) {
      _showToastMessage('Password reset successfully. You can now sign in.');
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) {
          context.goNamed(RouteNames.nLogin);
        }
      });
    } else {
      _showToastMessage(
        ref.read(authProvider).error ?? 'Something went wrong.',
        error: ref.read(authProvider).error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          Column(
            children: [
              // Top App Bar
              Container(
                color: AppColors.surface,
                child: SafeArea(
                  bottom: false,
                  child: SizedBox(
                    height: 56,
                    child: Row(
                      children: [
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: () => context.pop(),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                ),
              ),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 48),

                      // Lock Icon
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 112,
                            height: 112,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.lock_reset,
                              color: AppColors.primary,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Title
                      Text(
                        'Reset Password',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          height: 36 / 28,
                          color: AppColors.onBackground,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _resetStep
                              ? 'Enter the 6-digit code we emailed you and choose a new password.'
                              : 'Enter your email address and we will send you a code to reset your password.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 20 / 14,
                            color: AppColors.secondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Email Label
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'EMAIL ADDRESS',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  height: 16 / 12,
                                  letterSpacing: 0.05,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Email Input with prefix icon
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'name@company.com',
                                prefixIcon: const Icon(
                                  Icons.mail_outlined,
                                  color: AppColors.outline,
                                  size: 20,
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                  minWidth: 48,
                                  minHeight: 48,
                                ),
                                filled: true,
                                fillColor: AppColors.surfaceContainerLowest,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.outlineVariant,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.outlineVariant,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            if (_resetStep) ...[
                              // Reset code
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'RESET CODE',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    height: 16 / 12,
                                    letterSpacing: 0.05,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _codeController,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                decoration: const InputDecoration(
                                  hintText: '6-digit code',
                                  counterText: '',
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().length != 6) {
                                    return 'Enter the 6-digit code';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // New password
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'NEW PASSWORD',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    height: 16 / 12,
                                    letterSpacing: 0.05,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _newPasswordController,
                                obscureText: _obscureNewPassword,
                                decoration: InputDecoration(
                                  hintText: '********',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureNewPassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: AppColors.outline,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureNewPassword = !_obscureNewPassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a new password';
                                  }
                                  if (value.length < 8) {
                                    return 'Min 8 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Confirm new password
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'CONFIRM PASSWORD',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    height: 16 / 12,
                                    letterSpacing: 0.05,
                                    color: AppColors.secondary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                decoration: InputDecoration(
                                  hintText: '********',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: AppColors.outline,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value != _newPasswordController.text) {
                                    return "Passwords don't match";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Send Reset Link Button
                            SizedBox(
                              height: 56,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: ref.watch(authProvider).isLoading ? null : _onSubmit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                  shadowColor:
                                      AppColors.primary.withValues(alpha: 0.05),
                                ),
                                child: ref.watch(authProvider).isLoading
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: AppColors.onPrimary,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              _resetStep
                                                  ? 'Reset Password'
                                                  : 'Send Reset Link',
                                              style: GoogleFonts.inter(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                height: 28 / 20,
                                                color: AppColors.onPrimary,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.send_outlined,
                                            color: AppColors.onPrimary,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Back to Login
                      TextButton.icon(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        label: Text(
                          'Back to Login',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 16 / 12,
                            letterSpacing: 0.05,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 96),

                      // Trust Indicators
                      Container(
                        padding: const EdgeInsets.only(top: 24),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: AppColors.surfaceContainerHigh,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildTrustIndicator(
                              Icons.shield_outlined,
                              'Secure',
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: AppColors.surfaceContainerHigh,
                            ),
                            _buildTrustIndicator(
                              Icons.lock_outline,
                              'Private',
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: AppColors.surfaceContainerHigh,
                            ),
                            _buildTrustIndicator(
                              Icons.verified_user_outlined,
                              'Verified',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Toast
          if (_showToast)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: _toastError != null
                      ? AppColors.errorContainer
                      : AppColors.inverseSurface,
                  borderRadius: BorderRadius.circular(99),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _toastError != null ? Icons.error_outline : Icons.check_circle,
                      color: _toastError != null
                          ? AppColors.onErrorContainer
                          : AppColors.tertiaryFixed,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _toastError ?? 'Reset link sent successfully.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 20 / 14,
                          color: _toastError != null
                              ? AppColors.onErrorContainer
                              : AppColors.inverseOnSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTrustIndicator(IconData icon, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.secondary,
          size: 18,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 16 / 12,
            letterSpacing: 0.05,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }
}
