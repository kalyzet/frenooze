import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frenooze/core/database/app_database.dart';
import 'package:frenooze/features/sleep_session/data/datasources/sleep_session_local_datasource.dart';
import 'package:frenooze/features/sleep_session/data/repositories/sleep_session_repository_impl.dart';
import 'package:frenooze/features/sleep_session/domain/entities/sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/entities/time_accuracy.dart';
import 'package:frenooze/features/sleep_session/domain/exceptions/sleep_session_exception.dart';

SleepSession _active(String id) => SleepSession(
  id: id,
  startedAtUtc: DateTime.utc(2026, 11, 12, 22),
  startTimezone: 'Asia/Jakarta',
  startOffsetMinutes: 420,
  startElapsedMs: 5000,
  startBootCount: 2,
  createdAtUtc: DateTime.utc(2026, 11, 12, 22),
  updatedAtUtc: DateTime.utc(2026, 11, 12, 22),
);

SleepSession _completed(String id) => SleepSession(
  id: id,
  startedAtUtc: DateTime.utc(2026, 11, 10, 14),
  endedAtUtc: DateTime.utc(2026, 11, 10, 21),
  startTimezone: 'Asia/Jakarta',
  endTimezone: 'Asia/Jakarta',
  startOffsetMinutes: 420,
  endOffsetMinutes: 420,
  startElapsedMs: 1000,
  endElapsedMs: 25201000,
  startBootCount: 1,
  endBootCount: 1,
  isStartManual: true,
  accuracy: TimeAccuracy.clockChanged,
  createdAtUtc: DateTime.utc(2026, 11, 10, 21),
  updatedAtUtc: DateTime.utc(2026, 11, 10, 22),
);

void main() {
  late AppDatabase db;
  late SleepSessionRepositoryImpl repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = SleepSessionRepositoryImpl(SleepSessionLocalDataSource(db));
  });

  tearDown(() => db.close());

  test('onCreate membangun tabel dan index integritas', () async {
    final List<QueryRow> tables = await db
        .customSelect(
          'SELECT name FROM sqlite_master WHERE type = \'table\' '
          'ORDER BY name',
        )
        .get();
    final List<String> tableNames = tables
        .map((QueryRow row) => row.read<String>('name'))
        .toList(growable: false);
    expect(
      tableNames,
      containsAll(<String>[
        'sleep_sessions',
        'app_settings',
        'wake_up_state',
      ]),
    );

    final List<QueryRow> indexes = await db
        .customSelect(
          'SELECT name, sql FROM sqlite_master '
          'WHERE type = \'index\' AND name LIKE \'idx_%\' ORDER BY name',
        )
        .get();
    final Map<String, String> indexSql = <String, String>{
      for (final QueryRow row in indexes)
        row.read<String>('name'): row.read<String>('sql'),
    };
    expect(
      indexSql.keys,
      containsAll(<String>[
        'idx_sleep_sessions_single_active',
        'idx_sleep_sessions_started_at',
      ]),
    );

    // The single-active guard must be a partial UNIQUE index on a constant
    // expression (SQLite treats NULLs as distinct), predicate = active rows.
    final String activeGuard = indexSql['idx_sleep_sessions_single_active']!;
    expect(activeGuard, contains('UNIQUE'));
    expect(activeGuard, contains('(1)'));
    expect(activeGuard, contains('WHERE ended_at_utc_ms IS NULL'));

    // beforeOpen enables FK enforcement on the live connection.
    final QueryRow pragma = await db
        .customSelect('PRAGMA foreign_keys')
        .getSingle();
    expect(pragma.data.values.single, 1);
  });

  test('Insert sesi aktif kedua ditolak activeSessionExists', () async {
    await repository.insert(_active('live-1'));

    await expectLater(
      repository.insert(_active('live-2')),
      throwsA(
        isA<SleepSessionException>().having(
          (SleepSessionException error) => error.code,
          'code',
          'active_session_exists',
        ),
      ),
    );

    // The first active row survived and remains the only active session.
    final List<SleepSession> all = await repository.getAll();
    expect(all, hasLength(1));
    expect(all.single.id, 'live-1');
    final SleepSession? active = await repository.getActiveSession();
    expect(active?.id, 'live-1');
  });

  test('Sesi aktif baru setelah sesi lama ditutup diterima', () async {
    final SleepSession first = _active('live-1');
    await repository.insert(first);
    await repository.update(
      SleepSession(
        id: first.id,
        startedAtUtc: first.startedAtUtc,
        endedAtUtc: DateTime.utc(2026, 11, 13, 5),
        startTimezone: first.startTimezone,
        endTimezone: 'Asia/Jakarta',
        startOffsetMinutes: first.startOffsetMinutes,
        endOffsetMinutes: 420,
        startElapsedMs: first.startElapsedMs,
        endElapsedMs: 26206000,
        startBootCount: first.startBootCount,
        endBootCount: 2,
        createdAtUtc: first.createdAtUtc,
        updatedAtUtc: DateTime.utc(2026, 11, 13, 5),
      ),
    );

    await repository.insert(_active('live-2'));

    expect((await repository.getActiveSession())?.id, 'live-2');
    expect(await repository.getAll(), hasLength(2));
  });

  test('Roundtrip insert -> getById -> getAll mempertahankan data', () async {
    final SleepSession session = _completed('done-1');
    await repository.insert(session);

    final SleepSession? loaded = await repository.getById('done-1');
    expect(loaded, isNotNull);
    expect(loaded!.id, session.id);
    expect(loaded.startedAtUtc, session.startedAtUtc);
    expect(loaded.endedAtUtc, session.endedAtUtc);
    expect(loaded.startTimezone, session.startTimezone);
    expect(loaded.endTimezone, session.endTimezone);
    expect(loaded.startOffsetMinutes, session.startOffsetMinutes);
    expect(loaded.endOffsetMinutes, session.endOffsetMinutes);
    expect(loaded.startElapsedMs, session.startElapsedMs);
    expect(loaded.endElapsedMs, session.endElapsedMs);
    expect(loaded.startBootCount, session.startBootCount);
    expect(loaded.endBootCount, session.endBootCount);
    expect(loaded.isStartManual, session.isStartManual);
    expect(loaded.accuracy, session.accuracy);
    expect(loaded.createdAtUtc, session.createdAtUtc);
    expect(loaded.updatedAtUtc, session.updatedAtUtc);

    final List<SleepSession> all = await repository.getAll();
    expect(all, hasLength(1));
    expect(all.single.id, 'done-1');
    expect(await repository.getById('missing'), isNull);

    // Completed rows are never reported as the active session.
    expect(await repository.getActiveSession(), isNull);
  });

  test('Delete menghapus baris dan idempoten', () async {
    await repository.insert(_completed('done-1'));
    await repository.insert(_active('live-1'));

    await repository.delete('live-1');
    expect(await repository.getActiveSession(), isNull);
    expect(await repository.getAll(), hasLength(1));

    await repository.delete('live-1');
    expect(await repository.getAll(), hasLength(1));
  });
}
