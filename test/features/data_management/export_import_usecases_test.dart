import 'package:flutter_test/flutter_test.dart';
import 'package:frenooze/features/data_management/domain/entities/export_format.dart';
import 'package:frenooze/features/data_management/domain/entities/export_result.dart';
import 'package:frenooze/features/data_management/domain/entities/import_preview.dart';
import 'package:frenooze/features/data_management/domain/entities/import_strategy.dart';
import 'package:frenooze/features/data_management/domain/entities/import_summary.dart';
import 'package:frenooze/features/data_management/domain/exceptions/data_management_exception.dart';
import 'package:frenooze/features/data_management/domain/repositories/data_management_repository.dart';
import 'package:frenooze/features/data_management/domain/usecases/apply_sleep_data_import.dart';
import 'package:frenooze/features/data_management/domain/usecases/export_sleep_data.dart';
import 'package:frenooze/features/data_management/domain/usecases/preview_sleep_data_import.dart';
import 'package:frenooze/features/sleep_session/domain/entities/sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/entities/time_accuracy.dart';
import 'package:frenooze/features/sleep_session/domain/repositories/sleep_session_repository.dart';

SleepSession _session({
  String id = 's-1',
  DateTime? startedAtUtc,
  DateTime? endedAtUtc,
  bool active = false,
}) {
  final DateTime start = startedAtUtc ?? DateTime.utc(2026, 11, 11, 22);
  final DateTime? end =
      active ? null : (endedAtUtc ?? start.add(const Duration(hours: 8)));
  return SleepSession(
    id: id,
    startedAtUtc: start,
    endedAtUtc: end,
    startTimezone: 'Asia/Jakarta',
    endTimezone: active ? null : 'Asia/Jakarta',
    startOffsetMinutes: 420,
    endOffsetMinutes: active ? null : 420,
    startElapsedMs: 1000,
    endElapsedMs: active ? null : 1000 + 8 * 3600 * 1000,
    startBootCount: 1,
    endBootCount: active ? null : 1,
    accuracy: TimeAccuracy.ok,
    createdAtUtc: start,
    updatedAtUtc: end ?? start,
  );
}

class _SleepRepo implements SleepSessionRepository {
  _SleepRepo([List<SleepSession>? sessions]) : _sessions = sessions ?? [];

  final List<SleepSession> _sessions;

  @override
  Future<SleepSession?> getActiveSession() async =>
      _sessions.where((SleepSession s) => s.isActive).firstOrNull;

  @override
  Future<SleepSession?> getById(String id) async => _sessions
      .where((SleepSession s) => s.id == id)
      .cast<SleepSession?>()
      .firstOrNull;

  @override
  Future<List<SleepSession>> getAll() async => List<SleepSession>.unmodifiable(
        _sessions,
      );

  @override
  Future<void> insert(SleepSession session) async {
    _sessions.add(session);
  }

  @override
  Future<void> update(SleepSession session) async {
    final int index =
        _sessions.indexWhere((SleepSession s) => s.id == session.id);
    if (index >= 0) {
      _sessions[index] = session;
    }
  }

  @override
  Future<void> delete(String id) async {
    _sessions.removeWhere((SleepSession s) => s.id == id);
  }
}

class _DataRepo implements DataManagementRepository {
  _DataRepo({
    List<SleepSession>? sessions,
    this.activeId,
  }) : sessions = sessions ?? <SleepSession>[];

  final List<SleepSession> sessions;
  final String? activeId;
  List<SleepSession>? replacedWith;
  List<SleepSession>? inserted;

  @override
  Future<List<SleepSession>> getAllSessions() async =>
      List<SleepSession>.unmodifiable(sessions);

  @override
  Future<String?> getActiveSessionId() async => activeId;

  @override
  Future<Set<String>> getExistingIds() async =>
      sessions.map((SleepSession s) => s.id).toSet();

  @override
  Future<void> replaceAll(List<SleepSession> newSessions) async {
    replacedWith = newSessions;
  }

  @override
  Future<int> insertMissing(List<SleepSession> toInsert) async {
    inserted = toInsert;
    return toInsert.length;
  }
}

