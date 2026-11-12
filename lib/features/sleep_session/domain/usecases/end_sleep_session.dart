import 'package:frenooze/core/platform/device_time_provider.dart';

import '../entities/sleep_session.dart';
import '../entities/time_accuracy.dart';
import '../exceptions/sleep_session_exception.dart';
import '../repositories/sleep_session_repository.dart';
import '../services/duration_calculator.dart';

/// Ends the active sleep session (PRD §4.3).
///
/// Captures the end timestamp, timezone, offset, monotonic time and boot
/// identity, derives the duration with [DurationCalculator], then persists
/// the completed session. The record is always saved before any wake-up
/// flow starts, so an interruption never loses data.
class EndSleepSession {
  EndSleepSession({
    required this.repository,
    required this.timeProvider,
    this.calculator = const DurationCalculator(),
  });

  final SleepSessionRepository repository;
  final DeviceTimeProvider timeProvider;
  final DurationCalculator calculator;

  Future<SleepSession> call() async {
    final SleepSession? active = await repository.getActiveSession();
    if (active == null) {
      throw SleepSessionException.noActiveSession;
    }

    final DeviceTimeSnapshot snapshot;
    try {
      snapshot = await timeProvider.capture();
    } on SleepSessionException {
      rethrow;
    } on Exception {
      throw SleepSessionException.platformUnavailable;
    }

    final DateTime endedAtUtc = snapshot.utcNow;
    final SleepSession candidate = SleepSession(
      id: active.id,
      startedAtUtc: active.startedAtUtc,
      endedAtUtc: endedAtUtc,
      startTimezone: active.startTimezone,
      endTimezone: snapshot.timezoneIanaId,
      startOffsetMinutes: active.startOffsetMinutes,
      endOffsetMinutes: snapshot.offsetMinutes,
      startElapsedMs: active.startElapsedMs,
      endElapsedMs: snapshot.elapsedRealtimeMs,
      startBootCount: active.startBootCount,
      endBootCount: snapshot.bootCount,
      isStartManual: active.isStartManual,
      isEndManual: false,
      accuracy: active.accuracy,
      createdAtUtc: active.createdAtUtc,
      updatedAtUtc: endedAtUtc,
    );

    final SleepDuration result = calculator.calculate(candidate);
    if (result.accuracy == TimeAccuracy.invalid) {
      throw SleepSessionException.invalidSession;
    }

    final SleepSession completed = SleepSession(
      id: candidate.id,
      startedAtUtc: candidate.startedAtUtc,
      endedAtUtc: candidate.endedAtUtc,
      startTimezone: candidate.startTimezone,
      endTimezone: candidate.endTimezone,
      startOffsetMinutes: candidate.startOffsetMinutes,
      endOffsetMinutes: candidate.endOffsetMinutes,
      startElapsedMs: candidate.startElapsedMs,
      endElapsedMs: candidate.endElapsedMs,
      startBootCount: candidate.startBootCount,
      endBootCount: candidate.endBootCount,
      isStartManual: candidate.isStartManual,
      isEndManual: candidate.isEndManual,
      accuracy: result.accuracy,
      createdAtUtc: candidate.createdAtUtc,
      updatedAtUtc: candidate.updatedAtUtc,
    );

    await repository.update(completed);
    return completed;
  }
}
