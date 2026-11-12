import 'package:equatable/equatable.dart';

import '../../domain/entities/statistics_range.dart';

/// Events for [StatisticsBloc] (ARCHITECTURE §6.4).
sealed class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads statistics for [range] (defaults handled by the bloc).
final class LoadStatisticsRequested extends StatisticsEvent {
  const LoadStatisticsRequested({this.range = StatisticsRange.days7});

  final StatisticsRange range;

  @override
  List<Object?> get props => <Object?>[range];
}

/// Recomputes with a newly selected period (DESIGN §8.3).
final class ChangeRangeRequested extends StatisticsEvent {
  const ChangeRangeRequested(this.range);

  final StatisticsRange range;

  @override
  List<Object?> get props => <Object?>[range];
}

/// Reloads after sleep data changed (session saved / deleted / edited).
final class RefreshStatisticsRequested extends StatisticsEvent {
  const RefreshStatisticsRequested();
}
