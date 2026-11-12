import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:frenooze/features/data_management/domain/entities/import_preview.dart';
import 'package:frenooze/features/data_management/domain/exceptions/data_management_exception.dart';
import 'package:frenooze/features/data_management/domain/services/backup_json_codec.dart';
import 'package:frenooze/features/sleep_session/domain/entities/sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/entities/time_accuracy.dart';

SleepSession _session({
  String id = 's-1',
  DateTime? startedAtUtc,
  DateTime? endedAtUtc,
  bool active = false,
}) {
  final DateTime start = startedAtUtc ?? DateTime.utc(2026, 11, 11, 22);
  final DateTime? end = active ? null : (endedAtUtc ?? start.add(const Duration(hours: 8)));
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
    isStartManual: false,
    isEndManual: false,
    accuracy: TimeAccuracy.ok,
    createdAtUtc: start,
    updatedAtUtc: end ?? start,
  );
}

void main() {
  const BackupJsonCodec codec = BackupJsonCodec();

  group('BackupJsonCodec.encode', () {
    test('round-trips a completed session', () {
      final SleepSession original = _session();
      final String json = codec.encode(
        sessions: <SleepSession>[original],
        exportedAtUtc: DateTime.utc(2026, 11, 12),
      );

      final ImportPreview preview = codec.decode(
        rawJson: json,
        existingIds: <String>{},
        localActiveId: null,
      );

      expect(preview.validSessions, hasLength(1));
      final SleepSession decoded = preview.validSessions.single;
      expect(decoded.id, original.id);
      expect(decoded.startedAtUtc, original.startedAtUtc);
      expect(decoded.endedAtUtc, original.endedAtUtc);
      expect(decoded.startTimezone, original.startTimezone);
      expect(decoded.accuracy, TimeAccuracy.ok);
      expect(preview.totalInFile, 1);
      expect(preview.invalidCount, 0);
    });

    test('includes application and backup_version', () {
      final String json = codec.encode(
        sessions: <SleepSession>[_session()],
        exportedAtUtc: DateTime.utc(2026),
      );
      final Object? decoded = jsonDecode(json);
      expect(decoded, isA<Map<String, Object?>>());
      final Map<String, Object?> map = decoded! as Map<String, Object?>;
      expect(map['application'], 'Frenooze');
      expect(map['backup_version'], 1);
      expect(map['exported_at'], isNotNull);
    });
  });

  group('BackupJsonCodec.decode validation', () {
    test('rejects non-Frenooze application', () {
      expect(
        () => codec.decode(
          rawJson: '{"application":"Other","backup_version":1,"sessions":[]}',
          existingIds: <String>{},
          localActiveId: null,
        ),
        throwsA(DataManagementException.invalidStructure),
      );
    });

    test('rejects unsupported backup version', () {
      expect(
        () => codec.decode(
          rawJson: '{"application":"Frenooze","backup_version":99,"sessions":[]}',
          existingIds: <String>{},
          localActiveId: null,
        ),
        throwsA(DataManagementException.unsupportedVersion),
      );
    });

    test('rejects invalid JSON', () {
      expect(
        () => codec.decode(
          rawJson: 'not-json',
          existingIds: <String>{},
          localActiveId: null,
        ),
        throwsA(DataManagementException.invalidJson),
      );
    });

    test('rejects empty sessions array', () {
      expect(
        () => codec.decode(
          rawJson: '{"application":"Frenooze","backup_version":1,"sessions":[]}',
          existingIds: <String>{},
          localActiveId: null,
        ),
        throwsA(DataManagementException.noValidRecords),
      );
    });

    test('rejects oversized file', () {
      const BackupJsonCodec small = BackupJsonCodec(maxBytes: 10);
      expect(
        () => small.decode(
          rawJson: '{"application":"Frenooze","backup_version":1,"sessions":[]}',
          existingIds: <String>{},
          localActiveId: null,
        ),
        throwsA(DataManagementException.fileTooLarge),
      );
    });

    test('skips invalid records and counts them', () {
      final Map<String, Object?> goodSession = <String, Object?>{
        'id': 'good',
        'started_at_utc_ms': DateTime.utc(2026, 11, 11, 22).millisecondsSinceEpoch,
        'ended_at_utc_ms': DateTime.utc(2026, 11, 12, 6).millisecondsSinceEpoch,
        'start_timezone': 'Asia/Jakarta',
        'end_timezone': 'Asia/Jakarta',
        'start_offset_minutes': 420,
        'end_offset_minutes': 420,
        'start_elapsed_ms': 0,
        'end_elapsed_ms': 8 * 3600 * 1000,
        'start_boot_count': 1,
        'end_boot_count': 1,
      };
      final String json = '''
{
  "application": "Frenooze",
  "backup_version": 1,
  "exported_at": "2026-11-12T00:00:00.000Z",
  "sessions": [
    {"id": "bad"},
    ${jsonEncode(goodSession)}
  ]
}
''';

      final ImportPreview preview = codec.decode(
        rawJson: json,
        existingIds: <String>{},
        localActiveId: null,
      );

      expect(preview.validSessions, hasLength(1));
      expect(preview.invalidCount, 1);
      expect(preview.totalInFile, 2);
      expect(preview.sampleErrors, isNotEmpty);
    });

    test('rejects end <= start', () {
      final String json = jsonEncode(<String, Object?>{
        'application': 'Frenooze',
        'backup_version': 1,
        'sessions': <Object?>[
          <String, Object?>{
            'id': 'bad-time',
            'started_at_utc_ms': DateTime.utc(2026, 1, 2, 6).millisecondsSinceEpoch,
            'ended_at_utc_ms': DateTime.utc(2026, 1, 1, 22).millisecondsSinceEpoch,
            'start_timezone': 'Asia/Jakarta',
            'start_offset_minutes': 420,
            'start_elapsed_ms': 0,
            'start_boot_count': 1,
          },
        ],
      });

      expect(
        () => codec.decode(
          rawJson: json,
          existingIds: <String>{},
          localActiveId: null,
        ),
        throwsA(DataManagementException.noValidRecords),
      );
    });
  });

  group('ImportPreview derived fields', () {
    test('separates new vs duplicate ids', () {
      final SleepSession s1 = _session(id: 'existing');
      final SleepSession s2 = _session(id: 'new');

      final ImportPreview preview = ImportPreview(
        validSessions: <SleepSession>[s1, s2],
        existingIds: <String>{'existing'},
        localActiveId: null,
        invalidCount: 0,
        sampleErrors: <String>[],
        totalInFile: 2,
      );

      expect(preview.newSessions.single.id, 'new');
      expect(preview.duplicateCount, 1);
      expect(preview.hasNewRecords, isTrue);
    });

    test('detects active-session conflict for merge', () {
      final SleepSession fileActive = _session(id: 'file-active', active: true);

      final ImportPreview conflict = ImportPreview(
        validSessions: <SleepSession>[fileActive],
        existingIds: <String>{},
        localActiveId: 'local-active',
        invalidCount: 0,
        sampleErrors: <String>[],
        totalInFile: 1,
      );
      expect(conflict.hasActiveConflict, isTrue);

      final ImportPreview sameActive = ImportPreview(
        validSessions: <SleepSession>[
          _session(id: 'local-active', active: true),
        ],
        existingIds: <String>{},
        localActiveId: 'local-active',
        invalidCount: 0,
        sampleErrors: <String>[],
        totalInFile: 1,
      );
      expect(sameActive.hasActiveConflict, isFalse);

      final ImportPreview noLocal = ImportPreview(
        validSessions: <SleepSession>[fileActive],
        existingIds: <String>{},
        localActiveId: null,
        invalidCount: 0,
        sampleErrors: <String>[],
        totalInFile: 1,
      );
      expect(noLocal.hasActiveConflict, isFalse);
    });
  });
}
