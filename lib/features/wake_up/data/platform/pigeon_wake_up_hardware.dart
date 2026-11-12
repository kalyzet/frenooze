import 'package:frenooze/core/platform/android_platform_api.g.dart';

import '../../domain/services/wake_up_hardware.dart';

/// Pigeon-backed [WakeUpHardware] (ARCHITECTURE §13.3).
class PigeonWakeUpHardware implements WakeUpHardware {
  PigeonWakeUpHardware(this._api);

  final AndroidPlatformApi _api;

  @override
  Future<void> startVibration() => _api.startVibration();

  @override
  Future<void> stopVibration() => _api.stopVibration();

  @override
  Future<void> keepScreenOn() => _api.keepScreenOn();

  @override
  Future<void> releaseScreenOn() => _api.releaseScreenOn();
}
