import '../../domain/entities/sleep_session.dart';
import '../../domain/exceptions/sleep_session_exception.dart';
import '../../domain/repositories/sleep_session_repository.dart';
import '../datasources/sleep_session_local_datasource.dart';
import '../models/sleep_session_model.dart';

/// SQLite-backed [SleepSessionRepository].
class SleepSessionRepositoryImpl implements SleepSessionRepository {
  SleepSessionRepositoryImpl(this._dataSource);

  final SleepSessionLocalDataSource _dataSource;

  @override
  Future<SleepSession?> getActiveSession() async {
    final row = await _dataSource.findActive();
    return row?.toEntity();
  }

  @override
  Future<SleepSession?> getById(String id) async {
    final row = await _dataSource.findById(id);
    return row?.toEntity();
  }

  @override
  Future<List<SleepSession>> getAll() async {
    final rows = await _dataSource.findAll();
    return rows.map((row) => row.toEntity()).toList(growable: false);
  }

  @override
  Future<void> insert(SleepSession session) async {
    try {
      await _dataSource.insert(session.toCompanion());
    } on Exception catch (error) {
      if (_isSingleActiveViolation(error)) {
        throw SleepSessionException.activeSessionExists;
      }
      throw SleepSessionException.storageFailure;
    }
  }

  @override
  Future<void> update(SleepSession session) async {
    try {
      await _dataSource.update(session.toCompanion());
    } on Exception {
      throw SleepSessionException.storageFailure;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _dataSource.deleteById(id);
    } on Exception {
      throw SleepSessionException.storageFailure;
    }
  }

  /// Recognises the partial unique index violation that guards the
  /// single-active-session rule (ARCHITECTURE §13.4).
  static bool _isSingleActiveViolation(Object error) {
    final String text = error.toString();
    return text.contains('UNIQUE constraint failed') &&
        text.contains('idx_sleep_sessions_single_active');
  }
}
