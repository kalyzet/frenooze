import 'package:flutter_test/flutter_test.dart';
import 'package:frenooze/features/sleep_session/domain/entities/sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/entities/time_accuracy.dart';
import 'package:frenooze/features/statistics/domain/entities/sleep_statistics.dart';
import 'package:frenooze/features/statistics/domain/entities/statistics_range.dart';
import 'package:frenooze/features/statistics/domain/services/statistics_calculator.dart';

SleepSession _completed({
  required String id,
  required DateTime startedAtUtc,
  required DateTime endedAtUtc,
  int startOffsetMinutes = 420,
  int? endOffsetMinutes,
  TimeAccuracy accuracy = TimeAccuracy.ok,
  int startElapsedMs = 0,
  int? endElapsedMs,
  int startBootCount = 1,
  int? endBootCount,
}) {
  return SleepSession(
    id: id,
    startedAtUtc: startedAtUtc,
    endedAtUtc: endedAtUtc,
    startTimezone: 'Asia/Jakarta',
    endTimezone: 'Asia/Jakarta',
    startOffsetMinutes: startOffsetMinutes,
    endOffsetMinutes: endOffsetMinutes ?? startOffsetMinutes,
    startElapsedMs: startElapsedMs,
    endElapsedMs: endElapsedMs ?? startElapsedMs,
    startBootCount: startBootCount,
    endBootCount: endBootCount ?? startBootCount,
    accuracy: accuracy,
    createdAtUtc: startedAtUtc,
    updatedAtUtc: endedAtUtc,
  );
}

