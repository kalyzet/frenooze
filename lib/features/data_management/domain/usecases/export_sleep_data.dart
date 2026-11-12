import 'package:frenooze/core/time/clock_provider.dart';

import '../../../sleep_session/domain/entities/sleep_session.dart';
import '../../../sleep_session/domain/repositories/sleep_session_repository.dart';
import '../entities/export_format.dart';
import '../entities/export_result.dart';
import '../services/backup_csv_codec.dart';
import '../services/backup_json_codec.dart';

/// Builds an offline export payload from stored sessions (PRD §4.9).
///
/// Supports JSON (full backup) and CSV (analysis only). When [fromUtc] /
/// [toUtc] are provided, only sessions whose start falls inside the closed
/// range are included; both null means export all records.
class ExportSleepData {
  ExportSleepData({
    required this.repository,
    this.jsonCodec = const BackupJsonCodec(),
    this.csvCodec = const BackupCsvCodec(),
    this.clock = const SystemClockProvider(),
  });

  final SleepSessionRepository repository;
  final BackupJsonCodec jsonCodec;
  final BackupCsvCodec csvCodec;
  final ClockProvider clock;

  Future<ExportResult> call({
    required ExportFormat format,
    DateTime? fromUtc,
    DateTime? toUtc,
  }) async {
    final List<SleepSession> all = await repository.getAll();
    final List<SleepSession> sessions = _filter(all, fromUtc, toUtc);

    final DateTime now = clock.nowUtc();
    final String stamp = _fileStamp(now);

    switch (format) {
      case ExportFormat.json:
        return ExportResult(
          format: format,
          content: jsonCodec.encode(
            sessions: sessions,
            exportedAtUtc: now,
          ),
          suggestedFileName: 'frenooze_backup_$stamp.json',
          recordCount: sessions.length,
        );
      case ExportFormat.csv:
        return ExportResult(
          format: format,
          content: csvCodec.encode(sessions),
          suggestedFileName: 'frenooze_sleep_$stamp.csv',
          recordCount: sessions.length,
        );
    }
  }

  List<SleepSession> _filter(
    List<SleepSession> sessions,
    DateTime? fromUtc,
    DateTime? toUtc,
  ) {
    if (fromUtc == null && toUtc == null) {
      return sessions;
    }
    return sessions.where((SleepSession session) {
      final DateTime start = session.startedAtUtc;
      if (fromUtc != null && start.isBefore(fromUtc)) {
        return false;
      }
      if (toUtc != null && start.isAfter(toUtc)) {
        return false;
      }
      return true;
    }).toList(growable: false);
  }

  String _fileStamp(DateTime utc) {
    final String y = utc.year.toString().padLeft(4, '0');
    final String m = utc.month.toString().padLeft(2, '0');
    final String d = utc.day.toString().padLeft(2, '0');
    final String h = utc.hour.toString().padLeft(2, '0');
    final String min = utc.minute.toString().padLeft(2, '0');
    return '$y$m${d}_$h$min';
  }
}
