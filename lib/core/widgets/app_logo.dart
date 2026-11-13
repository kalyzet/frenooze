import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Application logo shown at the top-left of page headers.
///
/// The source PNG has a transparent background, so it renders on a static
/// background color instead of the asset being modified.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 32});

  /// Edge length of the logo chip in logical pixels.
  final double size;

  /// Static background behind the transparent logo PNG.
  static const Color backgroundColor = Color(0xFFE5E5E1);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ColoredBox(
        color: backgroundColor,
        child: SizedBox(
          width: size,
          height: size,
          child: Image.asset(
            'doksli/icons/icon.png',
            fit: BoxFit.cover,
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) =>
                    const Icon(Icons.nightlight_round),
          ),
        ),
      ),
    );
  }
}

/// AppBar title combining the [AppLogo] with the page title text.
class LogoTitle extends StatelessWidget {
  const LogoTitle(this.title, {super.key, this.logoSize = 28});

  final String title;
  final double logoSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AppLogo(size: logoSize),
        const SizedBox(width: AppSpacing.sm),
        Text(title),
      ],
    );
  }
}
