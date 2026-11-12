import '../entities/sleep_session.dart';
import '../repositories/sleep_session_repository.dart';

/// Loads the active session when the application is opened again.
///
/// The app never starts a second session implicitly: an interrupted session
/// simply reappears as the active record so the user can end it normally
/// (PRD §4.2.2 / recovery).
class RecoverActiveSession {
  RecoverActiveSession({required this.repository});

  final SleepSessionRepository repository;

  Future<SleepSession?> call() => repository.getActiveSession();
}
