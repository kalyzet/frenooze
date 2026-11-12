import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/app_settings.dart';
import 'tables/sleep_sessions.dart';
import 'tables/wake_up_state.dart';

export 'tables/sleep_sessions.dart';
export 'tables/wake_up_state.dart';

part 'app_database.g.dart';

/// Local SQLite database for Frenooze.
///
/// The database is the single source of truth for offline-first behavior.
@DriftDatabase(tables: [SleepSessions, AppSettings, WakeUpState])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Used by tests with an in-memory or custom executor.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator migrator) async {
          await migrator.createAll();

          // At most one active session (ended_at_utc_ms IS NULL).
          // SQLite treats NULL values as distinct in a unique index, so the
          // indexed expression is a constant while the predicate selects the
          // single active row.
          await customStatement(
            'CREATE UNIQUE INDEX IF NOT EXISTS '
            'idx_sleep_sessions_single_active '
            'ON sleep_sessions ((1)) WHERE ended_at_utc_ms IS NULL',
          );

          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_sleep_sessions_started_at '
            'ON sleep_sessions (started_at_utc_ms)',
          );
        },
        beforeOpen: (OpeningDetails details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}

QueryExecutor _openConnection() => driftDatabase(name: 'frenooze');