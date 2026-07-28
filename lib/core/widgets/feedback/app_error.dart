import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../buttons/app_button.dart';

class AppError extends StatelessWidget {
  const AppError({
    super.key,
    this.message = 'Something went wrong',
    this.onRetry,
    this.icon,
  });

  final String message;
  final VoidCallback? onRetry;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (icon ??
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ))
              .animate()
              .fadeIn(delay: 200.ms)
              .scale(),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.onSurfaceVariant,
            ),
          )
              .animate()
              .fadeIn(delay: 400.ms),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            AppButton(
              label: 'Retry',
              onPressed: onRetry,
              variant: AppButtonVariant.outline,
              size: AppButtonSize.sm,
            )
                .animate()
                .fadeIn(delay: 600.ms)
                .scale(),
          ],
        ],
      ).animate().fadeIn(),
    );
  }
}