import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routing/app_shell.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_controller.dart';
import 'features/sleep_session/presentation/bloc/sleep_session_bloc.dart';

class FrenoozeApp extends StatelessWidget {
  const FrenoozeApp({
    super.key,
    required this.themeModeController,
    required this.sleepSessionBloc,
  });

  final ThemeModeController themeModeController;
  final SleepSessionBloc sleepSessionBloc;

  /// The design mode follows application state, never the clock
  /// (DESIGN §3): sleeping is the Sleep Experience, a finished session
  /// switches to the Wake Experience until the next session starts.
  void _syncTheme(SleepSessionState state) {
    if (state is SleepSessionSleeping ||
        state is SleepSessionReadyToSleep ||
        state is SleepSessionCompleting) {
      themeModeController.useSleep();
    } else if (state is SleepSessionSuccess && state.completed != null) {
      themeModeController.useWake();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SleepSessionBloc>.value(
      value: sleepSessionBloc,
      child: BlocListener<SleepSessionBloc, SleepSessionState>(
        listener: (BuildContext context, SleepSessionState state) =>
            _syncTheme(state),
        child: ValueListenableBuilder<AppDesignMode>(
          valueListenable: themeModeController,
          builder: (BuildContext context, AppDesignMode mode, Widget? child) {
            return MaterialApp(
              title: 'Frenooze',
              debugShowCheckedModeBanner: false,
              theme: mode == AppDesignMode.sleep
                  ? AppTheme.sleep()
                  : AppTheme.wake(),
              home: const AppShell(),
            );
          },
        ),
      ),
    );
  }
}
