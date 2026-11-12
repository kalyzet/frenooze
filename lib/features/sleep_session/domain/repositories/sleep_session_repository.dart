import '../entities/sleep_session.dart';

/// Contract for persisting sleep sessions.
///
/// The implementation lives in the data layer; the domain layer only depends
/// on this abstraction so business rules stay testable without SQLite.
abstract interface class SleepSessionRepository {
  /// Returns the single session whose end timestamp is `null`, or `null`.
  ///
  /// The database enforces at most one such row through a partial unique
  /// index (ARCHITECTURE §13.4).
  Future<SleepSession?> getActiveSession();

  /// Returns the session with [id], or `null` when it does not exist.
  Future<SleepSession?> getById(String id);

  /// Returns every session ordered from newest to oldest start time.
  Future<List<SleepSession>> getAll();

  /// Inserts a new session; throws when another active session exists.
  Future<void> insert(SleepSession session);

  /// Replaces the stored session with the same id.
  Future<void> update(SleepSession session);

  /// Deletes the session with [id]; no-op when it does not exist.
  Future<void> delete(String id);
}
