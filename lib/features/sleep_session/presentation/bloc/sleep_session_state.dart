import 'package:equatable/equatable.dart';

import '../../domain/entities/sleep_session.dart';

/// States of the sleep session state machine (ARCHITECTURE §6.1 / §7).
sealed class SleepSessionState extends Equatable {
  const SleepSessionState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Nothing has been loaded yet.
final class SleepSessionInitial extends SleepSessionState {
  const SleepSessionInitial();
}

/// A use case is running.
final class SleepSessionLoading extends SleepSessionState {
  const SleepSessionLoading();
}

/// No active session; the dashboard shows the idle action card.
final class SleepSessionIdle extends SleepSessionState {
  const SleepSessionIdle();
}

/// The user asked to start sleeping but has not confirmed yet
/// (state machine §7.1: IDLE → READY_TO_SLEEP).
final class SleepSessionReadyToSleep extends SleepSessionState {
  const SleepSessionReadyToSleep();
}

/// A session is running; the dashboard shows the active card.
final class SleepSessionSleeping extends SleepSessionState {
  const SleepSessionSleeping(this.session);

  final SleepSession session;

  @override
  List<Object?> get props => <Object?>[session];
}

/// The end request is being persisted.
final class SleepSessionCompleting extends SleepSessionState {
  const SleepSessionCompleting(this.session);

  final SleepSession session;

  @override
  List<Object?> get props => <Object?>[session];
}

/// The last operation succeeded; [completed] holds the finished session when
/// one was just ended.
final class SleepSessionSuccess extends SleepSessionState {
  const SleepSessionSuccess([this.completed]);

  final SleepSession? completed;

  @override
  List<Object?> get props => <Object?>[completed];
}

/// The last operation failed; [message] is user-facing.
final class SleepSessionFailure extends SleepSessionState {
  const SleepSessionFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
