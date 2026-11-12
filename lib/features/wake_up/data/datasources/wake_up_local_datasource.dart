import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';

/// Drift access for the single-row Wake-up Mode status table.
class WakeUpLocalDataSource {
  WakeUpLocalDataSource(this._db);

  final AppDatabase _db;

  /// The table only ever holds one row (id = 1).
  static const int _singleRowId = 1;

  Future<WakeUpStateRow?> findStatus() async {
    final query = _db.select(_db.wakeUpState)
      ..where((table) => table.id.equals(_singleRowId));
    return query.getSingleOrNull();
  }

  Future<void> upsertStatus({
    required bool isActive,
    required int? activatedAtUtcMs,
    required String? relatedSessionId,
    required int updatedAtUtcMs,
  }) async {
    await _db.into(_db.wakeUpState).insertOnConflictUpdate(
          WakeUpStateCompanion.insert(
            id: const Value(_singleRowId),
            isActive: Value(isActive),
            activatedAtUtcMs: Value(activatedAtUtcMs),
            relatedSessionId: Value(relatedSessionId),
            updatedAtUtcMs: updatedAtUtcMs,
          ),
        );
  }
}
