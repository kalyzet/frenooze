import '../entities/sleep_session.dart';
import '../repositories/sleep_session_repository.dart';

/// Returns the single active sleep session, or `null`.
class GetActiveSleepSession {
  GetActiveSleepSession({required this.repository});

  final SleepSessionRepository repository;

  Future<SleepSession?> call() => repository.getActiveSession();
}
