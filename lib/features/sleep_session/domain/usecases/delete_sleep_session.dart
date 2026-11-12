import '../exceptions/sleep_session_exception.dart';
import '../repositories/sleep_session_repository.dart';

/// Deletes one session by id; throws when it does not exist.
class DeleteSleepSession {
  DeleteSleepSession({required this.repository});

  final SleepSessionRepository repository;

  Future<void> call(String id) async {
    final bool exists = await repository.getById(id) != null;
    if (!exists) {
      throw SleepSessionException.sessionNotFound;
    }
    await repository.delete(id);
  }
}
