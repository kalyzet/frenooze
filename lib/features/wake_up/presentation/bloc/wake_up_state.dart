import 'package:equatable/equatable.dart';

import '../../../sleep_session/domain/entities/sleep_session.dart';
import '../../domain/entities/wake_up_status.dart';

/// States for Wake-up Mode (ARCHITECTURE §6.2).
sealed class WakeUpState extends Equatable {
  const WakeUpState();

  @override
  List<Object?> get props => <Object?>[];
}

final class WakeUpInitial extends WakeUpState {
  const WakeUpInitial();
}

/// Mode off; dashboard behaves normally.
final class WakeUpInactive extends WakeUpState {
  const WakeUpInactive();
}

/// Persisting status / arming vibration; UI shows the Wake-up page without
/// the close affordance yet (or a subtle loading state).
final class WakeUpActivating extends WakeUpState {
  const WakeUpActivating(this.completedSession);

  final SleepSession completedSession;

  @override
  List<Object?> get props => <Object?>[completedSession];
}

/// Mode on: vibration + screen keep-on active (PRD §4.4).
final class WakeUpActive extends WakeUpState {
  const WakeUpActive({
    required this.status,
    this.completedSession,
  });

  final WakeUpStatus status;

  /// Summary source; null when restoring without a resolvable session.
  final SleepSession? completedSession;

  @override
  List<Object?> get props => <Object?>[status, completedSession];
}

/// User closed the mode; hardware is being released.
final class WakeUpClosing extends WakeUpState {
  const WakeUpClosing();
}

/// Recoverable failure; message is user-facing Bahasa Indonesia.
final class WakeUpFailure extends WakeUpState {
  const WakeUpFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
