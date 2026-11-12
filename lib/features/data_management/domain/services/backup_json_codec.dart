import 'dart:convert';

import '../../../sleep_session/domain/entities/sleep_session.dart';
import '../../../sleep_session/domain/entities/time_accuracy.dart';
import '../entities/import_preview.dart';
import '../exceptions/data_management_exception.dart';

/// Parses and validates a Frenooze JSON backup (ARCHITECTURE §14.1, §14.3).
///
/// Rejects unknown applications, unsupported backup versions, malformed
/// records, and files above [maxBytes]. Never executes content from the file.
class BackupJsonCodec {
  const BackupJsonCodec({this.maxBytes = 10 * 1024 * 1024});

  /// Upper bound on decoded input size (ARCHITECTURE §14.4).
  final int maxBytes;

  static const String applicationName = 'Frenooze';
  static const int backupVersion = 1;
  static const int maxSampleErrors = 8;

  /// Serializes [sessions] into a versioned backup document.
  String encode({
    required List<SleepSession> sessions,
    required DateTime exportedAtUtc,
  }) {
    final Map<String, Object?> document = <String, Object?>{
      'application': applicationName,
      'backup_version': backupVersion,
      'exported_at': exportedAtUtc.toUtc().toIso8601String(),
      'sessions': <Map<String, Object?>>[
        for (final SleepSession session in sessions)
          <String, Object?>{
            'id': session.id,
            'started_at_utc_ms': session.startedAtUtc.millisecondsSinceEpoch,
            'ended_at_utc_ms': session.endedAtUtc?.millisecondsSinceEpoch,
            'start_timezone': session.startTimezone,
            'end_timezone': session.endTimezone,
            'start_offset_minutes': session.startOffsetMinutes,
            'end_offset_minutes': session.endOffsetMinutes,
            'start_elapsed_ms': session.startElapsedMs,
            'end_elapsed_ms': session.endElapsedMs,
            'start_boot_count': session.startBootCount,
            'end_boot_count': session.endBootCount,
            'is_start_manual': session.isStartManual,
            'is_end_manual': session.isEndManual,
            'time_accuracy': session.accuracy.dbValue,
            'created_at_utc_ms': session.createdAtUtc.millisecondsSinceEpoch,
            'updated_at_utc_ms': session.updatedAtUtc.millisecondsSinceEpoch,
          },
      ],
    };
    return const JsonEncoder.withIndent('  ').convert(document);
  }

  /// Validates [rawJson] and returns every structurally valid session.
  ///
  /// Throws [DataManagementException] for file-level failures; record-level
  /// issues are collected into the returned preview instead of aborting.
  ImportPreview decode({
    required String rawJson,
    required Set<String> existingIds,
    required String? localActiveId,
  }) {
    if (rawJson.codeUnits.length > maxBytes) {
      throw DataManagementException.fileTooLarge;
    }

    final Object? decoded;
    try {
      decoded = jsonDecode(rawJson);
    } on FormatException {
      throw DataManagementException.invalidJson;
    } on Exception {
      throw DataManagementException.invalidJson;
    }

    if (decoded is! Map<String, Object?>) {
      throw DataManagementException.invalidStructure;
    }
    if (decoded['application'] != applicationName) {
      throw DataManagementException.invalidStructure;
    }

    final Object? version = decoded['backup_version'];
    if (version is! int || version != backupVersion) {
      throw DataManagementException.unsupportedVersion;
    }

    final Object? sessionsJson = decoded['sessions'];
    if (sessionsJson is! List<Object?>) {
      throw DataManagementException.invalidStructure;
    }

    final List<SleepSession> valid = <SleepSession>[];
    final List<String> errors = <String>[];
    int invalidCount = 0;

    for (final Object? raw in sessionsJson) {
      try {
        valid.add(_parseSession(raw));
      } on DataManagementException catch (error) {
        invalidCount += 1;
        if (errors.length < maxSampleErrors) {
          errors.add(error.message);
        }
      }
    }

    if (valid.isEmpty) {
      throw DataManagementException.noValidRecords;
    }

    return ImportPreview(
      validSessions: valid,
      existingIds: existingIds,
      localActiveId: localActiveId,
      invalidCount: invalidCount,
      sampleErrors: errors,
      totalInFile: sessionsJson.length,
    );
  }

