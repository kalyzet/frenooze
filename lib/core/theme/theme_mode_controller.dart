import 'package:flutter/foundation.dart';

/// Design mode is derived from application state, never from device time.
///
/// Phase 1 only exposes the controller; later phases update it from the sleep
/// session / wake-up state machines.
enum AppDesignMode { sleep, wake }

/// Holds the current design mode for the whole application.
class ThemeModeController extends ValueNotifier<AppDesignMode> {
  ThemeModeController() : super(AppDesignMode.sleep);

  void useSleep() {
    if (value != AppDesignMode.sleep) {
      value = AppDesignMode.sleep;
    }
  }

  void useWake() {
    if (value != AppDesignMode.wake) {
      value = AppDesignMode.wake;
    }
  }
}