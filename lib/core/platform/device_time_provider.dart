/// Device time snapshot captured through the Android platform channel.
class DeviceTimeSnapshot {
  const DeviceTimeSnapshot({
    required this.utcNow,
    required this.timezoneIanaId,
    required this.offsetMinutes,
    required this.elapsedRealtimeMs,
    required this.bootCount,
  });

  final DateTime utcNow;
  final String timezoneIanaId;
  final int offsetMinutes;
  final int elapsedRealtimeMs;
  final int bootCount;
}

/// Abstraction over the Android platform channel so use cases can be tested
/// with a fake implementation.
abstract interface class DeviceTimeProvider {
  Future<DeviceTimeSnapshot> capture();
}