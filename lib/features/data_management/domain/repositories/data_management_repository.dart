import '../../../sleep_session/domain/entities/sleep_session.dart';

/// Contract for bulk sleep-data reads/writes used by export and import.
///
/// Multi-record mutations must run inside a database transaction
/// (ARCHITECTURE §5.6).
abstract interface class DataManagementRepository {
  /// Every stored session, newest start first.
  Future<List<SleepSession>> getAllSessions();

  /// Id of the single active session (`ended_at_utc_ms IS NULL`), or null.
  Future<String?> getActiveSessionId();

  /// Ids of all stored sessions (for duplicate detection).
  Future<Set<String>> getExistingIds();

  /// Deletes every session and inserts [sessions] in one transaction.
  Future<void> replaceAll(List<SleepSession> sessions);

  /// Inserts only sessions whose id is not already stored, in one
  /// transaction. Returns how many rows were written.
  Future<int> insertMissing(List<SleepSession> sessions);
}
