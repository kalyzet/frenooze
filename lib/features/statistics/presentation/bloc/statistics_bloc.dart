import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/statistics_range.dart';
import '../../domain/usecases/get_sleep_statistics.dart';
import 'statistics_event.dart';
import 'statistics_state.dart';

export 'statistics_event.dart';
export 'statistics_state.dart';

/// Load / period / refresh for the statistics screen
/// (ARCHITECTURE §5.5, §6.4).
class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  StatisticsBloc({required GetSleepStatistics getSleepStatistics})
      : _getSleepStatistics = getSleepStatistics,
        super(const StatisticsInitial()) {
    on<LoadStatisticsRequested>(_onLoad);
    on<ChangeRangeRequested>(_onChangeRange);
    on<RefreshStatisticsRequested>(_onRefresh);
  }

  final GetSleepStatistics _getSleepStatistics;

  StatisticsRange _range = StatisticsRange.days7;

  Future<void> _onLoad(
    LoadStatisticsRequested event,
    Emitter<StatisticsState> emit,
  ) async {
    _range = event.range;
    await _compute(emit);
  }

  Future<void> _onChangeRange(
    ChangeRangeRequested event,
    Emitter<StatisticsState> emit,
  ) async {
    _range = event.range;
    await _compute(emit);
  }

  Future<void> _onRefresh(
    RefreshStatisticsRequested event,
    Emitter<StatisticsState> emit,
  ) async {
    await _compute(emit);
  }

  Future<void> _compute(Emitter<StatisticsState> emit) async {
    emit(StatisticsLoading(_range));
    try {
      final statistics = await _getSleepStatistics(_range);
      emit(StatisticsLoaded(statistics));
    } on Exception {
      emit(
        const StatisticsFailure('Gagal memuat statistik. Coba lagi.'),
      );
    }
  }
}