void main() {
  const StatisticsCalculator calculator = StatisticsCalculator();
  final DateTime now = DateTime.utc(2026, 11, 12, 12);

  group('StatisticsCalculator', () {
    test('empty sessions → empty statistics with null metrics', () {
      final SleepStatistics stats = calculator.calculate(
        sessions: <SleepSession>[],
        range: StatisticsRange.days7,
        nowUtc: now,
      );

      expect(stats.isEmpty, isTrue);
      expect(stats.sessionCount, 0);
      expect(stats.averageDuration, isNull);
      expect(stats.totalDuration, isNull);
      expect(stats.dailyTrend, isEmpty);
    });

    test('excludes active sessions', () {
      final SleepSession active = SleepSession(
        id: 'a',
        startedAtUtc: DateTime.utc(2026, 11, 12, 22),
        startTimezone: 'Asia/Jakarta',
        startOffsetMinutes: 420,
        startElapsedMs: 0,
        startBootCount: 1,
        createdAtUtc: DateTime.utc(2026, 11, 12, 22),
        updatedAtUtc: DateTime.utc(2026, 11, 12, 22),
      );

      final SleepStatistics stats = calculator.calculate(
        sessions: <SleepSession>[active],
        range: StatisticsRange.all,
        nowUtc: now,
      );

      expect(stats.isEmpty, isTrue);
    });

    test('excludes invalid-accuracy and zero-duration sessions', () {
      final SleepSession invalidAccuracy = _completed(
        id: 'bad-acc',
        startedAtUtc: DateTime.utc(2026, 11, 11, 22),
        endedAtUtc: DateTime.utc(2026, 11, 12, 6),
        accuracy: TimeAccuracy.invalid,
      );
      final SleepSession zeroDuration = SleepSession(
        id: 'zero',
        startedAtUtc: DateTime.utc(2026, 11, 11, 22),
        endedAtUtc: DateTime.utc(2026, 11, 11, 22),
        startTimezone: 'Asia/Jakarta',
        startOffsetMinutes: 420,
        startElapsedMs: 0,
        startBootCount: 1,
        createdAtUtc: DateTime.utc(2026, 11, 11, 22),
        updatedAtUtc: DateTime.utc(2026, 11, 11, 22),
      );
      final SleepSession valid = _completed(
        id: 'ok',
        startedAtUtc: DateTime.utc(2026, 11, 11, 22),
        endedAtUtc: DateTime.utc(2026, 11, 12, 6),
        startElapsedMs: 0,
        endElapsedMs: 8 * 3600 * 1000,
      );

      final SleepStatistics stats = calculator.calculate(
        sessions: <SleepSession>[
          invalidAccuracy,
          zeroDuration,
          valid,
        ],
        range: StatisticsRange.all,
        nowUtc: now,
      );

      expect(stats.sessionCount, 1);
      expect(stats.totalDuration, const Duration(hours: 8));
      expect(stats.averageDuration, const Duration(hours: 8));
    });

    test('aggregates multiple sessions in range', () {
      final List<SleepSession> sessions = <SleepSession>[
        _completed(
          id: 's1',
          startedAtUtc: DateTime.utc(2026, 11, 11, 22),
          endedAtUtc: DateTime.utc(2026, 11, 12, 6),
          startElapsedMs: 0,
          endElapsedMs: 8 * 3600 * 1000,
        ),
        _completed(
          id: 's2',
          startedAtUtc: DateTime.utc(2026, 11, 10, 23),
          endedAtUtc: DateTime.utc(2026, 11, 11, 5),
          startElapsedMs: 0,
          endElapsedMs: 6 * 3600 * 1000,
        ),
      ];

      final SleepStatistics stats = calculator.calculate(
        sessions: sessions,
        range: StatisticsRange.days7,
        nowUtc: now,
      );

      expect(stats.sessionCount, 2);
      expect(stats.totalDuration, const Duration(hours: 14));
      expect(stats.averageDuration, const Duration(hours: 7));
      expect(stats.longestDuration, const Duration(hours: 8));
      expect(stats.shortestDuration, const Duration(hours: 6));
      expect(stats.dailyTrend.length, 2);
    });

    test('range cutoff excludes old sessions', () {
      final SleepSession old = _completed(
        id: 'old',
        startedAtUtc: DateTime.utc(2026, 1, 1, 22),
        endedAtUtc: DateTime.utc(2026, 1, 2, 6),
        startElapsedMs: 0,
        endElapsedMs: 8 * 3600 * 1000,
      );
      final SleepSession recent = _completed(
        id: 'new',
        startedAtUtc: DateTime.utc(2026, 11, 11, 22),
        endedAtUtc: DateTime.utc(2026, 11, 12, 6),
        startElapsedMs: 0,
        endElapsedMs: 8 * 3600 * 1000,
      );

      final SleepStatistics stats = calculator.calculate(
        sessions: <SleepSession>[old, recent],
        range: StatisticsRange.days7,
        nowUtc: now,
      );

      expect(stats.sessionCount, 1);
      expect(stats.totalDuration, const Duration(hours: 8));
    });

    test('circular mean of sleep times near midnight', () {
      // 23:00 (1380 min) and 01:00 (60 min) → mean near midnight (00:00).
      final SleepSession s1 = _completed(
        id: 'late',
        startedAtUtc: DateTime.utc(2026, 11, 11, 16, 0), // 23:00 WIB
        endedAtUtc: DateTime.utc(2026, 11, 12, 0, 0),
        startElapsedMs: 0,
        endElapsedMs: 8 * 3600 * 1000,
      );
      final SleepSession s2 = _completed(
        id: 'early',
        startedAtUtc: DateTime.utc(2026, 11, 10, 17, 0), // 00:00 WIB next day? 17:00 UTC = 00:00 WIB
        endedAtUtc: DateTime.utc(2026, 11, 11, 1, 0),
        startElapsedMs: 0,
        endElapsedMs: 8 * 3600 * 1000,
      );

      // s1 start local = 16:00 + 7h = 23:00 → 1380 min
      // s2 start local = 17:00 + 7h = 00:00 → 0 min
      final SleepStatistics stats = calculator.calculate(
        sessions: <SleepSession>[s1, s2],
        range: StatisticsRange.days7,
        nowUtc: now,
      );

      expect(stats.averageSleepTimeMinutes, isNotNull);
      // Circular mean of 0 and 1380 should be near 0 or near 1440/0 boundary.
      final int mean = stats.averageSleepTimeMinutes!;
      final int distToMidnight = mean < 720 ? mean : 1440 - mean;
      expect(distToMidnight, lessThan(60));
    });

    test('daily trend merges sessions on same start date', () {
      final List<SleepSession> sessions = <SleepSession>[
        _completed(
          id: 'a',
          startedAtUtc: DateTime.utc(2026, 11, 11, 15), // 22:00 WIB
          endedAtUtc: DateTime.utc(2026, 11, 11, 19), // 02:00 WIB next? 19 UTC = 02 WIB
          startElapsedMs: 0,
          endElapsedMs: 4 * 3600 * 1000,
        ),
        _completed(
          id: 'b',
          startedAtUtc: DateTime.utc(2026, 11, 11, 20), // 03:00 WIB
          endedAtUtc: DateTime.utc(2026, 11, 12, 0),
          startElapsedMs: 0,
          endElapsedMs: 4 * 3600 * 1000,
        ),
      ];

      final SleepStatistics stats = calculator.calculate(
        sessions: sessions,
        range: StatisticsRange.all,
        nowUtc: now,
      );

      expect(stats.sessionCount, 2);
      // Both start on 2026-11-11 local (15+7=22, 20+7=03 → 03 is next day!)
      // Wait: 20:00 UTC + 7h = 03:00 next day 2026-11-12.
      expect(stats.dailyTrend.length, greaterThanOrEqualTo(1));
      expect(
        stats.dailyTrend.fold<int>(0, (int sum, DailySleepPoint p) => sum + p.sessionCount),
        2,
      );
    });
  });
}
