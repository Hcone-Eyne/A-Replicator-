import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class AppSnackbar {
  AppSnackbar._();

  static void show(
    BuildContext context,
    String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
    SnackBarBehavior? behavior,
    bool dismissDirection = true,
  }) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: AppColors.surfaceContainerHighest,
            behavior: behavior ?? SnackBarBehavior.fixed,
            action: action,
            dismissDirection: dismissDirection
                ? DismissDirection.horizontal
                : DismissDirection.none,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
  }
}