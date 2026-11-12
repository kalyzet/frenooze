import '../entities/wake_up_status.dart';
import '../exceptions/wake_up_exception.dart';
import '../repositories/wake_up_repository.dart';
import '../services/wake_up_hardware.dart';

/// Closes Wake-up Mode (PRD §4.4.4).
///
/// Order: stop vibration → release screen → mark inactive. Idempotent —
/// closing an already-inactive mode still stops hardware and succeeds, so a
/// double tap can never leave the vibrator running. The completed sleep
/// session is never modified.
class CloseWakeUpMode {
  CloseWakeUpMode({
    required this.repository,
    required this.hardware,
  });

  final WakeUpRepository repository;
  final WakeUpHardware hardware;

  Future<WakeUpStatus> call() async {
    try {
      await hardware.stopVibration();
      await hardware.releaseScreenOn();
    } on Exception {
      // Hardware stop is best-effort; persistence below still runs so the
      // mode cannot come back on the next launch.
    }

    try {
      return await repository.markInactive();
    } on WakeUpException {
      rethrow;
    } on Exception {
      throw WakeUpException.storageFailure;
    }
  }
}
