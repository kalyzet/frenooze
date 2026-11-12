import '../../../sleep_session/domain/entities/sleep_session.dart';
import '../../../sleep_session/domain/services/duration_calculator.dart';

/// Serializes sessions to CSV for external analysis (ARCHITECTURE §14.2).
///
/// CSV is export-only in the MVP (PRD §4.10); there is no CSV restore path.
class BackupCsvCodec {
  const BackupCsvCodec({this.durationCalculator = const DurationCalculator()});

  final DurationCalculator durationCalculator;

  static const List<String> headers = <String>[
    'id',
    'started_at',
    'ended_at',
    'start_timezone',
    'end_timezone',
    'duration_seconds',
    'is_start_manual',
    'is_end_manual',
  ];

  String encode(List<SleepSession> sessions) {
    final StringBuffer buffer = StringBuffer()
      ..writeln(headers.join(','));

    for (final SleepSession session in sessions) {
      final String endedAt = session.endedAtUtc?.toIso8601String() ?? '';
      final String durationSeconds;
      if (session.isActive) {
        durationSeconds = '';
      } else {
        durationSeconds = durationCalculator
            .calculate(session)
            .duration
            .inSeconds
            .toString();
      }

      buffer.writeln(
        <String>[
          _escape(session.id),
          _escape(session.startedAtUtc.toIso8601String()),
          _escape(endedAt),
          _escape(session.startTimezone),
          _escape(session.endTimezone ?? ''),
          durationSeconds,
          session.isStartManual.toString(),
          session.isEndManual.toString(),
        ].join(','),
      );
    }

    return buffer.toString();
  }

  /// RFC 4180-style quoting when a field contains comma, quote, or newline.
  String _escape(String field) {
    if (!field.contains(',') &&
        !field.contains('"') &&
        !field.contains('\n') &&
        !field.contains('\r')) {
      return field;
    }
    return '"${field.replaceAll('"', '""')}"';
  }
}
