import 'package:drift/drift.dart';

import 'package:frenooze/core/database/app_database.dart';

import '../../domain/entities/sleep_session.dart';
import '../../domain/entities/time_accuracy.dart';

/// Maps a generated [SleepSessionRow] to the domain entity.
extension SleepSessionRowMapper on SleepSessionRow {
  SleepSession toEntity() => SleepSession(
        id: id,
        startedAtUtc: DateTime.fromMillisecondsSinceEpoch(
          startedAtUtcMs,
          isUtc: true,
        ),
        endedAtUtc: endedAtUtcMs == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(
                endedAtUtcMs!,
                isUtc: true,
              ),
        startTimezone: startTimezone,
        endTimezone: endTimezone,
        startOffsetMinutes: startOffsetMinutes,
        endOffsetMinutes: endOffsetMinutes,
        startElapsedMs: startElapsedMs,
        endElapsedMs: endElapsedMs,
        startBootCount: startBootCount,
        endBootCount: endBootCount,
        isStartManual: isStartManual,
        isEndManual: isEndManual,
        accuracy: TimeAccuracy.fromDb(timeAccuracyStatus),
        createdAtUtc: DateTime.fromMillisecondsSinceEpoch(
          createdAtUtcMs,
          isUtc: true,
        ),
        updatedAtUtc: DateTime.fromMillisecondsSinceEpoch(
          updatedAtUtcMs,
          isUtc: true,
        ),
      );
}

/// Maps the domain entity to a [SleepSessionsCompanion] for insert/update.
extension SleepSessionCompanionMapper on SleepSession {
  SleepSessionsCompanion toCompanion() => SleepSessionsCompanion(
        id: Value<String>(id),
        startedAtUtcMs: Value<int>(startedAtUtc.millisecondsSinceEpoch),
        endedAtUtcMs: Value<int?>(
          endedAtUtc?.millisecondsSinceEpoch,
        ),
        startTimezone: Value<String>(startTimezone),
        endTimezone: Value<String?>(endTimezone),
        startOffsetMinutes: Value<int>(startOffsetMinutes),
        endOffsetMinutes: Value<int?>(endOffsetMinutes),
        startElapsedMs: Value<int>(startElapsedMs),
        endElapsedMs: Value<int?>(endElapsedMs),
        startBootCount: Value<int>(startBootCount),
        endBootCount: Value<int?>(endBootCount),
        isStartManual: Value<bool>(isStartManual),
        isEndManual: Value<bool>(isEndManual),
        timeAccuracyStatus: Value<String>(accuracy.dbValue),
        createdAtUtcMs: Value<int>(createdAtUtc.millisecondsSinceEpoch),
        updatedAtUtcMs: Value<int>(updatedAtUtc.millisecondsSinceEpoch),
      );
}
