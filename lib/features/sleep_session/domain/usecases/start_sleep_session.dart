import 'dart:math';

import 'package:frenooze/core/platform/device_time_provider.dart';

import '../entities/sleep_session.dart';
import '../entities/time_accuracy.dart';
import '../exceptions/sleep_session_exception.dart';
import '../repositories/sleep_session_repository.dart';

/// Creates and persists a new sleep session (PRD §4.2.1).
///
/// Captures the device timestamp, timezone, UTC offset, monotonic time and
/// boot identity in one platform read, then persists the session. The
/// single-active restriction is checked here and again by the database's
/// partial unique index.
class StartSleepSession {
  StartSleepSession({
    required this.repository,
    required this.timeProvider,
  });

  final SleepSessionRepository repository;
  final DeviceTimeProvider timeProvider;

  static final Random _random = Random.secure();

  Future<SleepSession> call() async {
    final SleepSession? active = await repository.getActiveSession();
    if (active != null) {
      throw SleepSessionException.activeSessionExists;
    }

    final DeviceTimeSnapshot snapshot = await _capture();

    final DateTime now = snapshot.utcNow;
    final SleepSession session = SleepSession(
      id: _newId(),
      startedAtUtc: now,
      startTimezone: snapshot.timezoneIanaId,
      startOffsetMinutes: snapshot.offsetMinutes,
      startElapsedMs: snapshot.elapsedRealtimeMs,
      startBootCount: snapshot.bootCount,
      accuracy: TimeAccuracy.ok,
      createdAtUtc: now,
      updatedAtUtc: now,
    );

    await repository.insert(session);
    return session;
  }

  Future<DeviceTimeSnapshot> _capture() async {
    try {
      return await timeProvider.capture();
    } on SleepSessionException {
      rethrow;
    } on Exception {
      throw SleepSessionException.platformUnavailable;
    }
  }

  static String _newId() {
    final String timestamp =
        DateTime.now().toUtc().microsecondsSinceEpoch.toRadixString(36);
    final String nonce = _random.nextInt(1 << 32).toRadixString(36);
    return '$timestamp-$nonce';
  }
}
