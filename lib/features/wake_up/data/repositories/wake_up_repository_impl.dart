import '../../../../core/database/app_database.dart';
import '../../domain/entities/wake_up_status.dart';
import '../../domain/exceptions/wake_up_exception.dart';
import '../../domain/repositories/wake_up_repository.dart';
import '../datasources/wake_up_local_datasource.dart';

/// SQLite-backed [WakeUpRepository] over the single status row.
class WakeUpRepositoryImpl implements WakeUpRepository {
  WakeUpRepositoryImpl(this._dataSource);

  final WakeUpLocalDataSource _dataSource;

  @override
  Future<WakeUpStatus> getActive() async {
    try {
      final row = await _dataSource.findStatus();
      return _toStatus(row);
    } on Exception {
      throw WakeUpException.loadFailure;
    }
  }

  @override
  Future<WakeUpStatus> markActive(String relatedSessionId) async {
    final now = DateTime.now().toUtc();
    try {
      await _dataSource.upsertStatus(
        isActive: true,
        activatedAtUtcMs: now.millisecondsSinceEpoch,
        relatedSessionId: relatedSessionId,
        updatedAtUtcMs: now.millisecondsSinceEpoch,
      );
    } on Exception {
      throw WakeUpException.storageFailure;
    }
    return WakeUpStatus(
      isActive: true,
      activatedAtUtc: now,
      relatedSessionId: relatedSessionId,
      updatedAtUtc: now,
    );
  }

  @override
  Future<WakeUpStatus> markInactive() async {
    final now = DateTime.now().toUtc();
    try {
      final existing = await _dataSource.findStatus();
      await _dataSource.upsertStatus(
        isActive: false,
        // Preserve activation metadata on close so the record of when the
        // mode ran survives; only isActive/updatedAt change (PRD §4.4.4 —
        // the sleep session itself is never touched here).
        activatedAtUtcMs: existing?.activatedAtUtcMs,
        relatedSessionId: existing?.relatedSessionId,
        updatedAtUtcMs: now.millisecondsSinceEpoch,
      );
      return WakeUpStatus(
        isActive: false,
        activatedAtUtc: existing == null || existing.activatedAtUtcMs == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                existing.activatedAtUtcMs!,
                isUtc: true,
              ),
        relatedSessionId: existing?.relatedSessionId,
        updatedAtUtc: now,
      );
    } on Exception {
      throw WakeUpException.storageFailure;
    }
  }

  WakeUpStatus _toStatus(WakeUpStateRow? row) {
    if (row == null) {
      return WakeUpStatus.inactive();
    }
    return WakeUpStatus(
      isActive: row.isActive,
      activatedAtUtc: row.activatedAtUtcMs == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              row.activatedAtUtcMs!,
              isUtc: true,
            ),
      relatedSessionId: row.relatedSessionId,
      updatedAtUtc: DateTime.fromMillisecondsSinceEpoch(
        row.updatedAtUtcMs,
        isUtc: true,
      ),
    );
  }
}
