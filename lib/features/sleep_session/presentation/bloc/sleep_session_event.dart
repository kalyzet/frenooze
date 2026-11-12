import 'package:equatable/equatable.dart';

import '../../domain/entities/sleep_session.dart';

/// Events handled by [SleepSessionBloc] (ARCHITECTURE §6.1).
sealed class SleepSessionEvent extends Equatable {
  const SleepSessionEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads the currently active session, if any.
final class LoadActiveSession extends SleepSessionEvent {
  const LoadActiveSession();
}

/// Requests creating a new sleep session.
final class StartSleepRequested extends SleepSessionEvent {
  const StartSleepRequested();
}

/// Requests ending the active sleep session.
final class EndSleepRequested extends SleepSessionEvent {
  const EndSleepRequested();
}

/// Requests saving a manual edit of [updated].
final class UpdateSleepRequested extends SleepSessionEvent {
  const UpdateSleepRequested(this.updated);

  final SleepSession updated;

  @override
  List<Object?> get props => <Object?>[updated];
}

/// Requests deleting the session with [id].
final class DeleteSleepRequested extends SleepSessionEvent {
  const DeleteSleepRequested(this.id);

  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}

/// Restores the active session when the application is opened again.
final class RecoverSessionRequested extends SleepSessionEvent {
  const RecoverSessionRequested();
}
