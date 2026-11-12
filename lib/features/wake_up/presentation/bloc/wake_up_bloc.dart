import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/wake_up_status.dart';
import '../../domain/exceptions/wake_up_exception.dart';
import '../../domain/usecases/activate_wake_up_mode.dart';
import '../../domain/usecases/close_wake_up_mode.dart';
import '../../domain/usecases/restore_wake_up_state.dart';
import 'wake_up_event.dart';
import 'wake_up_state.dart';

export 'wake_up_event.dart';
export 'wake_up_state.dart';

/// Orchestrates Wake-up Mode per PRD §4.4 and ARCHITECTURE §6.2.
///
/// Lifecycle: Restore (app start) → Inactive/Active; Activate after the
/// sleep session is saved; Close releases hardware first, then persists.
/// Close is idempotent — a repeated close still stops vibration/screen.
///
/// Blocs never call each other (ARCHITECTURE §6.6): the app coordinates by
/// listening to `SleepSessionSuccess` and dispatching activate here, so a
/// wake-up failure can never undo the saved session.
class WakeUpBloc extends Bloc<WakeUpEvent, WakeUpState> {
  WakeUpBloc({
    required ActivateWakeUpMode activateWakeUpMode,
    required CloseWakeUpMode closeWakeUpMode,
    required RestoreWakeUpState restoreWakeUpState,
  })  : _activateWakeUpMode = activateWakeUpMode,
        _closeWakeUpMode = closeWakeUpMode,
        _restoreWakeUpState = restoreWakeUpState,
        super(const WakeUpInitial()) {
    on<ActivateWakeUpRequested>(_onActivate);
    on<CloseWakeUpRequested>(_onClose);
    on<RestoreWakeUpRequested>(_onRestore);
  }

  final ActivateWakeUpMode _activateWakeUpMode;
  final CloseWakeUpMode _closeWakeUpMode;
  final RestoreWakeUpState _restoreWakeUpState;

  Future<void> _onActivate(
    ActivateWakeUpRequested event,
    Emitter<WakeUpState> emit,
  ) async {
    // PRD §4.3: session is already saved by SleepSessionBloc before this
    // event; activation only turns the mode on.
    if (state is WakeUpActive) {
      return;
    }
    emit(WakeUpActivating(event.completedSession));
    try {
      final WakeUpStatus status = await _activateWakeUpMode(
        event.completedSession.id,
      );
      emit(WakeUpActive(
        status: status,
        completedSession: event.completedSession,
      ));
    } on Exception catch (error) {
      emit(WakeUpFailure(_messageOf(error)));
    }
  }

  Future<void> _onClose(
    CloseWakeUpRequested event,
    Emitter<WakeUpState> emit,
  ) async {
    // Idempotent: closing from Initial/Inactive is a no-op success.
    if (state is WakeUpInactive || state is WakeUpInitial) {
      emit(const WakeUpInactive());
      return;
    }
    emit(const WakeUpClosing());
    try {
      await _closeWakeUpMode();
      emit(const WakeUpInactive());
    } on Exception catch (error) {
      emit(WakeUpFailure(_messageOf(error)));
    }
  }

  Future<void> _onRestore(
    RestoreWakeUpRequested event,
    Emitter<WakeUpState> emit,
  ) async {
    try {
      final WakeUpStatus status = await _restoreWakeUpState();
      if (status.isActive) {
        // Re-arm hardware that died with the previous process (PRD §4.4 /
        // §11.7): best effort to preserve the mode. The persisted active
        // flag is not discarded — Close still clears it.
        emit(WakeUpActive(status: status));
      } else {
        emit(const WakeUpInactive());
      }
    } on Exception catch (error) {
      emit(WakeUpFailure(_messageOf(error)));
    }
  }

  String _messageOf(Object error) {
    if (error is WakeUpException) {
      return error.message;
    }
    return 'Terjadi kesalahan pada Wake-up Mode. Coba lagi.';
  }
}
