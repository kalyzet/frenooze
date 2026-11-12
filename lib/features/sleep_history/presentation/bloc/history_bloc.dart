import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../sleep_session/domain/entities/sleep_session.dart';
import '../../../sleep_session/domain/exceptions/sleep_session_exception.dart';
import '../../../sleep_session/domain/usecases/delete_sleep_session.dart';
import '../../../sleep_session/domain/usecases/get_sleep_session_by_id.dart';
import '../../../sleep_session/domain/usecases/get_sleep_sessions.dart';
import '../../../sleep_session/domain/usecases/update_sleep_session.dart';
import 'history_event.dart';
import 'history_state.dart';

export 'history_event.dart';
export 'history_state.dart';

/// Load / detail / edit / delete for the sleep history screen
/// (ARCHITECTURE §5.4, §6.3).
///
/// Uses the sleep-session use cases directly — HistoryBloc never calls
/// SleepSessionBloc (ARCHITECTURE §6.6). Validation of edits lives in
/// [UpdateSleepSession]; this bloc only maps results to UI states.
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc({
    required GetSleepSessions getSleepSessions,
    required GetSleepSessionById getSleepSessionById,
    required UpdateSleepSession updateSleepSession,
    required DeleteSleepSession deleteSleepSession,
  })  : _getSleepSessions = getSleepSessions,
        _getSleepSessionById = getSleepSessionById,
        _updateSleepSession = updateSleepSession,
        _deleteSleepSession = deleteSleepSession,
        super(const HistoryInitial()) {
    on<LoadHistoryRequested>(_onLoad);
    on<RefreshHistoryRequested>(_onRefresh);
    on<OpenSessionRequested>(_onOpen);
    on<CloseDetailRequested>(_onCloseDetail);
    on<SaveEditRequested>(_onSaveEdit);
    on<DeleteSessionRequested>(_onDelete);
  }

  final GetSleepSessions _getSleepSessions;
  final GetSleepSessionById _getSleepSessionById;
  final UpdateSleepSession _updateSleepSession;
  final DeleteSleepSession _deleteSleepSession;

  Future<void> _onLoad(
    LoadHistoryRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(const HistoryLoading());
    await _reload(emit);
  }

  Future<void> _onRefresh(
    RefreshHistoryRequested event,
    Emitter<HistoryState> emit,
  ) async {
    // Keep whatever detail is open so a refresh under the detail page does
    // not yank navigation away from the user.
    final HistoryState current = state;
    final String? detailId =
        current is HistoryLoaded ? current.detailId : null;
    emit(const HistoryLoading());
    try {
      final List<SleepSession> sessions = await _getSleepSessions();
      emit(HistoryLoaded(sessions, detailId: detailId));
    } on Exception {
      emit(const HistoryFailure('Gagal memuat riwayat. Coba lagi.'));
    }
  }

  Future<void> _onOpen(
    OpenSessionRequested event,
    Emitter<HistoryState> emit,
  ) async {
    final HistoryState current = state;
    final List<SleepSession> sessions =
        current is HistoryLoaded ? current.sessions : const <SleepSession>[];
    try {
      // Re-read by id so the detail always reflects the stored row.
      final SleepSession session = await _getSleepSessionById(
        event.sessionId,
      );
      final List<SleepSession> merged = List<SleepSession>.of(sessions);
      final int index =
          merged.indexWhere((SleepSession s) => s.id == session.id);
      if (index >= 0) {
        merged[index] = session;
      } else {
        merged.insert(0, session);
      }
      emit(HistoryLoaded(merged, detailId: session.id));
    } on SleepSessionException catch (error) {
      emit(HistoryFailure(error.message));
    } on Exception {
      emit(const HistoryFailure('Gagal memuat detail sesi. Coba lagi.'));
    }
  }

  Future<void> _onCloseDetail(
    CloseDetailRequested event,
    Emitter<HistoryState> emit,
  ) async {
    final HistoryState current = state;
    if (current is HistoryLoaded) {
      emit(current.copyWith(clearDetail: true, busy: false));
    }
  }

  Future<void> _onSaveEdit(
    SaveEditRequested event,
    Emitter<HistoryState> emit,
  ) async {
    final HistoryState current = state;
    if (current is! HistoryLoaded) {
      return;
    }
    emit(current.copyWith(busy: true));
    try {
      final SleepSession saved = await _updateSleepSession(event.edited);
      final List<SleepSession> merged = List<SleepSession>.of(
        current.sessions,
      );
      final int index =
          merged.indexWhere((SleepSession s) => s.id == saved.id);
      if (index >= 0) {
        merged[index] = saved;
      }
      emit(HistoryLoaded(merged, detailId: saved.id));
    } on SleepSessionException catch (error) {
      emit(current.copyWith(busy: false));
      emit(HistoryFailure(error.message));
      // Restore the list so the user is not stuck on an error screen with
      // no way back to their data.
      add(const RefreshHistoryRequested());
    } on Exception {
      emit(current.copyWith(busy: false));
      emit(const HistoryFailure('Perubahan gagal disimpan. Coba lagi.'));
      add(const RefreshHistoryRequested());
    }
  }

  Future<void> _onDelete(
    DeleteSessionRequested event,
    Emitter<HistoryState> emit,
  ) async {
    final HistoryState current = state;
    if (current is! HistoryLoaded) {
      return;
    }
    emit(current.copyWith(busy: true));
    try {
      await _deleteSleepSession(event.sessionId);
      final List<SleepSession> remaining = current.sessions
          .where((SleepSession s) => s.id != event.sessionId)
          .toList(growable: false);
      emit(
        HistoryLoaded(
          remaining,
          detailId: null,
          busy: false,
        ),
      );
    } on SleepSessionException catch (error) {
      emit(current.copyWith(busy: false));
      emit(HistoryFailure(error.message));
      add(const RefreshHistoryRequested());
    } on Exception {
      emit(current.copyWith(busy: false));
      emit(const HistoryFailure('Sesi gagal dihapus. Coba lagi.'));
      add(const RefreshHistoryRequested());
    }
  }

  Future<void> _reload(Emitter<HistoryState> emit) async {
    try {
      final List<SleepSession> sessions = await _getSleepSessions();
      emit(HistoryLoaded(sessions));
    } on Exception {
      emit(const HistoryFailure('Gagal memuat riwayat. Coba lagi.'));
    }
  }
}
