import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.dense = false,
    this.enabled = true,
    this.divider = false,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool selected;
  final bool dense;
  final bool enabled;
  final bool divider;

  EdgeInsetsGeometry get _contentPadding {
    switch (dense) {
      case true:
        return const EdgeInsets.symmetric(horizontal: 16);
      case false:
        return const EdgeInsets.symmetric(horizontal: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        onLongPress: enabled ? onLongPress : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: _contentPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (leading != null) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: leading,
                ),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: dense ? 14 : 16,
                        fontWeight: FontWeight.w500,
                        color: enabled
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: GoogleFonts.inter(
                          fontSize: dense ? 12 : 14,
                          fontWeight: FontWeight.w400,
                          color: enabled
                              ? Theme.of(context).colorScheme.onSurfaceVariant
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: trailing,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}