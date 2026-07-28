import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, destructive }

enum AppButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.icon,
    this.iconPosition = AppButtonIconPosition.leading,
    this.loading = false,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final AppButtonIconPosition iconPosition;
  final bool loading;
  final bool fullWidth;

  bool get _hasIcon => icon != null;

  double get _height {
    switch (size) {
      case AppButtonSize.sm:
        return 36;
      case AppButtonSize.md:
        return 44;
      case AppButtonSize.lg:
        return 52;
    }
  }

  EdgeInsetsGeometry get _padding {
    switch (size) {
      case AppButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case AppButtonSize.md:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
      case AppButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  double get _iconSize {
    switch (size) {
      case AppButtonSize.sm:
        return 16;
      case AppButtonSize.md:
        return 20;
      case AppButtonSize.lg:
        return 22;
    }
  }

  double get _fontSize {
    switch (size) {
      case AppButtonSize.sm:
        return 13;
      case AppButtonSize.md:
        return 14;
      case AppButtonSize.lg:
        return 16;
    }
  }

  double get _borderRadius => 12;

  Color _resolveBackgroundColor(BuildContext context) {
    if (loading) return Colors.transparent;
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.primary;
      case AppButtonVariant.secondary:
        return AppColors.secondaryContainer;
      case AppButtonVariant.outline:
        return Colors.transparent;
      case AppButtonVariant.ghost:
        return Colors.transparent;
      case AppButtonVariant.destructive:
        return AppColors.error;
    }
  }

  Color _resolveTextColor() {
    if (loading) {
      switch (variant) {
        case AppButtonVariant.primary:
          return AppColors.onPrimary;
        case AppButtonVariant.secondary:
          return AppColors.onSecondaryContainer;
        case AppButtonVariant.outline:
          return AppColors.primary;
        case AppButtonVariant.ghost:
          return AppColors.primary;
        case AppButtonVariant.destructive:
          return AppColors.onError;
      }
    }
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.onPrimary;
      case AppButtonVariant.secondary:
        return AppColors.onSecondaryContainer;
      case AppButtonVariant.outline:
        return AppColors.primary;
      case AppButtonVariant.ghost:
        return AppColors.primary;
      case AppButtonVariant.destructive:
        return AppColors.onError;
    }
  }

  Color? _resolveBorderColor() {
    switch (variant) {
      case AppButtonVariant.outline:
        return AppColors.outline;
      default:
        return Colors.transparent;
    }
  }

  Color _resolveIconColor() {
    if (loading) {
      return _resolveTextColor();
    }
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.onPrimary;
      case AppButtonVariant.secondary:
        return AppColors.onSecondaryContainer;
      case AppButtonVariant.outline:
        return AppColors.primary;
      case AppButtonVariant.ghost:
        return AppColors.primary;
      case AppButtonVariant.destructive:
        return AppColors.onError;
    }
  }

  Widget _buildLoadingSpinner() {
    return SizedBox(
      width: _iconSize,
      height: _iconSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(_resolveTextColor()),
      ),
    );
  }

  Widget? _buildIcon() {
    if (loading) return _buildLoadingSpinner();
    if (!_hasIcon) return null;
    return Icon(icon, size: _iconSize, color: _resolveIconColor());
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _resolveBackgroundColor(context);
    final textColor = _resolveTextColor();

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _height,
      child: variant == AppButtonVariant.ghost || variant == AppButtonVariant.outline
          ? TextButton(
              onPressed: loading ? null : onPressed,
              style: TextButton.styleFrom(
                padding: _padding,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: textColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_borderRadius),
                  side: variant == AppButtonVariant.outline
                      ? BorderSide(color: _resolveBorderColor() ?? AppColors.outline, width: 1)
                      : BorderSide.none,
                ),
              ),
              child: _buildContent(textColor),
            )
          : ElevatedButton(
              onPressed: loading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: bgColor,
                foregroundColor: textColor,
                disabledBackgroundColor: bgColor.withValues(alpha: 0.6),
                disabledForegroundColor: textColor.withValues(alpha: 0.6),
                padding: _padding,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(_borderRadius),
                ),
              ),
              child: _buildContent(textColor),
            ),
    );
  }

  Widget _buildContent(Color textColor) {
    if (loading && !_hasIcon) {
      return _buildLoadingSpinner();
    }

    if (_hasIcon) {
      final iconWidget = _buildIcon()!;
      final labelWidget = Text(
        label,
        style: GoogleFonts.inter(
          fontSize: _fontSize,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      );

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPosition == AppButtonIconPosition.leading) ...[
            iconWidget,
            const SizedBox(width: 8),
          ],
          labelWidget,
          if (iconPosition == AppButtonIconPosition.trailing) ...[
            const SizedBox(width: 8),
            iconWidget,
          ],
        ],
      );
    }

    return Text(
      label,
      style: GoogleFonts.inter(
        fontSize: _fontSize,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }
}

enum AppButtonIconPosition { leading, trailing }
