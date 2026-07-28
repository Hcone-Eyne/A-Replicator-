import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme.dart';
import 'dark_theme.dart';

final themeProvider = StateProvider<ThemeData>((ref) => AppTheme.light);

final isDarkModeProvider = StateProvider<bool>((ref) {
  final theme = ref.watch(themeProvider);
  return theme.brightness == Brightness.dark;
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(AppTheme.light);

  void toggleTheme() {
    state = state.brightness == Brightness.dark ? AppTheme.light : DarkTheme.dark;
  }

  void setDarkMode(bool isDark) {
    state = isDark ? DarkTheme.dark : AppTheme.light;
  }
}

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});