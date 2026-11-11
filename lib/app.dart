import 'package:flutter/material.dart';

import 'core/routing/app_shell.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_controller.dart';

class FrenoozeApp extends StatelessWidget {
  const FrenoozeApp({super.key, required this.themeModeController});

  final ThemeModeController themeModeController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppDesignMode>(
      valueListenable: themeModeController,
      builder: (BuildContext context, AppDesignMode mode, Widget? child) {
        return MaterialApp(
          title: 'Frenooze',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.sleep(),
          home: const AppShell(),
        );
      },
    );
  }
}