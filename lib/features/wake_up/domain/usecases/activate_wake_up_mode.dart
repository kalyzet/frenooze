import '../entities/wake_up_status.dart';
import '../exceptions/wake_up_exception.dart';
import '../repositories/wake_up_repository.dart';
import '../services/wake_up_hardware.dart';

/// Activates Wake-up Mode after the sleep record has been saved
/// (PRD §4.3 step 6, §4.4.1; ARCHITECTURE §11.3).
///
/// Order is fixed by the PRD: persist status → keep screen on → start
/// vibration. The sleep session itself is never written here — that already
/// happened in the sleep-session module.
class ActivateWakeUpMode {
  ActivateWakeUpMode({
    required this.repository,
    required this.hardware,
  });

  final WakeUpRepository repository;
  final WakeUpHardware hardware;

  Future<WakeUpStatus> call(String relatedSessionId) async {
    final WakeUpStatus status;
    try {
      status = await repository.markActive(relatedSessionId);
    } on WakeUpException {
      rethrow;
    } on Exception {
      throw WakeUpException.storageFailure;
    }

    // Best-effort: status is already persisted as active, so the mode must
    // still surface (and be closable) even if vibration/screen arming fails.
    // Restore re-attempts hardware on next launch.
    try {
      await hardware.keepScreenOn();
      await hardware.startVibration();
    } on Exception {
      // Swallow — PRD §4.4 still requires an accessible close button, which
      // only exists when the mode reports Active.
    }

    return status;
  }
}
