import 'package:frenooze/core/platform/android_platform_api.g.dart';
import 'package:frenooze/core/platform/device_time_provider.dart';
import 'package:frenooze/core/time/clock_provider.dart';

class AndroidDeviceTimeProvider implements DeviceTimeProvider {
  AndroidDeviceTimeProvider(this._api, {ClockProvider? clock})
      : _clock = clock ?? const SystemClockProvider();

  final AndroidPlatformApi _api;
  final ClockProvider _clock;

  @override
  Future<DeviceTimeSnapshot> capture() async {
    final DeviceTimezone timezone = await _api.getDeviceTimezone();
    final int elapsed = await _api.getElapsedRealtimeMs();
    final int boot = await _api.getBootCount();
    return DeviceTimeSnapshot(
      utcNow: _clock.nowUtc(),
      timezoneIanaId: timezone.ianaId,
      offsetMinutes: timezone.offsetMinutes,
      elapsedRealtimeMs: elapsed,
      bootCount: boot,
    );
  }
}