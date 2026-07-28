import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = 44,
    this.iconSize = 22,
    this.backgroundColor,
    this.iconColor,
    this.badgeCount = 0,
    this.showBadge = false,
    this.tooltip,
    this.borderWidth = 0,
    this.borderColor,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final int badgeCount;
  final bool showBadge;
  final String? tooltip;
  final double borderWidth;
  final Color? borderColor;

  bool get _hasBadge => showBadge || badgeCount > 0;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.surfaceContainerLow;
    final fgColor = iconColor ?? AppColors.onSurface;

    final Widget button = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: borderWidth > 0
            ? Border.all(
                color: borderColor ?? AppColors.outlineVariant,
                width: borderWidth,
              )
            : null,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize, color: fgColor),
        padding: EdgeInsets.zero,
        splashRadius: size / 2,
        constraints: const BoxConstraints(),
        tooltip: tooltip,
      ),
    );

    if (_hasBadge) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          button,
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  badgeCount > 99 ? '99+' : '$badgeCount',
                  style: const TextStyle(
                    color: AppColors.onError,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return button;
  }
}
