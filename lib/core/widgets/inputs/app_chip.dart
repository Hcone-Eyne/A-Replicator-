import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
    this.variant = AppChipVariant.surface,
    this.shape = AppChipShape.pill,
    this.avatar,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final AppChipVariant variant;
  final AppChipShape shape;
  final Widget? avatar;

  double get _height => 36;
  double get _padding => shape == AppChipShape.pill ? 12 : 8;
  double get _borderRadius => shape == AppChipShape.pill ? 20 : 8;

  Color _resolveBackgroundColor(BuildContext context) {
    if (selected) {
      return variant == AppChipVariant.surface
          ? Theme.of(context).colorScheme.primaryContainer
          : AppColors.primary;
    }
    return Theme.of(context).colorScheme.surfaceContainer;
  }

  Color _resolveTextColor(BuildContext context) {
    if (selected) {
      return variant == AppChipVariant.surface
          ? Theme.of(context).colorScheme.onPrimaryContainer
          : Theme.of(context).colorScheme.onPrimary;
    }
    return Theme.of(context).colorScheme.onSurface;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected != null ? () => onSelected!(!selected) : null,
      child: Container(
        height: _height,
        padding: EdgeInsets.symmetric(horizontal: _padding),
        decoration: BoxDecoration(
          color: _resolveBackgroundColor(context),
          borderRadius: BorderRadius.circular(_borderRadius),
          border: shape == AppChipShape.filled
              ? Border.all(color: AppColors.outlineVariant)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (avatar != null) ...[
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: avatar,
              ),
            ],
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: _resolveTextColor(context),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum AppChipVariant { surface, primary }

enum AppChipShape { pill, filled }