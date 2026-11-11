import 'package:flutter/material.dart';

/// Color tokens for the Sleep Experience (dark, calm, low stimulation).
abstract final class SleepPalette {
  static const Color background = Color(0xFF101315);
  static const Color surface = Color(0xFF191F20);
  static const Color card = Color(0xFF222A29);
  static const Color primary = Color(0xFF91A9C9);
  static const Color secondary = Color(0xFF9CAF9A);
  static const Color text = Color(0xFFE8ECE8);
  static const Color muted = Color(0xFF89958E);
  static const Color border = Color(0xFF303A37);
}

/// Color tokens for the Wake Experience (bright, fresh, energizing).
abstract final class WakePalette {
  static const Color background = Color(0xFFF8F9F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFF4D8);
  static const Color primary = Color(0xFF70B9E8);
  static const Color secondary = Color(0xFFFFD36E);
  static const Color accent = Color(0xFFF5A66D);
  static const Color text = Color(0xFF293746);
  static const Color muted = Color(0xFF87939C);
  static const Color border = Color(0xFFE7EAE5);
}