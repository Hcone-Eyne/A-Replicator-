import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.primary,
    this.size = AppBadgeSize.sm,
    this.avatar,
    this.trailing = true,
  });

  final String label;
  final AppBadgeVariant variant;
  final AppBadgeSize size;
  final Widget? avatar;
  final bool trailing;

  double get _height {
    switch (size) {
      case AppBadgeSize.sm:
        return 20;
      case AppBadgeSize.md:
        return 24;
      case AppBadgeSize.lg:
        return 28;
    }
  }

  double get _fontSize {
    switch (size) {
      case AppBadgeSize.sm:
        return 10;
      case AppBadgeSize.md:
        return 12;
      case AppBadgeSize.lg:
        return 14;
    }
  }

  double get _paddingHorizontal {
    switch (size) {
      case AppBadgeSize.sm:
        return 8;
      case AppBadgeSize.md:
        return 10;
      case AppBadgeSize.lg:
        return 12;
    }
  }

  double get _avatarSize {
    switch (size) {
      case AppBadgeSize.sm:
        return 16;
      case AppBadgeSize.md:
        return 18;
      case AppBadgeSize.lg:
        return 20;
    }
  }

  Color _resolveBackgroundColor() {
    switch (variant) {
      case AppBadgeVariant.primary:
        return AppColors.primary;
      case AppBadgeVariant.secondary:
        return AppColors.secondary;
      case AppBadgeVariant.success:
        return AppColors.success;
      case AppBadgeVariant.warning:
        return AppColors.warning;
      case AppBadgeVariant.error:
        return AppColors.error;
      case AppBadgeVariant.outline:
        return AppColors.surfaceContainer;
    }
  }

  Color _resolveTextColor() {
    switch (variant) {
      case AppBadgeVariant.primary:
        return AppColors.onPrimary;
      case AppBadgeVariant.secondary:
        return AppColors.onSecondary;
      case AppBadgeVariant.success:
        return AppColors.onSurface;
      case AppBadgeVariant.warning:
        return AppColors.onSurface;
      case AppBadgeVariant.error:
        return AppColors.onError;
      case AppBadgeVariant.outline:
        return AppColors.primary;
    }
  }

  Color? _resolveBorderColor() {
    switch (variant) {
      case AppBadgeVariant.outline:
        return AppColors.outline;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      padding: EdgeInsets.symmetric(horizontal: _paddingHorizontal),
      decoration: BoxDecoration(
        color: _resolveBackgroundColor(),
        borderRadius: BorderRadius.circular(4),
        border: _resolveBorderColor() != null
            ? Border.all(color: _resolveBorderColor()!)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (avatar != null) ...[
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: SizedBox(
                width: _avatarSize,
                height: _avatarSize,
                child: avatar,
              ),
            ),
          ],
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: _fontSize,
              fontWeight: FontWeight.w600,
              color: _resolveTextColor(),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (trailing) ...[
            const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}

enum AppBadgeVariant { primary, secondary, success, warning, error, outline }

enum AppBadgeSize { sm, md, lg }