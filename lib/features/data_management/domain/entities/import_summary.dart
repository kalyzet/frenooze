import 'package:equatable/equatable.dart';

import 'import_strategy.dart';

/// Outcome of a confirmed import transaction (ARCHITECTURE §14.3 step 9).
class ImportSummary extends Equatable {
  const ImportSummary({
    required this.strategy,
    required this.importedCount,
    required this.skippedDuplicateCount,
    required this.totalValidInFile,
  });

  final ImportStrategy strategy;

  /// Records written in this transaction (merge: new rows; replace: all
  /// valid rows after clearing).
  final int importedCount;

  /// Merge only: valid records skipped because their id already existed.
  final int skippedDuplicateCount;

  /// Valid records present in the source file.
  final int totalValidInFile;

  @override
  List<Object?> get props => <Object?>[
        strategy,
        importedCount,
        skippedDuplicateCount,
        totalValidInFile,
      ];
}
