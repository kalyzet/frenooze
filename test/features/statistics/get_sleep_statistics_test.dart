import 'package:flutter_test/flutter_test.dart';
import 'package:frenooze/features/sleep_session/domain/entities/sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/entities/time_accuracy.dart';
import 'package:frenooze/features/sleep_session/domain/repositories/sleep_session_repository.dart';
import 'package:frenooze/features/statistics/domain/entities/statistics_range.dart';
import 'package:frenooze/features/statistics/domain/usecases/get_sleep_statistics.dart';

class _Repo implements SleepSessionRepository {
  _Repo(this._sessions);

  final List<SleepSession> _sessions;

  @override
  Future<SleepSession?> getActiveSession() async => null;

  @override
  Future<SleepSession?> getById(String id) async => null;

  @override
  Future<List<SleepSession>> getAll() async => _sessions;

  @override
  Future<void> insert(SleepSession session) async {}

  @override
  Future<void> update(SleepSession session) async {}

  @override
  Future<void> delete(String id) async {}
}

void main() {
  test('GetSleepStatistics aggregates from repository', () async {
    final DateTime start = DateTime.utc(2026, 11, 11, 15);
    final SleepSession session = SleepSession(
      id: 's1',
      startedAtUtc: start,
      endedAtUtc: start.add(const Duration(hours: 7)),
      startTimezone: 'Asia/Jakarta',
      startOffsetMinutes: 420,
      endOffsetMinutes: 420,
      startElapsedMs: 0,
      endElapsedMs: 7 * 3600 * 1000,
      startBootCount: 1,
      endBootCount: 1,
      accuracy: TimeAccuracy.ok,
      createdAtUtc: start,
      updatedAtUtc: start.add(const Duration(hours: 7)),
    );

    final GetSleepStatistics useCase =
        GetSleepStatistics(repository: _Repo(<SleepSession>[session]));

    final stats = await useCase(StatisticsRange.days7);

    expect(stats.sessionCount, 1);
    expect(stats.totalDuration, const Duration(hours: 7));
  });
}
