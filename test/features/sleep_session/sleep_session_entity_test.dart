import 'package:flutter_test/flutter_test.dart';
import 'package:frenooze/features/sleep_session/domain/entities/sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/entities/time_accuracy.dart';

void main() {
  test('isActive is true only when endedAtUtc is null', () {
    final SleepSession active = SleepSession(
      id: 'a',
      startedAtUtc: DateTime.utc(2026),
      startTimezone: 'UTC',
      startOffsetMinutes: 0,
      startElapsedMs: 0,
      startBootCount: 1,
      createdAtUtc: DateTime.utc(2026),
      updatedAtUtc: DateTime.utc(2026),
    );
    final SleepSession done = SleepSession(
      id: 'b',
      startedAtUtc: DateTime.utc(2026),
      endedAtUtc: DateTime.utc(2026, 1, 1, 8),
      startTimezone: 'UTC',
      startOffsetMinutes: 0,
      startElapsedMs: 0,
      startBootCount: 1,
      accuracy: TimeAccuracy.ok,
      createdAtUtc: DateTime.utc(2026),
      updatedAtUtc: DateTime.utc(2026, 1, 1, 8),
    );

    expect(active.isActive, isTrue);
    expect(done.isActive, isFalse);
  });

  test('equality uses all props', () {
    final DateTime start = DateTime.utc(2026, 1, 1);
    final SleepSession a = SleepSession(
      id: 'x',
      startedAtUtc: start,
      endedAtUtc: start.add(const Duration(hours: 8)),
      startTimezone: 'UTC',
      startOffsetMinutes: 0,
      startElapsedMs: 0,
      startBootCount: 1,
      createdAtUtc: start,
      updatedAtUtc: start,
    );
    final SleepSession b = SleepSession(
      id: 'x',
      startedAtUtc: start,
      endedAtUtc: start.add(const Duration(hours: 8)),
      startTimezone: 'UTC',
      startOffsetMinutes: 0,
      startElapsedMs: 0,
      startBootCount: 1,
      createdAtUtc: start,
      updatedAtUtc: start,
    );
    final SleepSession c = SleepSession(
      id: 'y',
      startedAtUtc: start,
      endedAtUtc: start.add(const Duration(hours: 8)),
      startTimezone: 'UTC',
      startOffsetMinutes: 0,
      startElapsedMs: 0,
      startBootCount: 1,
      createdAtUtc: start,
      updatedAtUtc: start,
    );

    expect(a, equals(b));
    expect(a, isNot(equals(c)));
  });
}
