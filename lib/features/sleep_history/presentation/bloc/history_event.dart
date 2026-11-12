import 'package:equatable/equatable.dart';

import '../../../sleep_session/domain/entities/sleep_session.dart';

/// Events handled by [HistoryBloc] (ARCHITECTURE §6.3).
sealed class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads every session for the history list (newest first).
final class LoadHistoryRequested extends HistoryEvent {
  const LoadHistoryRequested();
}

/// Reloads the list after an external change (e.g. a session just ended).
final class RefreshHistoryRequested extends HistoryEvent {
  const RefreshHistoryRequested();
}

/// Opens the detail view for one session.
final class OpenSessionRequested extends HistoryEvent {
  const OpenSessionRequested(this.sessionId);

  final String sessionId;

  @override
  List<Object?> get props => <Object?>[sessionId];
}

/// Closes the detail view and returns to the list.
final class CloseDetailRequested extends HistoryEvent {
  const CloseDetailRequested();
}

/// Persists a manual edit of [edited] (PRD §4.6).
final class SaveEditRequested extends HistoryEvent {
  const SaveEditRequested(this.edited);

  final SleepSession edited;

  @override
  List<Object?> get props => <Object?>[edited];
}

/// Deletes the open session after the user confirmed (PRD §4.5).
final class DeleteSessionRequested extends HistoryEvent {
  const DeleteSessionRequested(this.sessionId);

  final String sessionId;

  @override
  List<Object?> get props => <Object?>[sessionId];
}
