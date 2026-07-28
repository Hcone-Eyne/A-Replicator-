import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';

class SecurityVerificationScreen extends ConsumerStatefulWidget {
  const SecurityVerificationScreen({super.key});

  @override
  ConsumerState<SecurityVerificationScreen> createState() =>
      _SecurityVerificationScreenState();
}

class _SecurityVerificationScreenState extends ConsumerState<SecurityVerificationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  double _currentProgress = 0;
  String _currentStatus = 'Verifying identity...';
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _progressController.addListener(() {
      setState(() {
        _currentProgress = _progressAnimation.value;
        if (_currentProgress < 30) {
          _currentStatus = 'Verifying identity...';
        } else if (_currentProgress < 60) {
          _currentStatus = 'Checking security protocols...';
        } else if (_currentProgress < 90) {
          _currentStatus = 'Establishing secure connection...';
        } else {
          _currentStatus = 'Finalizing verification...';
        }
      });
    });

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isComplete = true);
      }
    });

    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Verification Icon
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: _isComplete
                      ? AppColors.onTertiaryContainer.withValues(alpha: 0.1)
                      : AppColors.primaryContainer.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isComplete ? Icons.check_circle : Icons.shield_outlined,
                  color: _isComplete
                      ? AppColors.onTertiaryContainer
                      : AppColors.primary,
                  size: 56,
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Text(
                _isComplete ? 'Verification Complete' : 'Security Verification',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 32 / 24,
                  color: AppColors.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                _isComplete
                    ? 'Your profile is now secured with TrustMarket\'s cryptographic node system.'
                    : 'Verifying your identity to ensure a secure marketplace experience.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Progress Section
              if (!_isComplete) ...[
                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: _currentProgress / 100,
                    minHeight: 8,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Status Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.onTertiaryContainer,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_currentProgress.toInt()}%',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 20 / 14,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _currentStatus.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 16 / 12,
                        letterSpacing: 0.05,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],

              const Spacer(flex: 2),

              // Security Badges
              if (_isComplete) ...[
                  SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                    onPressed: () async {
                      await ref.read(authProvider.notifier).login('', '');
                      if (!mounted) return;
                      // ignore: use_build_context_synchronously
                      context.goNamed(RouteNames.mainShell);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 28 / 20,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // Trust Badges
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBadge(Icons.verified_user_outlined, 'PCI-DSS'),
                  const SizedBox(width: 24),
                  _buildBadge(Icons.lock_outline, '256-bit SSL'),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.outline, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            height: 16 / 12,
            letterSpacing: 0.05,
            color: AppColors.outline,
          ),
        ),
      ],
    );
  }
}
