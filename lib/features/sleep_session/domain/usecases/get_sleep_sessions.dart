import '../entities/sleep_session.dart';
import '../repositories/sleep_session_repository.dart';

/// Returns every recorded session, newest first.
class GetSleepSessions {
  GetSleepSessions({required this.repository});

  final SleepSessionRepository repository;

  Future<List<SleepSession>> call() => repository.getAll();
}