  SleepSession _parseSession(Object? raw) {
    if (raw is! Map<String, Object?>) {
      throw const DataManagementException(
        'invalid_record',
        'Record bukan objek JSON yang valid.',
      );
    }

    final String id = _requireString(raw, 'id');
    final int startedAtMs = _requireInt(raw, 'started_at_utc_ms');
    final String startTimezone = _requireString(raw, 'start_timezone');
    final int startOffset = _requireInt(raw, 'start_offset_minutes');
    final int startElapsed = _requireInt(raw, 'start_elapsed_ms');
    final int startBoot = _requireInt(raw, 'start_boot_count');

    final int? endedAtMs = _optionalInt(raw, 'ended_at_utc_ms');
    final String? endTimezone = _optionalString(raw, 'end_timezone');
    final int? endOffset = _optionalInt(raw, 'end_offset_minutes');
    final int? endElapsed = _optionalInt(raw, 'end_elapsed_ms');
    final int? endBoot = _optionalInt(raw, 'end_boot_count');

    if (endedAtMs != null && endedAtMs <= startedAtMs) {
      throw const DataManagementException(
        'invalid_time_range',
        'Waktu bangun harus setelah waktu mulai.',
      );
    }

    final bool isStartManual = _optionalBool(raw, 'is_start_manual') ?? false;
    final bool isEndManual = _optionalBool(raw, 'is_end_manual') ?? false;
    final TimeAccuracy accuracy = TimeAccuracy.fromDb(
      _optionalString(raw, 'time_accuracy') ?? TimeAccuracy.ok.dbValue,
    );

    final int createdAtMs =
        _optionalInt(raw, 'created_at_utc_ms') ?? startedAtMs;
    final int updatedAtMs =
        _optionalInt(raw, 'updated_at_utc_ms') ?? createdAtMs;

    return SleepSession(
      id: id,
      startedAtUtc: DateTime.fromMillisecondsSinceEpoch(
        startedAtMs,
        isUtc: true,
      ),
      endedAtUtc: endedAtMs == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(endedAtMs, isUtc: true),
      startTimezone: startTimezone,
      endTimezone: endTimezone,
      startOffsetMinutes: startOffset,
      endOffsetMinutes: endOffset,
      startElapsedMs: startElapsed,
      endElapsedMs: endElapsed,
      startBootCount: startBoot,
      endBootCount: endBoot,
      isStartManual: isStartManual,
      isEndManual: isEndManual,
      accuracy: accuracy,
      createdAtUtc: DateTime.fromMillisecondsSinceEpoch(
        createdAtMs,
        isUtc: true,
      ),
      updatedAtUtc: DateTime.fromMillisecondsSinceEpoch(
        updatedAtMs,
        isUtc: true,
      ),
    );
  }

  String _requireString(Map<String, Object?> map, String key) {
    final Object? value = map[key];
    if (value is! String || value.isEmpty) {
      throw DataManagementException(
        'missing_$key',
        'Field "$key" wajib diisi.',
      );
    }
    return value;
  }

  int _requireInt(Map<String, Object?> map, String key) {
    final Object? value = map[key];
    if (value is! int) {
      throw DataManagementException(
        'missing_$key',
        'Field "$key" harus berupa angka.',
      );
    }
    return value;
  }

  String? _optionalString(Map<String, Object?> map, String key) {
    final Object? value = map[key];
    if (value == null) {
      return null;
    }
    if (value is! String) {
      throw DataManagementException(
        'invalid_$key',
        'Field "$key" harus berupa teks.',
      );
    }
    return value.isEmpty ? null : value;
  }

  int? _optionalInt(Map<String, Object?> map, String key) {
    final Object? value = map[key];
    if (value == null) {
      return null;
    }
    if (value is! int) {
      throw DataManagementException(
        'invalid_$key',
        'Field "$key" harus berupa angka.',
      );
    }
    return value;
  }

  bool? _optionalBool(Map<String, Object?> map, String key) {
    final Object? value = map[key];
    if (value == null) {
      return null;
    }
    if (value is! bool) {
      throw DataManagementException(
        'invalid_$key',
        'Field "$key" harus boolean.',
      );
    }
    return value;
  }
}
