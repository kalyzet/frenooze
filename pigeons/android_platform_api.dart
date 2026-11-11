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
}