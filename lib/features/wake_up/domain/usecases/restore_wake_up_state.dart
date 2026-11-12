import '../entities/wake_up_status.dart';
import '../exceptions/wake_up_exception.dart';
import '../repositories/wake_up_repository.dart';

/// Loads the persisted Wake-up Mode status when the application opens
/// (ARCHITECTURE §6.1 `RestoreWakeUpState`).
///
/// An interrupted active mode reappears so the user can close it normally;
/// hardware is re-armed by the bloc, not here.
class RestoreWakeUpState {
  RestoreWakeUpState({required this.repository});

  final WakeUpRepository repository;

  Future<WakeUpStatus> call() async {
    try {
      return await repository.getActive();
    } on WakeUpException {
      rethrow;
    } on Exception {
      throw WakeUpException.loadFailure;
    }
  }
}
