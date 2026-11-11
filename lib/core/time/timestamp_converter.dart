import 'package:timezone/timezone.dart' as tz;

/// Converts between absolute UTC timestamps and local wall-clock time for a
/// recorded IANA timezone.
abstract final class TimestampConverter {
  /// Returns the local wall-clock time for [utcMs] in [ianaId].
  ///
  /// Falls back to UTC when the identifier is not loaded in the timezone
  /// database; it never guesses a region.
  static DateTime toLocal(int utcMs, String ianaId) {
    final DateTime absolute = DateTime.fromMillisecondsSinceEpoch(
      utcMs,
      isUtc: true,
    );
    final tz.Location location = _resolve(ianaId);
    return tz.TZDateTime.from(absolute, location);
  }

  /// Converts a local wall-clock time in [ianaId] to a UTC timestamp.
  static int fromLocal(DateTime local, String ianaId) {
    final tz.Location location = _resolve(ianaId);
    final tz.TZDateTime zoned = tz.TZDateTime(
      location,
      local.year,
      local.month,
      local.day,
      local.hour,
      local.minute,
      local.second,
    );
    return zoned.toUtc().millisecondsSinceEpoch;
  }

  static tz.Location _resolve(String ianaId) {
    try {
      return tz.getLocation(ianaId);
    } on tz.LocationNotFoundException {
      return tz.UTC;
    }
  }
}