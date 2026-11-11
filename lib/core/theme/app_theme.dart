import 'package:flutter/material.dart';

import 'palettes.dart';

/// Typography scale from DESIGN.md §11.3.
abstract final class AppTypography {
  static const TextStyle display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );
  static const TextStyle body = TextStyle(fontSize: 16, height: 1.4);
  static const TextStyle secondary = TextStyle(fontSize: 14, height: 1.4);
  static const TextStyle caption = TextStyle(fontSize: 12, height: 1.35);
}

/// Spacing scale from DESIGN.md §11.5 (multiples of 4 dp).
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

/// Builds the two permanent app experiences.
///
/// The active theme is driven by application state, never by the clock.
abstract final class AppTheme {
  static ThemeData sleep() {
    const ColorScheme scheme = ColorScheme.dark(
      primary: SleepPalette.primary,
      onPrimary: SleepPalette.background,
      secondary: SleepPalette.secondary,
      onSecondary: SleepPalette.background,
      surface: SleepPalette.surface,
      onSurface: SleepPalette.text,
      outline: SleepPalette.border,
    );

    return _base(
      brightness: Brightness.dark,
      scheme: scheme,
      scaffoldBackground: SleepPalette.background,
      cardColor: SleepPalette.card,
      textColor: SleepPalette.text,
      mutedColor: SleepPalette.muted,
      borderColor: SleepPalette.border,
    );
  }

  static ThemeData wake() {
    const ColorScheme scheme = ColorScheme.light(
      primary: WakePalette.primary,
      onPrimary: WakePalette.surface,
      secondary: WakePalette.secondary,
      onSecondary: WakePalette.text,
      tertiary: WakePalette.accent,
      surface: WakePalette.surface,
      onSurface: WakePalette.text,
      outline: WakePalette.border,
    );

    return _base(
      brightness: Brightness.light,
      scheme: scheme,
      scaffoldBackground: WakePalette.background,
      cardColor: WakePalette.surface,
      textColor: WakePalette.text,
      mutedColor: WakePalette.muted,
      borderColor: WakePalette.border,
    );
  }

  static ThemeData _base({
    required Brightness brightness,
    required ColorScheme scheme,
    required Color scaffoldBackground,
    required Color cardColor,
    required Color textColor,
    required Color mutedColor,
    required Color borderColor,
  }) {
    final TextTheme textTheme = const TextTheme(
      displaySmall: AppTypography.display,
      headlineSmall: AppTypography.heading1,
      titleLarge: AppTypography.heading2,
      titleMedium: AppTypography.heading3,
      bodyLarge: AppTypography.body,
      bodyMedium: AppTypography.secondary,
      bodySmall: AppTypography.caption,
    ).apply(bodyColor: textColor, displayColor: textColor);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackground,
      canvasColor: scaffoldBackground,
      textTheme: textTheme,
      dividerColor: borderColor,
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: borderColor),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: scheme.primary,
        unselectedItemColor: mutedColor,
        type: BottomNavigationBarType.fixed,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      iconTheme: IconThemeData(color: textColor),
    );
  }
}