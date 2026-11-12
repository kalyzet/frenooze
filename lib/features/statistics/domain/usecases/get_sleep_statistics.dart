import 'package:frenooze/core/time/clock_provider.dart';

import '../../../sleep_session/domain/repositories/sleep_session_repository.dart';
import '../entities/sleep_statistics.dart';
import '../entities/statistics_range.dart';
import '../services/statistics_calculator.dart';

/// Loads completed sessions and aggregates them for one [StatisticsRange]
/// (PRD §4.8).
class GetSleepStatistics {
  GetSleepStatistics({
    required this.repository,
    this.calculator = const StatisticsCalculator(),
    this.clock = const SystemClockProvider(),
  });

  final SleepSessionRepository repository;
  final StatisticsCalculator calculator;
  final ClockProvider clock;

  Future<SleepStatistics> call(StatisticsRange range) async {
    final sessions = await repository.getAll();
    return calculator.calculate(
      sessions: sessions,
      range: range,
      nowUtc: clock.nowUtc(),
    );
  }
}
