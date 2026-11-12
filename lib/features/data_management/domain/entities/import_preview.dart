import 'package:equatable/equatable.dart';

import '../../../sleep_session/domain/entities/sleep_session.dart';

/// Result of parsing and validating a backup file before any write
/// (ARCHITECTURE §14.3 steps 2–6).
class ImportPreview extends Equatable {
  const ImportPreview({
    required this.validSessions,
    required this.existingIds,
    required this.localActiveId,
    required this.invalidCount,
    required this.sampleErrors,
    required this.totalInFile,
  });

  /// Every structurally valid session from the file (including duplicates).
  final List<SleepSession> validSessions;

  /// Ids already present in the local database.
  final Set<String> existingIds;

  /// Id of the currently active local session, when one exists.
  final String? localActiveId;

  /// Count of records rejected by validation.
  final int invalidCount;

  /// Bounded sample of validation messages for the preview UI.
  final List<String> sampleErrors;

  /// Total session records found in the file.
  final int totalInFile;

  /// Valid records whose id is not yet in the database.
  List<SleepSession> get newSessions => validSessions
      .where((SleepSession session) => !existingIds.contains(session.id))
      .toList(growable: false);

  /// Valid records whose id already exists locally.
  int get duplicateCount => validSessions.length - newSessions.length;

  /// `true` when a merge would violate the single-active-session rule:
  /// a local active session exists and the file introduces a different
  /// active session.
  bool get hasActiveConflict {
    final String? activeId = localActiveId;
    if (activeId == null) {
      return false;
    }
    return validSessions.any(
      (SleepSession session) =>
          session.isActive && session.id != activeId,
    );
  }

  /// `true` when the file contains at least one importable new record.
  bool get hasNewRecords => newSessions.isNotEmpty;

  @override
  List<Object?> get props => <Object?>[
        validSessions,
        existingIds,
        localActiveId,
        invalidCount,
        sampleErrors,
        totalInFile,
      ];
}
