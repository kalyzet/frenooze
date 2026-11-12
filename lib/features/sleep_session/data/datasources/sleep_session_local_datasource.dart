import 'package:drift/drift.dart';

import 'package:frenooze/core/database/app_database.dart';

/// Drift queries for the `sleep_sessions` table.
///
/// Thin persistence layer: it knows rows and SQL, never business rules.
class SleepSessionLocalDataSource {
  SleepSessionLocalDataSource(this._database);

  final AppDatabase _database;

  /// Returns the single row whose end timestamp is `null` (at most one can
  /// exist thanks to the partial unique index).
  Future<SleepSessionRow?> findActive() async {
    final SimpleSelectStatement<SleepSessions, SleepSessionRow> query =
        _database.select(_database.sleepSessions)
          ..where((SleepSessions table) => table.endedAtUtcMs.isNull())
          ..limit(1);
    return query.getSingleOrNull();
  }

  Future<SleepSessionRow?> findById(String id) async {
    final SimpleSelectStatement<SleepSessions, SleepSessionRow> query =
        _database.select(_database.sleepSessions)
          ..where((SleepSessions table) => table.id.equals(id));
    return query.getSingleOrNull();
  }

  Future<List<SleepSessionRow>> findAll() async {
    final SimpleSelectStatement<SleepSessions, SleepSessionRow> query =
        _database.select(_database.sleepSessions)
          ..orderBy(<OrderClauseGenerator<SleepSessions>>[
            (SleepSessions table) => OrderingTerm.desc(table.startedAtUtcMs),
          ]);
    return query.get();
  }

  Future<void> insert(SleepSessionsCompanion companion) async {
    await _database.into(_database.sleepSessions).insert(companion);
  }

  Future<void> update(SleepSessionsCompanion companion) async {
    final String id = companion.id.value;
    await (_database.update(_database.sleepSessions)
          ..where((SleepSessions table) => table.id.equals(id)))
        .write(companion);
  }

  Future<void> deleteById(String id) async {
    await (_database.delete(_database.sleepSessions)
          ..where((SleepSessions table) => table.id.equals(id)))
        .go();
  }
}