void main() {
  group('ExportSleepData', () {
    test('exports all sessions as JSON', () async {
      final _SleepRepo repo = _SleepRepo(<SleepSession>[
        _session(id: 'a'),
        _session(id: 'b', startedAtUtc: DateTime.utc(2026, 11, 10, 22)),
      ]);
      final ExportSleepData useCase = ExportSleepData(repository: repo);

      final ExportResult result =
          await useCase(format: ExportFormat.json);

      expect(result.format, ExportFormat.json);
      expect(result.recordCount, 2);
      expect(result.suggestedFileName, startsWith('frenooze_backup_'));
      expect(result.suggestedFileName, endsWith('.json'));
      expect(result.content, contains('"application": "Frenooze"'));
      expect(result.content, contains('"backup_version": 1'));
    });

    test('exports CSV with header', () async {
      final ExportSleepData useCase =
          ExportSleepData(repository: _SleepRepo(<SleepSession>[_session()]));

      final ExportResult result = await useCase(format: ExportFormat.csv);

      expect(result.suggestedFileName, endsWith('.csv'));
      expect(
        result.content.split('\n').first.trim(),
        'id,started_at,ended_at,start_timezone,end_timezone,'
        'duration_seconds,is_start_manual,is_end_manual',
      );
      expect(result.recordCount, 1);
    });

    test('filters by date range', () async {
      final _SleepRepo repo = _SleepRepo(<SleepSession>[
        _session(id: 'old', startedAtUtc: DateTime.utc(2026, 1, 1, 22)),
        _session(id: 'new', startedAtUtc: DateTime.utc(2026, 11, 11, 22)),
      ]);
      final ExportSleepData useCase = ExportSleepData(repository: repo);

      final ExportResult result = await useCase(
        format: ExportFormat.json,
        fromUtc: DateTime.utc(2026, 11, 1),
        toUtc: DateTime.utc(2026, 12, 1),
      );

      expect(result.recordCount, 1);
      expect(result.content, contains('"id": "new"'));
      expect(result.content, isNot(contains('"id": "old"')));
    });
  });

  group('PreviewSleepDataImport', () {
    test('decodes using existing ids and active id', () async {
      final _SleepRepo sleepRepo = _SleepRepo(<SleepSession>[
        _session(id: 'existing'),
      ]);
      final _DataRepo dataRepo = _DataRepo(
        sessions: <SleepSession>[_session(id: 'existing')],
        activeId: null,
      );
      final ExportSleepData exporter =
          ExportSleepData(repository: sleepRepo);
      final ExportResult backup =
          await exporter(format: ExportFormat.json);

      final PreviewSleepDataImport preview =
          PreviewSleepDataImport(repository: dataRepo);
      final result = await preview(backup.content);

      expect(result.validSessions, hasLength(1));
      expect(result.duplicateCount, 1);
      expect(result.newSessions, isEmpty);
      expect(result.hasNewRecords, isFalse);
    });
  });

  group('ApplySleepDataImport', () {
    test('merge inserts only new sessions', () async {
      // Backup has id 'a' and 'b'; local only has 'existing'.
      final _SleepRepo sleepRepo = _SleepRepo(<SleepSession>[
        _session(id: 'a'),
        _session(id: 'b', startedAtUtc: DateTime.utc(2026, 11, 10, 22)),
      ]);
      final _DataRepo dataRepo = _DataRepo(
        sessions: <SleepSession>[_session(id: 'existing')],
      );
      final ExportSleepData exporter =
          ExportSleepData(repository: sleepRepo);
      final ExportResult backup =
          await exporter(format: ExportFormat.json);

      final ImportPreview preview =
          await PreviewSleepDataImport(repository: dataRepo)(backup.content);
      expect(preview.newSessions, hasLength(2));
      expect(preview.duplicateCount, 0);

      final ImportSummary result = await ApplySleepDataImport(
        repository: dataRepo,
      )(preview: preview, strategy: ImportStrategy.merge);

      expect(result.strategy, ImportStrategy.merge);
      expect(result.importedCount, 2);
      expect(result.skippedDuplicateCount, 0);
      expect(dataRepo.inserted, hasLength(2));
    });

    test('replace overwrites all sessions', () async {
      final _DataRepo dataRepo = _DataRepo(
        sessions: <SleepSession>[_session(id: 'old')],
      );
      final _SleepRepo sleepRepo = _SleepRepo(<SleepSession>[
        _session(id: 'a'),
        _session(id: 'b', startedAtUtc: DateTime.utc(2026, 11, 10, 22)),
      ]);
      final ExportSleepData exporter =
          ExportSleepData(repository: sleepRepo);
      final ExportResult backup =
          await exporter(format: ExportFormat.json);

      final ImportPreview preview =
          await PreviewSleepDataImport(repository: dataRepo)(backup.content);
      final ImportSummary result = await ApplySleepDataImport(
        repository: dataRepo,
      )(preview: preview, strategy: ImportStrategy.replace);

      expect(result.strategy, ImportStrategy.replace);
      expect(result.importedCount, 2);
      expect(result.skippedDuplicateCount, 0);
      expect(dataRepo.replacedWith, hasLength(2));
    });

    test('merge rejects active session conflict', () async {
      final _DataRepo dataRepo =
          _DataRepo(activeId: 'local-active');
      // Preview that has a different active session in the file.
      final SleepSession fileActive = _session(id: 'file-active', active: true);
      final ImportPreview preview = ImportPreview(
        validSessions: <SleepSession>[fileActive],
        existingIds: <String>{},
        localActiveId: 'local-active',
        invalidCount: 0,
        sampleErrors: <String>[],
        totalInFile: 1,
      );

      await expectLater(
        ApplySleepDataImport(repository: dataRepo)(
          preview: preview,
          strategy: ImportStrategy.merge,
        ),
        throwsA(DataManagementException.activeSessionConflict),
      );
    });
  });
}
