import '../entities/sleep_session.dart';
import '../exceptions/sleep_session_exception.dart';
import '../repositories/sleep_session_repository.dart';

/// Returns one session by id; throws [SleepSessionException.sessionNotFound]
/// when it does not exist.
class GetSleepSessionById {
  GetSleepSessionById({required this.repository});

  final SleepSessionRepository repository;

  Future<SleepSession> call(String id) async {
    final SleepSession? session = await repository.getById(id);
    if (session == null) {
      throw SleepSessionException.sessionNotFound;
    }
    return session;
  }
}
