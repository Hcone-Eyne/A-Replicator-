import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSending = false;
  bool _showToast = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSending = true);

      // Simulate API call
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        setState(() {
          _isSending = false;
          _showToast = true;
        });

        Future.delayed(const Duration(seconds: 4), () {
          if (mounted) {
            setState(() => _showToast = false);
          }
        });
      });
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
                          onPressed: () => Navigator.of(context).pop(),
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
                          'Enter your email address and we will send you a link to reset your password.',
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

                            // Send Reset Link Button
                            SizedBox(
                              height: 56,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isSending ? null : _onSubmit,
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
                                child: _isSending
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
                                              'Send Reset Link',
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
                        onPressed: () => Navigator.of(context).pop(),
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
                  color: AppColors.inverseSurface,
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
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.tertiaryFixed,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Reset link sent successfully.',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        color: AppColors.inverseOnSurface,
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
