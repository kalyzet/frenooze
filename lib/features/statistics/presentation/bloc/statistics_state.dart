import 'package:equatable/equatable.dart';

import '../../domain/entities/sleep_statistics.dart';
import '../../domain/entities/statistics_range.dart';

/// States of the statistics screen (ARCHITECTURE §6.4).
sealed class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object?> get props => <Object?>[];
}

final class StatisticsInitial extends StatisticsState {
  const StatisticsInitial();
}

/// Aggregation is running for the active [range].
final class StatisticsLoading extends StatisticsState {
  const StatisticsLoading(this.range);

  final StatisticsRange range;

  @override
  List<Object?> get props => <Object?>[range];
}

/// Summary ready for display.
final class StatisticsLoaded extends StatisticsState {
  const StatisticsLoaded(this.statistics);

  final SleepStatistics statistics;

  StatisticsRange get range => statistics.range;

  @override
  List<Object?> get props => <Object?>[statistics];
}

/// Load failed; [message] is user-facing.
final class StatisticsFailure extends StatisticsState {
  const StatisticsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
