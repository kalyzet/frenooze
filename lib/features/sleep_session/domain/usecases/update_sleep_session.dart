import 'package:frenooze/core/time/clock_provider.dart';

import '../entities/sleep_session.dart';
import '../entities/time_accuracy.dart';
import '../exceptions/sleep_session_exception.dart';
import '../repositories/sleep_session_repository.dart';

/// Persists a manual edit of an existing session (PRD §4.5).
///
/// Validates the edited timestamps, marks the touched fields as manually
/// edited and flags the record with [TimeAccuracy.manual] so statistics can
/// treat it accordingly.
class UpdateSleepSession {
  UpdateSleepSession({
    required this.repository,
    this.clock = const SystemClockProvider(),
  });

  final SleepSessionRepository repository;
  final ClockProvider clock;

  Future<SleepSession> call(SleepSession edited) async {
    final SleepSession? existing = await repository.getById(edited.id);
    if (existing == null) {
      throw SleepSessionException.sessionNotFound;
    }

    final DateTime? endedAtUtc = edited.endedAtUtc;
    if (endedAtUtc != null && endedAtUtc.isBefore(edited.startedAtUtc)) {
      throw SleepSessionException.invalidSession;
    }

    final bool startChanged =
        !edited.startedAtUtc.isAtSameMomentAs(existing.startedAtUtc);
    final bool endChanged = _endChanged(existing.endedAtUtc, endedAtUtc);

    final DateTime now = clock.nowUtc();
    final SleepSession saved = SleepSession(
      id: edited.id,
      startedAtUtc: edited.startedAtUtc,
      endedAtUtc: endedAtUtc,
      startTimezone: edited.startTimezone,
      endTimezone: edited.endTimezone,
      startOffsetMinutes: edited.startOffsetMinutes,
      endOffsetMinutes: edited.endOffsetMinutes,
      startElapsedMs: edited.startElapsedMs,
      endElapsedMs: edited.endElapsedMs,
      startBootCount: edited.startBootCount,
      endBootCount: edited.endBootCount,
      isStartManual: existing.isStartManual || startChanged,
      isEndManual: existing.isEndManual || endChanged,
      accuracy: startChanged || endChanged
          ? TimeAccuracy.manual
          : edited.accuracy,
      createdAtUtc: existing.createdAtUtc,
      updatedAtUtc: now,
    );

    await repository.update(saved);
    return saved;
  }

  static bool _endChanged(DateTime? before, DateTime? after) {
    if (before == null && after == null) {
      return false;
    }
    if (before == null || after == null) {
      return true;
    }
    return !before.isAtSameMomentAs(after);
  }
}
