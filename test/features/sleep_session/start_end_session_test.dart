import 'package:flutter_test/flutter_test.dart';
import 'package:frenooze/core/platform/device_time_provider.dart';
import 'package:frenooze/features/sleep_session/domain/entities/sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/entities/time_accuracy.dart';
import 'package:frenooze/features/sleep_session/domain/exceptions/sleep_session_exception.dart';
import 'package:frenooze/features/sleep_session/domain/repositories/sleep_session_repository.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/end_sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/start_sleep_session.dart';

class _MemoryRepository implements SleepSessionRepository {
  SleepSession? active;
  SleepSession? lastInserted;
  SleepSession? lastUpdated;
  int insertCalls = 0;

  @override
  Future<SleepSession?> getActiveSession() async => active;

  @override
  Future<SleepSession?> getById(String id) async =>
      active?.id == id ? active : null;

  @override
  Future<List<SleepSession>> getAll() async =>
      active == null ? <SleepSession>[] : <SleepSession>[active!];

  @override
  Future<void> insert(SleepSession session) async {
    insertCalls += 1;
    lastInserted = session;
    active = session;
  }

  @override
  Future<void> update(SleepSession session) async {
    lastUpdated = session;
    active = null;
  }

  @override
  Future<void> delete(String id) async {}
}

class _FixedTimeProvider implements DeviceTimeProvider {
  _FixedTimeProvider(this.snapshot);

  final DeviceTimeSnapshot snapshot;

  @override
  Future<DeviceTimeSnapshot> capture() async => snapshot;
}

class _ThrowingTimeProvider implements DeviceTimeProvider {
  @override
  Future<DeviceTimeSnapshot> capture() async =>
      throw Exception('platform down');
}

void main() {
  late _MemoryRepository memory;

  setUp(() {
    memory = _MemoryRepository();
  });

  group('StartSleepSession', () {
    test('creates active session with platform snapshot', () async {
      final StartSleepSession useCase = StartSleepSession(
        repository: memory,
        timeProvider: _FixedTimeProvider(
          DeviceTimeSnapshot(
            utcNow: DateTime.utc(2026, 11, 11, 15, 0),
            timezoneIanaId: 'Asia/Jakarta',
            offsetMinutes: 420,
            elapsedRealtimeMs: 12345,
            bootCount: 7,
          ),
        ),
      );

      final SleepSession session = await useCase();

      expect(session.isActive, isTrue);
      expect(session.startedAtUtc, DateTime.utc(2026, 11, 11, 15, 0));
      expect(session.startTimezone, 'Asia/Jakarta');
      expect(session.startOffsetMinutes, 420);
      expect(session.startElapsedMs, 12345);
      expect(session.startBootCount, 7);
      expect(memory.insertCalls, 1);
      expect(memory.active?.id, session.id);
    });

    test('throws when an active session already exists', () async {
      memory.active = SleepSession(
        id: 'existing',
        startedAtUtc: DateTime.utc(2026, 1, 1),
        startTimezone: 'Asia/Jakarta',
        startOffsetMinutes: 420,
        startElapsedMs: 0,
        startBootCount: 1,
        createdAtUtc: DateTime.utc(2026, 1, 1),
        updatedAtUtc: DateTime.utc(2026, 1, 1),
      );

      final StartSleepSession useCase = StartSleepSession(
        repository: memory,
        timeProvider: _FixedTimeProvider(
          DeviceTimeSnapshot(
            utcNow: DateTime.utc(2026, 1, 1),
            timezoneIanaId: 'Asia/Jakarta',
            offsetMinutes: 420,
            elapsedRealtimeMs: 0,
            bootCount: 1,
          ),
        ),
      );

      await expectLater(
        useCase(),
        throwsA(SleepSessionException.activeSessionExists),
      );
    });

    test('maps time provider failure to platformUnavailable', () async {
      final StartSleepSession useCase = StartSleepSession(
        repository: memory,
        timeProvider: _ThrowingTimeProvider(),
      );

      await expectLater(
        useCase(),
        throwsA(SleepSessionException.platformUnavailable),
      );
    });
  });

  group('EndSleepSession', () {
    test('completes active session with monotonic duration', () async {
      memory.active = SleepSession(
        id: 's1',
        startedAtUtc: DateTime.utc(2026, 11, 11, 15),
        startTimezone: 'Asia/Jakarta',
        startOffsetMinutes: 420,
        startElapsedMs: 1000,
        startBootCount: 1,
        accuracy: TimeAccuracy.ok,
        createdAtUtc: DateTime.utc(2026, 11, 11, 15),
        updatedAtUtc: DateTime.utc(2026, 11, 11, 15),
      );

      final EndSleepSession useCase = EndSleepSession(
        repository: memory,
        timeProvider: _FixedTimeProvider(
          DeviceTimeSnapshot(
            utcNow: DateTime.utc(2026, 11, 11, 23),
            timezoneIanaId: 'Asia/Jakarta',
            offsetMinutes: 420,
            elapsedRealtimeMs: 1000 + 8 * 3600 * 1000,
            bootCount: 1,
          ),
        ),
      );

      final SleepSession completed = await useCase();

      expect(completed.endedAtUtc, DateTime.utc(2026, 11, 11, 23));
      expect(completed.accuracy, TimeAccuracy.ok);
      expect(memory.lastUpdated?.id, 's1');
      expect(memory.active, isNull);
    });

    test('throws when no active session', () async {
      final EndSleepSession useCase = EndSleepSession(
        repository: memory,
        timeProvider: _FixedTimeProvider(
          DeviceTimeSnapshot(
            utcNow: DateTime.utc(2026, 1, 1),
            timezoneIanaId: 'Asia/Jakarta',
            offsetMinutes: 420,
            elapsedRealtimeMs: 0,
            bootCount: 1,
          ),
        ),
      );

      await expectLater(
        useCase(),
        throwsA(SleepSessionException.noActiveSession),
      );
    });
  });
}
