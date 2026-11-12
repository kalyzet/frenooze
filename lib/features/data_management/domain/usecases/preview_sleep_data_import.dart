import '../entities/import_preview.dart';
import '../repositories/data_management_repository.dart';
import '../services/backup_json_codec.dart';

/// Reads, validates, and previews a backup before any write
/// (ARCHITECTURE §14.3 steps 1–6).
class PreviewSleepDataImport {
  PreviewSleepDataImport({
    required this.repository,
    this.codec = const BackupJsonCodec(),
  });

  final DataManagementRepository repository;
  final BackupJsonCodec codec;

  Future<ImportPreview> call(String rawJson) async {
    final Set<String> existingIds = await repository.getExistingIds();
    final String? activeId = await repository.getActiveSessionId();
    return codec.decode(
      rawJson: rawJson,
      existingIds: existingIds,
      localActiveId: activeId,
    );
  }
}
