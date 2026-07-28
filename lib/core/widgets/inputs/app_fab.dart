import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_colors.dart';

class AppFAB extends StatelessWidget {
  const AppFAB({
    super.key,
    required this.icon,
    this.onPressed,
    this.label,
    this.variant = AppFABVariant.primary,
    this.size = AppFABSize.md,
    this.elevation = 3,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? label;
  final AppFABVariant variant;
  final AppFABSize size;
  final double elevation;

  double get _iconSize {
    switch (size) {
      case AppFABSize.sm:
        return 20;
      case AppFABSize.md:
        return 24;
      case AppFABSize.lg:
        return 32;
    }
  }

  Color _resolveBackgroundColor() {
    switch (variant) {
      case AppFABVariant.primary:
        return AppColors.primary;
      case AppFABVariant.secondary:
        return AppColors.secondary;
      case AppFABVariant.surface:
        return AppColors.surfaceContainer;
      case AppFABVariant.destructive:
        return AppColors.error;
    }
  }

  Color _resolveIconColor() {
    switch (variant) {
      case AppFABVariant.primary:
        return AppColors.onPrimary;
      case AppFABVariant.secondary:
        return AppColors.onSecondary;
      case AppFABVariant.surface:
        return AppColors.onSurface;
      case AppFABVariant.destructive:
        return AppColors.onError;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: _resolveBackgroundColor(),
        foregroundColor: _resolveIconColor(),
        elevation: elevation,
        child: Icon(icon, size: _iconSize),
      ).animate().scale().fadeIn(),
    );
  }
}

enum AppFABVariant { primary, secondary, surface, destructive }

enum AppFABSize { sm, md, lg }