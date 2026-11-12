import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/routing/app_shell.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_controller.dart';
import 'features/sleep_session/presentation/bloc/sleep_session_bloc.dart';
import 'features/wake_up/presentation/bloc/wake_up_bloc.dart';
import 'features/wake_up/presentation/pages/wake_up_page.dart';

class FrenoozeApp extends StatelessWidget {
  const FrenoozeApp({
    super.key,
    required this.themeModeController,
    required this.sleepSessionBloc,
    required this.wakeUpBloc,
  });

  final ThemeModeController themeModeController;
  final SleepSessionBloc sleepSessionBloc;
  final WakeUpBloc wakeUpBloc;

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

  /// Coordinates the two blocs without coupling them (ARCHITECTURE §6.6):
  /// once the session is safely stored, activate Wake-up Mode. A wake-up
  /// failure therefore never risks the saved session.
  void _onSleepSessionState(
    BuildContext context,
    SleepSessionState state,
  ) {
    _syncTheme(state);
    if (state is SleepSessionSuccess && state.completed != null) {
      context
          .read<WakeUpBloc>()
          .add(ActivateWakeUpRequested(state.completed!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SleepSessionBloc>.value(
      value: sleepSessionBloc,
      child: BlocProvider<WakeUpBloc>.value(
        value: wakeUpBloc,
        child: MultiBlocListener(
          listeners: <BlocListener<dynamic, dynamic>>[
            BlocListener<SleepSessionBloc, SleepSessionState>(
              listener: _onSleepSessionState,
            ),
            // Failures surface here because the Wake-up page is not mounted
            // in the Failure state (only Activating/Active/Closing show it).
            BlocListener<WakeUpBloc, WakeUpState>(
              listener: (BuildContext context, WakeUpState state) {
                if (state is WakeUpFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
            ),
          ],
          child: ValueListenableBuilder<AppDesignMode>(
            valueListenable: themeModeController,
            builder: (BuildContext context, AppDesignMode mode, Widget? child) {
              return MaterialApp(
                title: 'Frenooze',
                debugShowCheckedModeBanner: false,
                theme: mode == AppDesignMode.sleep
                    ? AppTheme.sleep()
                    : AppTheme.wake(),
                home: Stack(
                  children: <Widget>[
                    const AppShell(),
                    // Full-screen overlay above the shell so the bottom
                    // navigation cannot dismiss the mode by accident
                    // (PRD §4.4.3).
                    BlocBuilder<WakeUpBloc, WakeUpState>(
                      builder: (BuildContext context, WakeUpState state) {
                        final bool visible = state is WakeUpActivating ||
                            state is WakeUpActive ||
                            state is WakeUpClosing;
                        if (!visible) {
                          return const SizedBox.shrink();
                        }
                        return const Positioned.fill(
                          child: WakeUpPage(),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
