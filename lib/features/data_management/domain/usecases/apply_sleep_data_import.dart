import '../entities/import_preview.dart';
import '../entities/import_strategy.dart';
import '../entities/import_summary.dart';
import '../exceptions/data_management_exception.dart';
import '../repositories/data_management_repository.dart';

/// Applies a confirmed import inside one transaction
/// (ARCHITECTURE §14.3 steps 7–9).
///
/// Merge inserts only new ids; replace clears existing sleep data first.
/// The single-active-session rule is enforced by the database and surfaced
/// as [DataManagementException.activeSessionConflict].
class ApplySleepDataImport {
  ApplySleepDataImport({required this.repository});

  final DataManagementRepository repository;

  Future<ImportSummary> call({
    required ImportPreview preview,
    required ImportStrategy strategy,
  }) async {
    switch (strategy) {
      case ImportStrategy.merge:
        if (preview.hasActiveConflict) {
          throw DataManagementException.activeSessionConflict;
        }
        final int written = await repository.insertMissing(
          preview.newSessions,
        );
        return ImportSummary(
          strategy: strategy,
          importedCount: written,
          skippedDuplicateCount: preview.duplicateCount,
          totalValidInFile: preview.validSessions.length,
        );
      case ImportStrategy.replace:
        await repository.replaceAll(preview.validSessions);
        return ImportSummary(
          strategy: strategy,
          importedCount: preview.validSessions.length,
          skippedDuplicateCount: 0,
          totalValidInFile: preview.validSessions.length,
        );
    }
  }
}
