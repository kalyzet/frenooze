import 'package:drift/drift.dart';

import 'package:frenooze/core/database/app_database.dart';

import '../../../sleep_session/data/models/sleep_session_model.dart';
import '../../../sleep_session/domain/entities/sleep_session.dart';
import '../../domain/exceptions/data_management_exception.dart';
import '../../domain/repositories/data_management_repository.dart';

/// Drift-backed bulk operations for backup export / import.
///
/// Every multi-row write runs inside a single transaction so a failure
/// rolls back completely (ARCHITECTURE §5.6, §14.3 step 8).
class DataManagementRepositoryImpl implements DataManagementRepository {
  DataManagementRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Future<List<SleepSession>> getAllSessions() async {
    final SimpleSelectStatement<SleepSessions, SleepSessionRow> query =
        _database.select(_database.sleepSessions)
          ..orderBy(<OrderClauseGenerator<SleepSessions>>[
            (SleepSessions table) => OrderingTerm.desc(table.startedAtUtcMs),
          ]);
    final List<SleepSessionRow> rows = await query.get();
    return rows
        .map((SleepSessionRow row) => row.toEntity())
        .toList(growable: false);
  }

  @override
  Future<String?> getActiveSessionId() async {
    final SimpleSelectStatement<SleepSessions, SleepSessionRow> query =
        _database.select(_database.sleepSessions)
          ..where((SleepSessions table) => table.endedAtUtcMs.isNull())
          ..limit(1);
    final SleepSessionRow? row = await query.getSingleOrNull();
    return row?.id;
  }

  @override
  Future<Set<String>> getExistingIds() async {
    final SimpleSelectStatement<SleepSessions, SleepSessionRow> query =
        _database.select(_database.sleepSessions);
    final List<SleepSessionRow> rows = await query.get();
    return rows.map((SleepSessionRow row) => row.id).toSet();
  }

  @override
  Future<void> replaceAll(List<SleepSession> sessions) async {
    try {
      await _database.transaction(() async {
        await _database.delete(_database.sleepSessions).go();
        for (final SleepSession session in sessions) {
          await _database
              .into(_database.sleepSessions)
              .insert(session.toCompanion());
        }
      });
    } on Exception catch (error) {
      if (_isSingleActiveViolation(error)) {
        throw DataManagementException.activeSessionConflict;
      }
      throw DataManagementException.storageFailure;
    }
  }

  @override
  Future<int> insertMissing(List<SleepSession> sessions) async {
    try {
      return await _database.transaction<int>(() async {
        int written = 0;
        for (final SleepSession session in sessions) {
          final SleepSessionRow? existing =
              await (_database.select(_database.sleepSessions)
                    ..where(
                      (SleepSessions table) => table.id.equals(session.id),
                    )
                    ..limit(1))
                  .getSingleOrNull();
          if (existing != null) {
            continue;
          }
          await _database
              .into(_database.sleepSessions)
              .insert(session.toCompanion());
          written += 1;
        }
        return written;
      });
    } on Exception catch (error) {
      if (_isSingleActiveViolation(error)) {
        throw DataManagementException.activeSessionConflict;
      }
      throw DataManagementException.storageFailure;
    }
  }

  static bool _isSingleActiveViolation(Object error) {
    final String text = error.toString();
    return text.contains('UNIQUE constraint failed') &&
        text.contains('idx_sleep_sessions_single_active');
  }
}
