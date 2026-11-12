import 'package:flutter_test/flutter_test.dart';
import 'package:frenooze/features/sleep_session/domain/entities/sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/entities/time_accuracy.dart';
import 'package:frenooze/features/sleep_session/domain/services/duration_calculator.dart';

SleepSession _session({
  required DateTime startedAtUtc,
  DateTime? endedAtUtc,
  int startElapsedMs = 1000,
  int? endElapsedMs,
  int startBootCount = 1,
  int? endBootCount,
}) {
  return SleepSession(
    id: 's1',
    startedAtUtc: startedAtUtc,
    endedAtUtc: endedAtUtc,
    startTimezone: 'Asia/Jakarta',
    startOffsetMinutes: 420,
    startElapsedMs: startElapsedMs,
    endElapsedMs: endElapsedMs,
    startBootCount: startBootCount,
    endBootCount: endBootCount,
    createdAtUtc: startedAtUtc,
    updatedAtUtc: endedAtUtc ?? startedAtUtc,
  );
}

void main() {
  const DurationCalculator calculator = DurationCalculator();

  group('DurationCalculator.calculate', () {
    test('active session is invalid with zero duration', () {
      final SleepSession session = _session(
        startedAtUtc: DateTime.utc(2026, 1, 1, 22),
      );

      final SleepDuration result = calculator.calculate(session);

      expect(result.duration, Duration.zero);
      expect(result.accuracy, TimeAccuracy.invalid);
    });

    test('same-boot monotonic agrees with wall → ok', () {
      final DateTime start = DateTime.utc(2026, 1, 1, 22);
      final SleepSession session = _session(
        startedAtUtc: start,
        endedAtUtc: start.add(const Duration(hours: 8)),
        startElapsedMs: 5_000,
        endElapsedMs: 5_000 + 8 * 3600 * 1000,
        startBootCount: 3,
        endBootCount: 3,
      );

      final SleepDuration result = calculator.calculate(session);

      expect(result.duration, const Duration(hours: 8));
      expect(result.accuracy, TimeAccuracy.ok);
    });

    test('monotonic vs wall mismatch beyond tolerance → clockChanged', () {
      final DateTime start = DateTime.utc(2026, 1, 1, 22);
      // Wall says 7h; monotonic says 9h.
      final SleepSession session = _session(
        startedAtUtc: start,
        endedAtUtc: start.add(const Duration(hours: 7)),
        startElapsedMs: 0,
        endElapsedMs: 9 * 3600 * 1000,
        startBootCount: 1,
        endBootCount: 1,
      );

      final SleepDuration result = calculator.calculate(session);

      expect(result.duration, const Duration(hours: 9));
      expect(result.accuracy, TimeAccuracy.clockChanged);
    });

    test('negative monotonic delta → invalid', () {
      final DateTime start = DateTime.utc(2026, 1, 1, 22);
      final SleepSession session = _session(
        startedAtUtc: start,
        endedAtUtc: start.add(const Duration(hours: 8)),
        startElapsedMs: 100_000,
        endElapsedMs: 50_000,
        startBootCount: 1,
        endBootCount: 1,
      );

      final SleepDuration result = calculator.calculate(session);

      expect(result.accuracy, TimeAccuracy.invalid);
      expect(result.duration, Duration.zero);
    });

    test('reboot mid-session → bootChanged using wall clock', () {
      final DateTime start = DateTime.utc(2026, 1, 1, 22);
      final SleepSession session = _session(
        startedAtUtc: start,
        endedAtUtc: start.add(const Duration(hours: 6)),
        startElapsedMs: 1000,
        endElapsedMs: 2000,
        startBootCount: 1,
        endBootCount: 2,
      );

      final SleepDuration result = calculator.calculate(session);

      expect(result.duration, const Duration(hours: 6));
      expect(result.accuracy, TimeAccuracy.bootChanged);
    });

    test('wall-only end without monotonic → ok', () {
      final DateTime start = DateTime.utc(2026, 1, 1, 23);
      final SleepSession session = _session(
        startedAtUtc: start,
        endedAtUtc: start.add(const Duration(hours: 7, minutes: 30)),
        startElapsedMs: 10,
        endBootCount: null,
      );

      final SleepDuration result = calculator.calculate(session);

      expect(result.duration, const Duration(hours: 7, minutes: 30));
      expect(result.accuracy, TimeAccuracy.ok);
    });

    test('negative wall range without boot → invalid', () {
      final DateTime start = DateTime.utc(2026, 1, 2, 8);
      final SleepSession session = _session(
        startedAtUtc: start,
        endedAtUtc: start.subtract(const Duration(hours: 1)),
      );

      final SleepDuration result = calculator.calculate(session);

      expect(result.accuracy, TimeAccuracy.invalid);
    });
  });

  group('DurationCalculator.running', () {
    test('elapsed from start to now', () {
      final DateTime start = DateTime.utc(2026, 1, 1, 22);
      final SleepSession session = _session(startedAtUtc: start);

      final Duration elapsed = calculator.running(
        session,
        start.add(const Duration(hours: 2, minutes: 15)),
      );

      expect(elapsed, const Duration(hours: 2, minutes: 15));
    });

    test('now before start clamps to zero', () {
      final DateTime start = DateTime.utc(2026, 1, 1, 22);
      final SleepSession session = _session(startedAtUtc: start);

      final Duration elapsed = calculator.running(
        session,
        start.subtract(const Duration(minutes: 5)),
      );

      expect(elapsed, Duration.zero);
    });
  });
}
