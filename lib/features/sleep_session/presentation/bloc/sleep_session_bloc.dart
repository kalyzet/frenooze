import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/sleep_session.dart';
import '../../domain/exceptions/sleep_session_exception.dart';
import '../../domain/usecases/delete_sleep_session.dart';
import '../../domain/usecases/end_sleep_session.dart';
import '../../domain/usecases/get_active_sleep_session.dart';
import '../../domain/usecases/recover_active_session.dart';
import '../../domain/usecases/start_sleep_session.dart';
import '../../domain/usecases/update_sleep_session.dart';
import 'sleep_session_event.dart';
import 'sleep_session_state.dart';

export 'sleep_session_event.dart';
export 'sleep_session_state.dart';

/// Coordinates sleep session use cases and the state machine
/// (ARCHITECTURE §6.1, §7).
///
/// Transitions are validated by the domain layer; this bloc only forwards
/// events and maps results (including user-facing failures) to states.
class SleepSessionBloc extends Bloc<SleepSessionEvent, SleepSessionState> {
  SleepSessionBloc({
    required this.startSleepSession,
    required this.endSleepSession,
    required this.getActiveSleepSession,
    required this.updateSleepSession,
    required this.deleteSleepSession,
    required this.recoverActiveSession,
  }) : super(const SleepSessionInitial()) {
    on<LoadActiveSession>(_onLoadActive);
    on<StartSleepRequested>(_onStartSleep);
    on<EndSleepRequested>(_onEndSleep);
    on<UpdateSleepRequested>(_onUpdateSleep);
    on<DeleteSleepRequested>(_onDeleteSleep);
    on<RecoverSessionRequested>(_onRecoverSession);
  }

  final StartSleepSession startSleepSession;
  final EndSleepSession endSleepSession;
  final GetActiveSleepSession getActiveSleepSession;
  final UpdateSleepSession updateSleepSession;
  final DeleteSleepSession deleteSleepSession;
  final RecoverActiveSession recoverActiveSession;

  Future<void> _onLoadActive(
    LoadActiveSession event,
    Emitter<SleepSessionState> emit,
  ) =>
      _loadActive(emit);

  Future<void> _onRecoverSession(
    RecoverSessionRequested event,
    Emitter<SleepSessionState> emit,
  ) =>
      _loadActive(emit);

  Future<void> _loadActive(Emitter<SleepSessionState> emit) async {
    emit(const SleepSessionLoading());
    try {
      final SleepSession? active = await recoverActiveSession();
      if (active == null) {
        emit(const SleepSessionIdle());
      } else {
        emit(SleepSessionSleeping(active));
      }
    } on SleepSessionException catch (error) {
      emit(SleepSessionFailure(error.message));
    } on Exception {
      emit(SleepSessionFailure(SleepSessionException.loadFailure.message));
    }
  }

  Future<void> _onStartSleep(
    StartSleepRequested event,
    Emitter<SleepSessionState> emit,
  ) async {
    try {
      final SleepSession session = await startSleepSession();
      emit(SleepSessionSleeping(session));
    } on Exception catch (error) {
      _emitFailure(error, emit);
      // Re-read the stored state so an existing active session is offered
      // to the user instead of a dead-end error screen (PRD §4.2.2).
      add(const LoadActiveSession());
    }
  }

  Future<void> _onEndSleep(
    EndSleepRequested event,
    Emitter<SleepSessionState> emit,
  ) async {
    final SleepSessionState current = state;
    if (current is SleepSessionSleeping) {
      emit(SleepSessionCompleting(current.session));
    }
    try {
      final SleepSession completed = await endSleepSession();
      emit(SleepSessionSuccess(completed));
    } on Exception catch (error) {
      _emitFailure(error, emit);
      add(const LoadActiveSession());
    }
  }

  Future<void> _onUpdateSleep(
    UpdateSleepRequested event,
    Emitter<SleepSessionState> emit,
  ) async {
    try {
      await updateSleepSession(event.updated);
    } on Exception catch (error) {
      _emitFailure(error, emit);
    }
    add(const LoadActiveSession());
  }

  Future<void> _onDeleteSleep(
    DeleteSleepRequested event,
    Emitter<SleepSessionState> emit,
  ) async {
    try {
      await deleteSleepSession(event.id);
    } on Exception catch (error) {
      _emitFailure(error, emit);
    }
    add(const LoadActiveSession());
  }

  static void _emitFailure(
    Object error,
    Emitter<SleepSessionState> emit,
  ) {
    if (error is SleepSessionException) {
      emit(SleepSessionFailure(error.message));
    } else {
      emit(SleepSessionFailure(SleepSessionException.storageFailure.message));
    }
  }
}
