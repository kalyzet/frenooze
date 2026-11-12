/// Hardware side of Wake-up Mode: vibration and screen keep-on
/// (PRD §4.4.2–4.4.3).
///
/// Domain use cases depend on this abstraction; the platform implementation
/// bridges to the Android vibrator and window flags through Pigeon.
abstract interface class WakeUpHardware {
  /// Starts the repeating vibration pattern; no-op without a vibrator.
  Future<void> startVibration();

  /// Stops every active vibration sequence immediately.
  Future<void> stopVibration();

  /// Keeps the screen awake while the mode is visible.
  Future<void> keepScreenOn();

  /// Releases the keep-screen-on flag.
  Future<void> releaseScreenOn();
}
