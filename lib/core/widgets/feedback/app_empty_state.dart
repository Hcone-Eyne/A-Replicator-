import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    this.title = 'No data',
    this.subtitle,
    this.icon,
    this.actions,
  });

  final String title;
  final String? subtitle;
  final Widget? icon;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (icon ??
                  const Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: AppColors.onSurfaceVariant,
                  ))
              .animate()
              .fadeIn()
              .scale(),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms),
          ],
          if (actions != null && actions!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Column(
              children: actions!
                  .map((action) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: action.animate().fadeIn(),
                      ))
                  .toList(),
            )
                .animate()
                .fadeIn(delay: 600.ms)
                .slide(begin: const Offset(0, 0.2)),
          ],
        ],
      ).animate().fadeIn(),
    );
  }
}