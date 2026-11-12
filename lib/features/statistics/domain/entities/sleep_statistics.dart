import 'package:equatable/equatable.dart';

import 'statistics_range.dart';

/// One aggregated day in the duration trend chart.
class DailySleepPoint extends Equatable {
  const DailySleepPoint({
    required this.localDate,
    required this.duration,
    required this.sessionCount,
  });

  /// Local calendar date of the sleep **start** (ARCHITECTURE §8.7).
  final DateTime localDate;

  /// Total sleep duration that started on [localDate].
  final Duration duration;

  /// Completed sessions contributing to [duration] (always ≥ 1).
  final int sessionCount;

  @override
  List<Object?> get props => <Object?>[localDate, duration, sessionCount];
}

/// Summary of completed sleep sessions for one [StatisticsRange]
/// (PRD §4.8). Null metrics mean "no data" — never zero-duration sleep.
class SleepStatistics extends Equatable {
  const SleepStatistics({
    required this.range,
    this.sessionCount = 0,
    this.averageDuration,
    this.totalDuration,
    this.longestDuration,
    this.shortestDuration,
    this.averageSleepTimeMinutes,
    this.averageWakeTimeMinutes,
    this.dailyTrend = const <DailySleepPoint>[],
  });

  final StatisticsRange range;

  /// Number of valid completed sessions in range.
  final int sessionCount;

  final Duration? averageDuration;
  final Duration? totalDuration;
  final Duration? longestDuration;
  final Duration? shortestDuration;

  /// Minutes since local midnight of the average sleep-start clock time.
  final int? averageSleepTimeMinutes;

  /// Minutes since local midnight of the average wake clock time.
  final int? averageWakeTimeMinutes;

  /// Day-by-day totals for the trend chart (only days with data).
  final List<DailySleepPoint> dailyTrend;

  bool get isEmpty => sessionCount == 0;

  /// Formats minutes-since-midnight as `HH:mm`; null stays null.
  String? get averageSleepTimeLabel => _formatMinutes(averageSleepTimeMinutes);

  String? get averageWakeTimeLabel => _formatMinutes(averageWakeTimeMinutes);

  static String? _formatMinutes(int? minutes) {
    if (minutes == null) {
      return null;
    }
    final int normalized = minutes % (24 * 60);
    final String hour = (normalized ~/ 60).toString().padLeft(2, '0');
    final String minute = (normalized % 60).toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  List<Object?> get props => <Object?>[
        range,
        sessionCount,
        averageDuration,
        totalDuration,
        longestDuration,
        shortestDuration,
        averageSleepTimeMinutes,
        averageWakeTimeMinutes,
        dailyTrend,
      ];
}
