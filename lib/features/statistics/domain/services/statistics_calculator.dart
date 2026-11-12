import 'dart:math' as math;

import '../../../sleep_session/domain/entities/sleep_session.dart';
import '../../../sleep_session/domain/entities/time_accuracy.dart';
import '../../../sleep_session/domain/services/duration_calculator.dart';
import '../entities/sleep_statistics.dart';
import '../entities/statistics_range.dart';

/// Pure aggregation of completed sleep sessions (PRD §4.8, ARCHITECTURE §5.5).
///
/// Rules enforced here:
/// - Only **completed** sessions (`endedAtUtc != null`).
/// - Sessions whose derived duration is invalid are excluded — never
///   counted as zero-duration sleep (PRD §4.8).
/// - A session that crosses midnight is counted once, under its **start**
///   local date (ARCHITECTURE §8.7).
/// - Day/week/month boundaries use each session's recorded start offset so
///   a timezone change never silently rewrites historical days.
class StatisticsCalculator {
  const StatisticsCalculator({this.calculator = const DurationCalculator()});

  final DurationCalculator calculator;

  /// Computes [SleepStatistics] for [range] relative to [nowUtc].
  SleepStatistics calculate({
    required List<SleepSession> sessions,
    required StatisticsRange range,
    required DateTime nowUtc,
  }) {
    final List<_ValidSession> valid = <_ValidSession>[];
    for (final SleepSession session in sessions) {
      final _ValidSession? item = _validate(session, nowUtc, range);
      if (item != null) {
        valid.add(item);
      }
    }

    if (valid.isEmpty) {
      return SleepStatistics(range: range);
    }

    Duration total = Duration.zero;
    Duration longest = valid.first.duration;
    Duration shortest = valid.first.duration;
    final List<int> sleepMinutes = <int>[];
    final List<int> wakeMinutes = <int>[];
    final Map<DateTime, DailySleepPoint> byDay = <DateTime, DailySleepPoint>{};

    for (final _ValidSession item in valid) {
      total += item.duration;
      if (item.duration > longest) {
        longest = item.duration;
      }
      if (item.duration < shortest) {
        shortest = item.duration;
      }
      sleepMinutes.add(item.sleepStartMinutes);
      if (item.wakeStartMinutes != null) {
        wakeMinutes.add(item.wakeStartMinutes!);
      }

      final DailySleepPoint? existing = byDay[item.localDate];
      if (existing == null) {
        byDay[item.localDate] = DailySleepPoint(
          localDate: item.localDate,
          duration: item.duration,
          sessionCount: 1,
        );
      } else {
        byDay[item.localDate] = DailySleepPoint(
          localDate: existing.localDate,
          duration: existing.duration + item.duration,
          sessionCount: existing.sessionCount + 1,
        );
      }
    }

    final List<DailySleepPoint> trend = byDay.values.toList()
      ..sort((DailySleepPoint a, DailySleepPoint b) =>
          a.localDate.compareTo(b.localDate));

    return SleepStatistics(
      range: range,
      sessionCount: valid.length,
      averageDuration: total ~/ valid.length,
      totalDuration: total,
      longestDuration: longest,
      shortestDuration: shortest,
      averageSleepTimeMinutes: _circularMeanMinutes(sleepMinutes),
      averageWakeTimeMinutes: wakeMinutes.isEmpty
          ? null
          : _circularMeanMinutes(wakeMinutes),
      dailyTrend: trend,
    );
  }

  _ValidSession? _validate(
    SleepSession session,
    DateTime nowUtc,
    StatisticsRange range,
  ) {
    if (session.isActive) {
      return null;
    }
    if (session.accuracy == TimeAccuracy.invalid) {
      return null;
    }

    final SleepDuration result = calculator.calculate(session);
    if (result.accuracy == TimeAccuracy.invalid || result.duration <= Duration.zero) {
      return null;
    }

    final DateTime startLocal = _toLocal(
      session.startedAtUtc,
      session.startOffsetMinutes,
    );
    final DateTime dateOnly = DateTime(
      startLocal.year,
      startLocal.month,
      startLocal.day,
    );

    if (range.days != null) {
      final DateTime nowLocal = _toLocal(nowUtc, session.startOffsetMinutes);
      final DateTime cutoff = DateTime(
        nowLocal.year,
        nowLocal.month,
        nowLocal.day,
      ).subtract(Duration(days: range.days! - 1));
      if (dateOnly.isBefore(cutoff)) {
        return null;
      }
    }

    final DateTime? ended = session.endedAtUtc;
    int? wakeMinutes;
    if (ended != null) {
      final DateTime endLocal = _toLocal(
        ended,
        session.endOffsetMinutes ?? session.startOffsetMinutes,
      );
      wakeMinutes = endLocal.hour * 60 + endLocal.minute;
    }

    return _ValidSession(
      localDate: dateOnly,
      duration: result.duration,
      sleepStartMinutes: startLocal.hour * 60 + startLocal.minute,
      wakeStartMinutes: wakeMinutes,
    );
  }

  static DateTime _toLocal(DateTime utc, int offsetMinutes) {
    return DateTime.fromMillisecondsSinceEpoch(
      utc.millisecondsSinceEpoch + offsetMinutes * 60000,
      isUtc: true,
    );
  }

  /// Circular mean of minutes-of-day so 23:00 and 01:00 average near
  /// midnight, not noon.
  static int? _circularMeanMinutes(List<int> minutes) {
    if (minutes.isEmpty) {
      return null;
    }
    double sumSin = 0;
    double sumCos = 0;
    for (final int m in minutes) {
      final double angle = 2 * math.pi * (m % (24 * 60)) / (24 * 60);
      sumSin += math.sin(angle);
      sumCos += math.cos(angle);
    }
    final double meanSin = sumSin / minutes.length;
    final double meanCos = sumCos / minutes.length;
    double angle = math.atan2(meanSin, meanCos);
    if (angle < 0) {
      angle += 2 * math.pi;
    }
    final int minutesOfDay =
        (angle / (2 * math.pi) * (24 * 60)).round() % (24 * 60);
    return minutesOfDay;
  }
}

class _ValidSession {
  const _ValidSession({
    required this.localDate,
    required this.duration,
    required this.sleepStartMinutes,
    required this.wakeStartMinutes,
  });

  final DateTime localDate;
  final Duration duration;
  final int sleepStartMinutes;
  final int? wakeStartMinutes;
}
