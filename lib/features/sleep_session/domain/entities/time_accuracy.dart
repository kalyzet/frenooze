/// Reliability marker for a recorded sleep session (PRD §4.7.3).
///
/// Persisted in the `time_accuracy_status` column. The value describes how
/// trustworthy the derived duration is, never the duration itself.
enum TimeAccuracy {
  /// Both wall clock and monotonic clock agree; boot did not change.
  ok('ok'),

  /// The wall clock and the monotonic clock disagree by more than the
  /// tolerance; the device clock was likely changed manually.
  clockChanged('clockChanged'),

  /// The device rebooted during the session, so only the wall clock can be
  /// used across the boundary.
  bootChanged('bootChanged'),

  /// The recorded timestamps are inconsistent; the session must not be used
  /// for statistics.
  invalid('invalid'),

  /// A timestamp was edited manually by the user.
  manual('manual');

  const TimeAccuracy(this.dbValue);

  /// Value stored in SQLite.
  final String dbValue;

  /// Parses a stored value; unknown values fall back to [TimeAccuracy.ok]
  /// so a future schema revision never crashes the reader.
  static TimeAccuracy fromDb(String value) {
    for (final TimeAccuracy accuracy in TimeAccuracy.values) {
      if (accuracy.dbValue == value) {
        return accuracy;
      }
    }
    return TimeAccuracy.ok;
  }
}
