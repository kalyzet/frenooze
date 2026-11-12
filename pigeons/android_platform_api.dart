import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/core/platform/android_platform_api.g.dart',
    kotlinOut:
        'android/app/src/main/kotlin/com/kalyzet/frenooze/platform/AndroidPlatformApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.kalyzet.frenooze.platform'),
  ),
)
class DeviceTimezone {
  const DeviceTimezone({required this.ianaId, required this.offsetMinutes});

  final String ianaId;
  final int offsetMinutes;
}

@HostApi()
abstract class AndroidPlatformApi {
  DeviceTimezone getDeviceTimezone();

  int getElapsedRealtimeMs();

  int getBootCount();

  /// Starts the repeating wake-up vibration pattern (PRD §4.4.2).
  ///
  /// No-op when the device has no vibrator. The pattern runs until
  /// [stopVibration] or process death.
  void startVibration();

  /// Stops every active vibration sequence immediately.
  void stopVibration();

  /// Keeps the screen awake while Wake-up Mode is visible (PRD §4.4.3).
  void keepScreenOn();

  /// Releases the keep-screen-on flag.
  void releaseScreenOn();
}
