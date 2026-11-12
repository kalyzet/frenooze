import 'package:equatable/equatable.dart';

import '../../../sleep_session/domain/entities/sleep_session.dart';

/// Events for Wake-up Mode (ARCHITECTURE §6.2).
///
/// Named with the `Requested` suffix (matching SleepSessionBloc) so command
/// events never collide with the same-named use cases.
sealed class WakeUpEvent extends Equatable {
  const WakeUpEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Activates the mode after a sleep session has been persisted (PRD §4.3
/// step 6). Carries the completed session for summary display.
final class ActivateWakeUpRequested extends WakeUpEvent {
  const ActivateWakeUpRequested(this.completedSession);

  final SleepSession completedSession;

  @override
  List<Object?> get props => <Object?>[completedSession];
}

/// User closed the Wake-up Experience; idempotent (PRD §4.4.4).
final class CloseWakeUpRequested extends WakeUpEvent {
  const CloseWakeUpRequested();
}

/// App start: restore a possibly interrupted active mode (PRD §7.3 /
/// ARCHITECTURE §11.7).
final class RestoreWakeUpRequested extends WakeUpEvent {
  const RestoreWakeUpRequested();
}
