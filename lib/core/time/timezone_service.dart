/// Timezone identity captured at a moment in time.
class TimezoneInfo {
  const TimezoneInfo({
    required this.ianaId,
    required this.offsetMinutes,
  });

  /// IANA identifier (e.g. `Asia/Makassar`).
  ///
  /// Falls back to `UTC` when the device does not expose a recognizable
  /// identifier. The application must never guess the user's region.
  final String ianaId;

  /// Current UTC offset in minutes (e.g. 480 for UTC+8).
  final int offsetMinutes;
}

/// Reads the current device timezone.
///
/// Phase 1 uses the Dart `DateTime` values as a safe fallback. Phase 2 replaces
/// the identifier source with the Kotlin platform API through Pigeon.
abstract interface class TimezoneService {
  TimezoneInfo current();
}

class SystemTimezoneService implements TimezoneService {
  const SystemTimezoneService();

  @override
  TimezoneInfo current() {
    final DateTime now = DateTime.now();
    final Duration offset = now.timeZoneOffset;
    final String name = now.timeZoneName;
    final bool looksLikeIana = name.contains('/');
    return TimezoneInfo(
      ianaId: looksLikeIana ? name : 'UTC',
      offsetMinutes: offset.inMinutes,
    );
  }
}