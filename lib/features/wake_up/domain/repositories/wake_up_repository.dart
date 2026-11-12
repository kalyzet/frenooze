import '../entities/wake_up_status.dart';

/// Contract for persisting the single Wake-up Mode status row.
abstract interface class WakeUpRepository {
  /// Returns the stored status; inactive when nothing was ever written.
  Future<WakeUpStatus> getActive();

  /// Marks Wake-up Mode active for [relatedSessionId] (PRD §4.4.1).
  Future<WakeUpStatus> markActive(String relatedSessionId);

  /// Marks Wake-up Mode inactive without touching sleep sessions
  /// (PRD §4.4.4).
  Future<WakeUpStatus> markInactive();
}
