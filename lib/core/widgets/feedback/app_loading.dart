import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({
    super.key,
    this.size = 36,
    this.color,
    this.strokeWidth = 3,
  });

  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).colorScheme.primary,
        ),
      ),
    ).animate().fadeIn().scale();
  }
}