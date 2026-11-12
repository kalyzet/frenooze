import 'package:equatable/equatable.dart';

import '../../../sleep_session/domain/entities/sleep_session.dart';

/// States of the history flow (ARCHITECTURE §6.3).
sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => <Object?>[];
}

final class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

/// The list is being loaded (or refreshed).
final class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

/// List is ready; [detailId] is non-null while a detail/edit flow is open.
final class HistoryLoaded extends HistoryState {
  const HistoryLoaded(this.sessions, {this.detailId, this.busy = false});

  final List<SleepSession> sessions;

  /// Currently open session id, or null when only the list is shown.
  final String? detailId;

  /// True while an edit or delete is being persisted.
  final bool busy;

  SleepSession? get detail {
    final String? id = detailId;
    if (id == null) {
      return null;
    }
    for (final SleepSession session in sessions) {
      if (session.id == id) {
        return session;
      }
    }
    return null;
  }

  HistoryLoaded copyWith({
    List<SleepSession>? sessions,
    String? detailId,
    bool clearDetail = false,
    bool? busy,
  }) => HistoryLoaded(
        sessions ?? this.sessions,
        detailId: clearDetail ? null : detailId ?? this.detailId,
        busy: busy ?? this.busy,
      );

  @override
  List<Object?> get props => <Object?>[sessions, detailId, busy];
}

/// The list failed to load; [message] is user-facing.
final class HistoryFailure extends HistoryState {
  const HistoryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
