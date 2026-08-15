import 'package:flutter/material.dart';

// Placeholder tokens — real visual direction is a later phase (see claude/roadmap.md Phase 5).
// Kept centralized here so the eventual design pass has one place to change, not a hunt
// through every screen for hardcoded colors.
class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.teal,
        brightness: Brightness.dark,
      ),
    );
  }
}
