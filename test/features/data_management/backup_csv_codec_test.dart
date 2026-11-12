import 'package:flutter_test/flutter_test.dart';
import 'package:frenooze/features/data_management/domain/services/backup_csv_codec.dart';
import 'package:frenooze/features/sleep_session/domain/entities/sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/entities/time_accuracy.dart';

void main() {
  const BackupCsvCodec codec = BackupCsvCodec();

  test('writes header and one row', () {
    final SleepSession session = SleepSession(
      id: 's1',
      startedAtUtc: DateTime.utc(2026, 11, 11, 15),
      endedAtUtc: DateTime.utc(2026, 11, 11, 23),
      startTimezone: 'Asia/Jakarta',
      endTimezone: 'Asia/Jakarta',
      startOffsetMinutes: 420,
      endOffsetMinutes: 420,
      startElapsedMs: 0,
      endElapsedMs: 8 * 3600 * 1000,
      startBootCount: 1,
      endBootCount: 1,
      accuracy: TimeAccuracy.ok,
      createdAtUtc: DateTime.utc(2026, 11, 11, 15),
      updatedAtUtc: DateTime.utc(2026, 11, 11, 23),
    );

    final String csv = codec.encode(<SleepSession>[session]);
    final List<String> lines =
        csv.split('\n').where((String l) => l.trim().isNotEmpty).toList();

    expect(lines, hasLength(2));
    expect(lines[0], contains('duration_seconds'));
    expect(lines[1], contains('s1'));
    expect(lines[1], contains('28800')); // 8h in seconds
  });

  test('active session has empty duration and ended_at', () {
    final SleepSession active = SleepSession(
      id: 'act',
      startedAtUtc: DateTime.utc(2026, 11, 11, 15),
      startTimezone: 'Asia/Jakarta',
      startOffsetMinutes: 420,
      startElapsedMs: 0,
      startBootCount: 1,
      createdAtUtc: DateTime.utc(2026, 11, 11, 15),
      updatedAtUtc: DateTime.utc(2026, 11, 11, 15),
    );

    final String csv = codec.encode(<SleepSession>[active]);
    final String row = csv.split('\n')[1];
    final List<String> cols = row.split(',');

    // id, started_at, ended_at, start_tz, end_tz, duration, start_manual, end_manual
    expect(cols[2], isEmpty);
    expect(cols[5], isEmpty);
  });
}
