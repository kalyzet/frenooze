import 'package:equatable/equatable.dart';

import 'export_format.dart';

/// Generated export payload ready to be written or shared by the UI.
class ExportResult extends Equatable {
  const ExportResult({
    required this.format,
    required this.content,
    required this.suggestedFileName,
    required this.recordCount,
  });

  final ExportFormat format;

  /// File body (UTF-8 text).
  final String content;

  /// Suggested file name, e.g. `frenooze_backup_20261112.json`.
  final String suggestedFileName;

  /// Number of sessions included in the export.
  final int recordCount;

  @override
  List<Object?> get props => <Object?>[
        format,
        content,
        suggestedFileName,
        recordCount,
      ];
}
