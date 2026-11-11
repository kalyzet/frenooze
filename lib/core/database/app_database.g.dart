// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SleepSessionsTable extends SleepSessions
    with TableInfo<$SleepSessionsTable, SleepSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SleepSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtUtcMsMeta = const VerificationMeta(
    'startedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> startedAtUtcMs = GeneratedColumn<int>(
    'started_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtUtcMsMeta = const VerificationMeta(
    'endedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> endedAtUtcMs = GeneratedColumn<int>(
    'ended_at_utc_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimezoneMeta = const VerificationMeta(
    'startTimezone',
  );
  @override
  late final GeneratedColumn<String> startTimezone = GeneratedColumn<String>(
    'start_timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimezoneMeta = const VerificationMeta(
    'endTimezone',
  );
  @override
  late final GeneratedColumn<String> endTimezone = GeneratedColumn<String>(
    'end_timezone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startOffsetMinutesMeta =
      const VerificationMeta('startOffsetMinutes');
  @override
  late final GeneratedColumn<int> startOffsetMinutes = GeneratedColumn<int>(
    'start_offset_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endOffsetMinutesMeta = const VerificationMeta(
    'endOffsetMinutes',
  );
  @override
  late final GeneratedColumn<int> endOffsetMinutes = GeneratedColumn<int>(
    'end_offset_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startElapsedMsMeta = const VerificationMeta(
    'startElapsedMs',
  );
  @override
  late final GeneratedColumn<int> startElapsedMs = GeneratedColumn<int>(
    'start_elapsed_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endElapsedMsMeta = const VerificationMeta(
    'endElapsedMs',
  );
  @override
  late final GeneratedColumn<int> endElapsedMs = GeneratedColumn<int>(
    'end_elapsed_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startBootCountMeta = const VerificationMeta(
    'startBootCount',
  );
  @override
  late final GeneratedColumn<int> startBootCount = GeneratedColumn<int>(
    'start_boot_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endBootCountMeta = const VerificationMeta(
    'endBootCount',
  );
  @override
  late final GeneratedColumn<int> endBootCount = GeneratedColumn<int>(
    'end_boot_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isStartManualMeta = const VerificationMeta(
    'isStartManual',
  );
  @override
  late final GeneratedColumn<bool> isStartManual = GeneratedColumn<bool>(
    'is_start_manual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_start_manual" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isEndManualMeta = const VerificationMeta(
    'isEndManual',
  );
  @override
  late final GeneratedColumn<bool> isEndManual = GeneratedColumn<bool>(
    'is_end_manual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_end_manual" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _timeAccuracyStatusMeta =
      const VerificationMeta('timeAccuracyStatus');
  @override
  late final GeneratedColumn<String> timeAccuracyStatus =
      GeneratedColumn<String>(
        'time_accuracy_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('ok'),
      );
  static const VerificationMeta _createdAtUtcMsMeta = const VerificationMeta(
    'createdAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> createdAtUtcMs = GeneratedColumn<int>(
    'created_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMsMeta = const VerificationMeta(
    'updatedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtcMs = GeneratedColumn<int>(
    'updated_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startedAtUtcMs,
    endedAtUtcMs,
    startTimezone,
    endTimezone,
    startOffsetMinutes,
    endOffsetMinutes,
    startElapsedMs,
    endElapsedMs,
    startBootCount,
    endBootCount,
    isStartManual,
    isEndManual,
    timeAccuracyStatus,
    createdAtUtcMs,
    updatedAtUtcMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sleep_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SleepSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('started_at_utc_ms')) {
      context.handle(
        _startedAtUtcMsMeta,
        startedAtUtcMs.isAcceptableOrUnknown(
          data['started_at_utc_ms']!,
          _startedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startedAtUtcMsMeta);
    }
    if (data.containsKey('ended_at_utc_ms')) {
      context.handle(
        _endedAtUtcMsMeta,
        endedAtUtcMs.isAcceptableOrUnknown(
          data['ended_at_utc_ms']!,
          _endedAtUtcMsMeta,
        ),
      );
    }
    if (data.containsKey('start_timezone')) {
      context.handle(
        _startTimezoneMeta,
        startTimezone.isAcceptableOrUnknown(
          data['start_timezone']!,
          _startTimezoneMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startTimezoneMeta);
    }
    if (data.containsKey('end_timezone')) {
      context.handle(
        _endTimezoneMeta,
        endTimezone.isAcceptableOrUnknown(
          data['end_timezone']!,
          _endTimezoneMeta,
        ),
      );
    }
    if (data.containsKey('start_offset_minutes')) {
      context.handle(
        _startOffsetMinutesMeta,
        startOffsetMinutes.isAcceptableOrUnknown(
          data['start_offset_minutes']!,
          _startOffsetMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startOffsetMinutesMeta);
    }
    if (data.containsKey('end_offset_minutes')) {
      context.handle(
        _endOffsetMinutesMeta,
        endOffsetMinutes.isAcceptableOrUnknown(
          data['end_offset_minutes']!,
          _endOffsetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('start_elapsed_ms')) {
      context.handle(
        _startElapsedMsMeta,
        startElapsedMs.isAcceptableOrUnknown(
          data['start_elapsed_ms']!,
          _startElapsedMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startElapsedMsMeta);
    }
    if (data.containsKey('end_elapsed_ms')) {
      context.handle(
        _endElapsedMsMeta,
        endElapsedMs.isAcceptableOrUnknown(
          data['end_elapsed_ms']!,
          _endElapsedMsMeta,
        ),
      );
    }
    if (data.containsKey('start_boot_count')) {
      context.handle(
        _startBootCountMeta,
        startBootCount.isAcceptableOrUnknown(
          data['start_boot_count']!,
          _startBootCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startBootCountMeta);
    }
    if (data.containsKey('end_boot_count')) {
      context.handle(
        _endBootCountMeta,
        endBootCount.isAcceptableOrUnknown(
          data['end_boot_count']!,
          _endBootCountMeta,
        ),
      );
    }
    if (data.containsKey('is_start_manual')) {
      context.handle(
        _isStartManualMeta,
        isStartManual.isAcceptableOrUnknown(
          data['is_start_manual']!,
          _isStartManualMeta,
        ),
      );
    }
    if (data.containsKey('is_end_manual')) {
      context.handle(
        _isEndManualMeta,
        isEndManual.isAcceptableOrUnknown(
          data['is_end_manual']!,
          _isEndManualMeta,
        ),
      );
    }
    if (data.containsKey('time_accuracy_status')) {
      context.handle(
        _timeAccuracyStatusMeta,
        timeAccuracyStatus.isAcceptableOrUnknown(
          data['time_accuracy_status']!,
          _timeAccuracyStatusMeta,
        ),
      );
    }
    if (data.containsKey('created_at_utc_ms')) {
      context.handle(
        _createdAtUtcMsMeta,
        createdAtUtcMs.isAcceptableOrUnknown(
          data['created_at_utc_ms']!,
          _createdAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMsMeta);
    }
    if (data.containsKey('updated_at_utc_ms')) {
      context.handle(
        _updatedAtUtcMsMeta,
        updatedAtUtcMs.isAcceptableOrUnknown(
          data['updated_at_utc_ms']!,
          _updatedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SleepSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SleepSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at_utc_ms'],
      )!,
      endedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at_utc_ms'],
      ),
      startTimezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_timezone'],
      )!,
      endTimezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_timezone'],
      ),
      startOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_offset_minutes'],
      )!,
      endOffsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_offset_minutes'],
      ),
      startElapsedMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_elapsed_ms'],
      )!,
      endElapsedMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_elapsed_ms'],
      ),
      startBootCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_boot_count'],
      )!,
      endBootCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_boot_count'],
      ),
      isStartManual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_start_manual'],
      )!,
      isEndManual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_end_manual'],
      )!,
      timeAccuracyStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_accuracy_status'],
      )!,
      createdAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc_ms'],
      )!,
      updatedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_ms'],
      )!,
    );
  }

  @override
  $SleepSessionsTable createAlias(String alias) {
    return $SleepSessionsTable(attachedDatabase, alias);
  }
}

class SleepSessionRow extends DataClass implements Insertable<SleepSessionRow> {
  final String id;
  final int startedAtUtcMs;
  final int? endedAtUtcMs;
  final String startTimezone;
  final String? endTimezone;
  final int startOffsetMinutes;
  final int? endOffsetMinutes;
  final int startElapsedMs;
  final int? endElapsedMs;
  final int startBootCount;
  final int? endBootCount;
  final bool isStartManual;
  final bool isEndManual;
  final String timeAccuracyStatus;
  final int createdAtUtcMs;
  final int updatedAtUtcMs;
  const SleepSessionRow({
    required this.id,
    required this.startedAtUtcMs,
    this.endedAtUtcMs,
    required this.startTimezone,
    this.endTimezone,
    required this.startOffsetMinutes,
    this.endOffsetMinutes,
    required this.startElapsedMs,
    this.endElapsedMs,
    required this.startBootCount,
    this.endBootCount,
    required this.isStartManual,
    required this.isEndManual,
    required this.timeAccuracyStatus,
    required this.createdAtUtcMs,
    required this.updatedAtUtcMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['started_at_utc_ms'] = Variable<int>(startedAtUtcMs);
    if (!nullToAbsent || endedAtUtcMs != null) {
      map['ended_at_utc_ms'] = Variable<int>(endedAtUtcMs);
    }
    map['start_timezone'] = Variable<String>(startTimezone);
    if (!nullToAbsent || endTimezone != null) {
      map['end_timezone'] = Variable<String>(endTimezone);
    }
    map['start_offset_minutes'] = Variable<int>(startOffsetMinutes);
    if (!nullToAbsent || endOffsetMinutes != null) {
      map['end_offset_minutes'] = Variable<int>(endOffsetMinutes);
    }
    map['start_elapsed_ms'] = Variable<int>(startElapsedMs);
    if (!nullToAbsent || endElapsedMs != null) {
      map['end_elapsed_ms'] = Variable<int>(endElapsedMs);
    }
    map['start_boot_count'] = Variable<int>(startBootCount);
    if (!nullToAbsent || endBootCount != null) {
      map['end_boot_count'] = Variable<int>(endBootCount);
    }
    map['is_start_manual'] = Variable<bool>(isStartManual);
    map['is_end_manual'] = Variable<bool>(isEndManual);
    map['time_accuracy_status'] = Variable<String>(timeAccuracyStatus);
    map['created_at_utc_ms'] = Variable<int>(createdAtUtcMs);
    map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs);
    return map;
  }

  SleepSessionsCompanion toCompanion(bool nullToAbsent) {
    return SleepSessionsCompanion(
      id: Value(id),
      startedAtUtcMs: Value(startedAtUtcMs),
      endedAtUtcMs: endedAtUtcMs == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAtUtcMs),
      startTimezone: Value(startTimezone),
      endTimezone: endTimezone == null && nullToAbsent
          ? const Value.absent()
          : Value(endTimezone),
      startOffsetMinutes: Value(startOffsetMinutes),
      endOffsetMinutes: endOffsetMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(endOffsetMinutes),
      startElapsedMs: Value(startElapsedMs),
      endElapsedMs: endElapsedMs == null && nullToAbsent
          ? const Value.absent()
          : Value(endElapsedMs),
      startBootCount: Value(startBootCount),
      endBootCount: endBootCount == null && nullToAbsent
          ? const Value.absent()
          : Value(endBootCount),
      isStartManual: Value(isStartManual),
      isEndManual: Value(isEndManual),
      timeAccuracyStatus: Value(timeAccuracyStatus),
      createdAtUtcMs: Value(createdAtUtcMs),
      updatedAtUtcMs: Value(updatedAtUtcMs),
    );
  }

  factory SleepSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SleepSessionRow(
      id: serializer.fromJson<String>(json['id']),
      startedAtUtcMs: serializer.fromJson<int>(json['startedAtUtcMs']),
      endedAtUtcMs: serializer.fromJson<int?>(json['endedAtUtcMs']),
      startTimezone: serializer.fromJson<String>(json['startTimezone']),
      endTimezone: serializer.fromJson<String?>(json['endTimezone']),
      startOffsetMinutes: serializer.fromJson<int>(json['startOffsetMinutes']),
      endOffsetMinutes: serializer.fromJson<int?>(json['endOffsetMinutes']),
      startElapsedMs: serializer.fromJson<int>(json['startElapsedMs']),
      endElapsedMs: serializer.fromJson<int?>(json['endElapsedMs']),
      startBootCount: serializer.fromJson<int>(json['startBootCount']),
      endBootCount: serializer.fromJson<int?>(json['endBootCount']),
      isStartManual: serializer.fromJson<bool>(json['isStartManual']),
      isEndManual: serializer.fromJson<bool>(json['isEndManual']),
      timeAccuracyStatus: serializer.fromJson<String>(
        json['timeAccuracyStatus'],
      ),
      createdAtUtcMs: serializer.fromJson<int>(json['createdAtUtcMs']),
      updatedAtUtcMs: serializer.fromJson<int>(json['updatedAtUtcMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startedAtUtcMs': serializer.toJson<int>(startedAtUtcMs),
      'endedAtUtcMs': serializer.toJson<int?>(endedAtUtcMs),
      'startTimezone': serializer.toJson<String>(startTimezone),
      'endTimezone': serializer.toJson<String?>(endTimezone),
      'startOffsetMinutes': serializer.toJson<int>(startOffsetMinutes),
      'endOffsetMinutes': serializer.toJson<int?>(endOffsetMinutes),
      'startElapsedMs': serializer.toJson<int>(startElapsedMs),
      'endElapsedMs': serializer.toJson<int?>(endElapsedMs),
      'startBootCount': serializer.toJson<int>(startBootCount),
      'endBootCount': serializer.toJson<int?>(endBootCount),
      'isStartManual': serializer.toJson<bool>(isStartManual),
      'isEndManual': serializer.toJson<bool>(isEndManual),
      'timeAccuracyStatus': serializer.toJson<String>(timeAccuracyStatus),
      'createdAtUtcMs': serializer.toJson<int>(createdAtUtcMs),
      'updatedAtUtcMs': serializer.toJson<int>(updatedAtUtcMs),
    };
  }

  SleepSessionRow copyWith({
    String? id,
    int? startedAtUtcMs,
    Value<int?> endedAtUtcMs = const Value.absent(),
    String? startTimezone,
    Value<String?> endTimezone = const Value.absent(),
    int? startOffsetMinutes,
    Value<int?> endOffsetMinutes = const Value.absent(),
    int? startElapsedMs,
    Value<int?> endElapsedMs = const Value.absent(),
    int? startBootCount,
    Value<int?> endBootCount = const Value.absent(),
    bool? isStartManual,
    bool? isEndManual,
    String? timeAccuracyStatus,
    int? createdAtUtcMs,
    int? updatedAtUtcMs,
  }) => SleepSessionRow(
    id: id ?? this.id,
    startedAtUtcMs: startedAtUtcMs ?? this.startedAtUtcMs,
    endedAtUtcMs: endedAtUtcMs.present ? endedAtUtcMs.value : this.endedAtUtcMs,
    startTimezone: startTimezone ?? this.startTimezone,
    endTimezone: endTimezone.present ? endTimezone.value : this.endTimezone,
    startOffsetMinutes: startOffsetMinutes ?? this.startOffsetMinutes,
    endOffsetMinutes: endOffsetMinutes.present
        ? endOffsetMinutes.value
        : this.endOffsetMinutes,
    startElapsedMs: startElapsedMs ?? this.startElapsedMs,
    endElapsedMs: endElapsedMs.present ? endElapsedMs.value : this.endElapsedMs,
    startBootCount: startBootCount ?? this.startBootCount,
    endBootCount: endBootCount.present ? endBootCount.value : this.endBootCount,
    isStartManual: isStartManual ?? this.isStartManual,
    isEndManual: isEndManual ?? this.isEndManual,
    timeAccuracyStatus: timeAccuracyStatus ?? this.timeAccuracyStatus,
    createdAtUtcMs: createdAtUtcMs ?? this.createdAtUtcMs,
    updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
  );
  SleepSessionRow copyWithCompanion(SleepSessionsCompanion data) {
    return SleepSessionRow(
      id: data.id.present ? data.id.value : this.id,
      startedAtUtcMs: data.startedAtUtcMs.present
          ? data.startedAtUtcMs.value
          : this.startedAtUtcMs,
      endedAtUtcMs: data.endedAtUtcMs.present
          ? data.endedAtUtcMs.value
          : this.endedAtUtcMs,
      startTimezone: data.startTimezone.present
          ? data.startTimezone.value
          : this.startTimezone,
      endTimezone: data.endTimezone.present
          ? data.endTimezone.value
          : this.endTimezone,
      startOffsetMinutes: data.startOffsetMinutes.present
          ? data.startOffsetMinutes.value
          : this.startOffsetMinutes,
      endOffsetMinutes: data.endOffsetMinutes.present
          ? data.endOffsetMinutes.value
          : this.endOffsetMinutes,
      startElapsedMs: data.startElapsedMs.present
          ? data.startElapsedMs.value
          : this.startElapsedMs,
      endElapsedMs: data.endElapsedMs.present
          ? data.endElapsedMs.value
          : this.endElapsedMs,
      startBootCount: data.startBootCount.present
          ? data.startBootCount.value
          : this.startBootCount,
      endBootCount: data.endBootCount.present
          ? data.endBootCount.value
          : this.endBootCount,
      isStartManual: data.isStartManual.present
          ? data.isStartManual.value
          : this.isStartManual,
      isEndManual: data.isEndManual.present
          ? data.isEndManual.value
          : this.isEndManual,
      timeAccuracyStatus: data.timeAccuracyStatus.present
          ? data.timeAccuracyStatus.value
          : this.timeAccuracyStatus,
      createdAtUtcMs: data.createdAtUtcMs.present
          ? data.createdAtUtcMs.value
          : this.createdAtUtcMs,
      updatedAtUtcMs: data.updatedAtUtcMs.present
          ? data.updatedAtUtcMs.value
          : this.updatedAtUtcMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SleepSessionRow(')
          ..write('id: $id, ')
          ..write('startedAtUtcMs: $startedAtUtcMs, ')
          ..write('endedAtUtcMs: $endedAtUtcMs, ')
          ..write('startTimezone: $startTimezone, ')
          ..write('endTimezone: $endTimezone, ')
          ..write('startOffsetMinutes: $startOffsetMinutes, ')
          ..write('endOffsetMinutes: $endOffsetMinutes, ')
          ..write('startElapsedMs: $startElapsedMs, ')
          ..write('endElapsedMs: $endElapsedMs, ')
          ..write('startBootCount: $startBootCount, ')
          ..write('endBootCount: $endBootCount, ')
          ..write('isStartManual: $isStartManual, ')
          ..write('isEndManual: $isEndManual, ')
          ..write('timeAccuracyStatus: $timeAccuracyStatus, ')
          ..write('createdAtUtcMs: $createdAtUtcMs, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startedAtUtcMs,
    endedAtUtcMs,
    startTimezone,
    endTimezone,
    startOffsetMinutes,
    endOffsetMinutes,
    startElapsedMs,
    endElapsedMs,
    startBootCount,
    endBootCount,
    isStartManual,
    isEndManual,
    timeAccuracyStatus,
    createdAtUtcMs,
    updatedAtUtcMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SleepSessionRow &&
          other.id == this.id &&
          other.startedAtUtcMs == this.startedAtUtcMs &&
          other.endedAtUtcMs == this.endedAtUtcMs &&
          other.startTimezone == this.startTimezone &&
          other.endTimezone == this.endTimezone &&
          other.startOffsetMinutes == this.startOffsetMinutes &&
          other.endOffsetMinutes == this.endOffsetMinutes &&
          other.startElapsedMs == this.startElapsedMs &&
          other.endElapsedMs == this.endElapsedMs &&
          other.startBootCount == this.startBootCount &&
          other.endBootCount == this.endBootCount &&
          other.isStartManual == this.isStartManual &&
          other.isEndManual == this.isEndManual &&
          other.timeAccuracyStatus == this.timeAccuracyStatus &&
          other.createdAtUtcMs == this.createdAtUtcMs &&
          other.updatedAtUtcMs == this.updatedAtUtcMs);
}

class SleepSessionsCompanion extends UpdateCompanion<SleepSessionRow> {
  final Value<String> id;
  final Value<int> startedAtUtcMs;
  final Value<int?> endedAtUtcMs;
  final Value<String> startTimezone;
  final Value<String?> endTimezone;
  final Value<int> startOffsetMinutes;
  final Value<int?> endOffsetMinutes;
  final Value<int> startElapsedMs;
  final Value<int?> endElapsedMs;
  final Value<int> startBootCount;
  final Value<int?> endBootCount;
  final Value<bool> isStartManual;
  final Value<bool> isEndManual;
  final Value<String> timeAccuracyStatus;
  final Value<int> createdAtUtcMs;
  final Value<int> updatedAtUtcMs;
  final Value<int> rowid;
  const SleepSessionsCompanion({
    this.id = const Value.absent(),
    this.startedAtUtcMs = const Value.absent(),
    this.endedAtUtcMs = const Value.absent(),
    this.startTimezone = const Value.absent(),
    this.endTimezone = const Value.absent(),
    this.startOffsetMinutes = const Value.absent(),
    this.endOffsetMinutes = const Value.absent(),
    this.startElapsedMs = const Value.absent(),
    this.endElapsedMs = const Value.absent(),
    this.startBootCount = const Value.absent(),
    this.endBootCount = const Value.absent(),
    this.isStartManual = const Value.absent(),
    this.isEndManual = const Value.absent(),
    this.timeAccuracyStatus = const Value.absent(),
    this.createdAtUtcMs = const Value.absent(),
    this.updatedAtUtcMs = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SleepSessionsCompanion.insert({
    required String id,
    required int startedAtUtcMs,
    this.endedAtUtcMs = const Value.absent(),
    required String startTimezone,
    this.endTimezone = const Value.absent(),
    required int startOffsetMinutes,
    this.endOffsetMinutes = const Value.absent(),
    required int startElapsedMs,
    this.endElapsedMs = const Value.absent(),
    required int startBootCount,
    this.endBootCount = const Value.absent(),
    this.isStartManual = const Value.absent(),
    this.isEndManual = const Value.absent(),
    this.timeAccuracyStatus = const Value.absent(),
    required int createdAtUtcMs,
    required int updatedAtUtcMs,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startedAtUtcMs = Value(startedAtUtcMs),
       startTimezone = Value(startTimezone),
       startOffsetMinutes = Value(startOffsetMinutes),
       startElapsedMs = Value(startElapsedMs),
       startBootCount = Value(startBootCount),
       createdAtUtcMs = Value(createdAtUtcMs),
       updatedAtUtcMs = Value(updatedAtUtcMs);
  static Insertable<SleepSessionRow> custom({
    Expression<String>? id,
    Expression<int>? startedAtUtcMs,
    Expression<int>? endedAtUtcMs,
    Expression<String>? startTimezone,
    Expression<String>? endTimezone,
    Expression<int>? startOffsetMinutes,
    Expression<int>? endOffsetMinutes,
    Expression<int>? startElapsedMs,
    Expression<int>? endElapsedMs,
    Expression<int>? startBootCount,
    Expression<int>? endBootCount,
    Expression<bool>? isStartManual,
    Expression<bool>? isEndManual,
    Expression<String>? timeAccuracyStatus,
    Expression<int>? createdAtUtcMs,
    Expression<int>? updatedAtUtcMs,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startedAtUtcMs != null) 'started_at_utc_ms': startedAtUtcMs,
      if (endedAtUtcMs != null) 'ended_at_utc_ms': endedAtUtcMs,
      if (startTimezone != null) 'start_timezone': startTimezone,
      if (endTimezone != null) 'end_timezone': endTimezone,
      if (startOffsetMinutes != null)
        'start_offset_minutes': startOffsetMinutes,
      if (endOffsetMinutes != null) 'end_offset_minutes': endOffsetMinutes,
      if (startElapsedMs != null) 'start_elapsed_ms': startElapsedMs,
      if (endElapsedMs != null) 'end_elapsed_ms': endElapsedMs,
      if (startBootCount != null) 'start_boot_count': startBootCount,
      if (endBootCount != null) 'end_boot_count': endBootCount,
      if (isStartManual != null) 'is_start_manual': isStartManual,
      if (isEndManual != null) 'is_end_manual': isEndManual,
      if (timeAccuracyStatus != null)
        'time_accuracy_status': timeAccuracyStatus,
      if (createdAtUtcMs != null) 'created_at_utc_ms': createdAtUtcMs,
      if (updatedAtUtcMs != null) 'updated_at_utc_ms': updatedAtUtcMs,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SleepSessionsCompanion copyWith({
    Value<String>? id,
    Value<int>? startedAtUtcMs,
    Value<int?>? endedAtUtcMs,
    Value<String>? startTimezone,
    Value<String?>? endTimezone,
    Value<int>? startOffsetMinutes,
    Value<int?>? endOffsetMinutes,
    Value<int>? startElapsedMs,
    Value<int?>? endElapsedMs,
    Value<int>? startBootCount,
    Value<int?>? endBootCount,
    Value<bool>? isStartManual,
    Value<bool>? isEndManual,
    Value<String>? timeAccuracyStatus,
    Value<int>? createdAtUtcMs,
    Value<int>? updatedAtUtcMs,
    Value<int>? rowid,
  }) {
    return SleepSessionsCompanion(
      id: id ?? this.id,
      startedAtUtcMs: startedAtUtcMs ?? this.startedAtUtcMs,
      endedAtUtcMs: endedAtUtcMs ?? this.endedAtUtcMs,
      startTimezone: startTimezone ?? this.startTimezone,
      endTimezone: endTimezone ?? this.endTimezone,
      startOffsetMinutes: startOffsetMinutes ?? this.startOffsetMinutes,
      endOffsetMinutes: endOffsetMinutes ?? this.endOffsetMinutes,
      startElapsedMs: startElapsedMs ?? this.startElapsedMs,
      endElapsedMs: endElapsedMs ?? this.endElapsedMs,
      startBootCount: startBootCount ?? this.startBootCount,
      endBootCount: endBootCount ?? this.endBootCount,
      isStartManual: isStartManual ?? this.isStartManual,
      isEndManual: isEndManual ?? this.isEndManual,
      timeAccuracyStatus: timeAccuracyStatus ?? this.timeAccuracyStatus,
      createdAtUtcMs: createdAtUtcMs ?? this.createdAtUtcMs,
      updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startedAtUtcMs.present) {
      map['started_at_utc_ms'] = Variable<int>(startedAtUtcMs.value);
    }
    if (endedAtUtcMs.present) {
      map['ended_at_utc_ms'] = Variable<int>(endedAtUtcMs.value);
    }
    if (startTimezone.present) {
      map['start_timezone'] = Variable<String>(startTimezone.value);
    }
    if (endTimezone.present) {
      map['end_timezone'] = Variable<String>(endTimezone.value);
    }
    if (startOffsetMinutes.present) {
      map['start_offset_minutes'] = Variable<int>(startOffsetMinutes.value);
    }
    if (endOffsetMinutes.present) {
      map['end_offset_minutes'] = Variable<int>(endOffsetMinutes.value);
    }
    if (startElapsedMs.present) {
      map['start_elapsed_ms'] = Variable<int>(startElapsedMs.value);
    }
    if (endElapsedMs.present) {
      map['end_elapsed_ms'] = Variable<int>(endElapsedMs.value);
    }
    if (startBootCount.present) {
      map['start_boot_count'] = Variable<int>(startBootCount.value);
    }
    if (endBootCount.present) {
      map['end_boot_count'] = Variable<int>(endBootCount.value);
    }
    if (isStartManual.present) {
      map['is_start_manual'] = Variable<bool>(isStartManual.value);
    }
    if (isEndManual.present) {
      map['is_end_manual'] = Variable<bool>(isEndManual.value);
    }
    if (timeAccuracyStatus.present) {
      map['time_accuracy_status'] = Variable<String>(timeAccuracyStatus.value);
    }
    if (createdAtUtcMs.present) {
      map['created_at_utc_ms'] = Variable<int>(createdAtUtcMs.value);
    }
    if (updatedAtUtcMs.present) {
      map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SleepSessionsCompanion(')
          ..write('id: $id, ')
          ..write('startedAtUtcMs: $startedAtUtcMs, ')
          ..write('endedAtUtcMs: $endedAtUtcMs, ')
          ..write('startTimezone: $startTimezone, ')
          ..write('endTimezone: $endTimezone, ')
          ..write('startOffsetMinutes: $startOffsetMinutes, ')
          ..write('endOffsetMinutes: $endOffsetMinutes, ')
          ..write('startElapsedMs: $startElapsedMs, ')
          ..write('endElapsedMs: $endElapsedMs, ')
          ..write('startBootCount: $startBootCount, ')
          ..write('endBootCount: $endBootCount, ')
          ..write('isStartManual: $isStartManual, ')
          ..write('isEndManual: $isEndManual, ')
          ..write('timeAccuracyStatus: $timeAccuracyStatus, ')
          ..write('createdAtUtcMs: $createdAtUtcMs, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _settingKeyMeta = const VerificationMeta(
    'settingKey',
  );
  @override
  late final GeneratedColumn<String> settingKey = GeneratedColumn<String>(
    'setting_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _settingValueMeta = const VerificationMeta(
    'settingValue',
  );
  @override
  late final GeneratedColumn<String> settingValue = GeneratedColumn<String>(
    'setting_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtUtcMsMeta = const VerificationMeta(
    'updatedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtcMs = GeneratedColumn<int>(
    'updated_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    settingKey,
    settingValue,
    updatedAtUtcMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('setting_key')) {
      context.handle(
        _settingKeyMeta,
        settingKey.isAcceptableOrUnknown(data['setting_key']!, _settingKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_settingKeyMeta);
    }
    if (data.containsKey('setting_value')) {
      context.handle(
        _settingValueMeta,
        settingValue.isAcceptableOrUnknown(
          data['setting_value']!,
          _settingValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_settingValueMeta);
    }
    if (data.containsKey('updated_at_utc_ms')) {
      context.handle(
        _updatedAtUtcMsMeta,
        updatedAtUtcMs.isAcceptableOrUnknown(
          data['updated_at_utc_ms']!,
          _updatedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      settingKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_key'],
      )!,
      settingValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_value'],
      )!,
      updatedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_ms'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSettingRow extends DataClass implements Insertable<AppSettingRow> {
  final int id;
  final String settingKey;
  final String settingValue;
  final int updatedAtUtcMs;
  const AppSettingRow({
    required this.id,
    required this.settingKey,
    required this.settingValue,
    required this.updatedAtUtcMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['setting_key'] = Variable<String>(settingKey);
    map['setting_value'] = Variable<String>(settingValue);
    map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      settingKey: Value(settingKey),
      settingValue: Value(settingValue),
      updatedAtUtcMs: Value(updatedAtUtcMs),
    );
  }

  factory AppSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingRow(
      id: serializer.fromJson<int>(json['id']),
      settingKey: serializer.fromJson<String>(json['settingKey']),
      settingValue: serializer.fromJson<String>(json['settingValue']),
      updatedAtUtcMs: serializer.fromJson<int>(json['updatedAtUtcMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'settingKey': serializer.toJson<String>(settingKey),
      'settingValue': serializer.toJson<String>(settingValue),
      'updatedAtUtcMs': serializer.toJson<int>(updatedAtUtcMs),
    };
  }

  AppSettingRow copyWith({
    int? id,
    String? settingKey,
    String? settingValue,
    int? updatedAtUtcMs,
  }) => AppSettingRow(
    id: id ?? this.id,
    settingKey: settingKey ?? this.settingKey,
    settingValue: settingValue ?? this.settingValue,
    updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
  );
  AppSettingRow copyWithCompanion(AppSettingsCompanion data) {
    return AppSettingRow(
      id: data.id.present ? data.id.value : this.id,
      settingKey: data.settingKey.present
          ? data.settingKey.value
          : this.settingKey,
      settingValue: data.settingValue.present
          ? data.settingValue.value
          : this.settingValue,
      updatedAtUtcMs: data.updatedAtUtcMs.present
          ? data.updatedAtUtcMs.value
          : this.updatedAtUtcMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingRow(')
          ..write('id: $id, ')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, settingKey, settingValue, updatedAtUtcMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingRow &&
          other.id == this.id &&
          other.settingKey == this.settingKey &&
          other.settingValue == this.settingValue &&
          other.updatedAtUtcMs == this.updatedAtUtcMs);
}

class AppSettingsCompanion extends UpdateCompanion<AppSettingRow> {
  final Value<int> id;
  final Value<String> settingKey;
  final Value<String> settingValue;
  final Value<int> updatedAtUtcMs;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.settingKey = const Value.absent(),
    this.settingValue = const Value.absent(),
    this.updatedAtUtcMs = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String settingKey,
    required String settingValue,
    required int updatedAtUtcMs,
  }) : settingKey = Value(settingKey),
       settingValue = Value(settingValue),
       updatedAtUtcMs = Value(updatedAtUtcMs);
  static Insertable<AppSettingRow> custom({
    Expression<int>? id,
    Expression<String>? settingKey,
    Expression<String>? settingValue,
    Expression<int>? updatedAtUtcMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (settingKey != null) 'setting_key': settingKey,
      if (settingValue != null) 'setting_value': settingValue,
      if (updatedAtUtcMs != null) 'updated_at_utc_ms': updatedAtUtcMs,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? settingKey,
    Value<String>? settingValue,
    Value<int>? updatedAtUtcMs,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      settingKey: settingKey ?? this.settingKey,
      settingValue: settingValue ?? this.settingValue,
      updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (settingKey.present) {
      map['setting_key'] = Variable<String>(settingKey.value);
    }
    if (settingValue.present) {
      map['setting_value'] = Variable<String>(settingValue.value);
    }
    if (updatedAtUtcMs.present) {
      map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs')
          ..write(')'))
        .toString();
  }
}

class $WakeUpStateTable extends WakeUpState
    with TableInfo<$WakeUpStateTable, WakeUpStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WakeUpStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _activatedAtUtcMsMeta = const VerificationMeta(
    'activatedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> activatedAtUtcMs = GeneratedColumn<int>(
    'activated_at_utc_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _relatedSessionIdMeta = const VerificationMeta(
    'relatedSessionId',
  );
  @override
  late final GeneratedColumn<String> relatedSessionId = GeneratedColumn<String>(
    'related_session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtUtcMsMeta = const VerificationMeta(
    'updatedAtUtcMs',
  );
  @override
  late final GeneratedColumn<int> updatedAtUtcMs = GeneratedColumn<int>(
    'updated_at_utc_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    isActive,
    activatedAtUtcMs,
    relatedSessionId,
    updatedAtUtcMs,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wake_up_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<WakeUpStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('activated_at_utc_ms')) {
      context.handle(
        _activatedAtUtcMsMeta,
        activatedAtUtcMs.isAcceptableOrUnknown(
          data['activated_at_utc_ms']!,
          _activatedAtUtcMsMeta,
        ),
      );
    }
    if (data.containsKey('related_session_id')) {
      context.handle(
        _relatedSessionIdMeta,
        relatedSessionId.isAcceptableOrUnknown(
          data['related_session_id']!,
          _relatedSessionIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_at_utc_ms')) {
      context.handle(
        _updatedAtUtcMsMeta,
        updatedAtUtcMs.isAcceptableOrUnknown(
          data['updated_at_utc_ms']!,
          _updatedAtUtcMsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WakeUpStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WakeUpStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      activatedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activated_at_utc_ms'],
      ),
      relatedSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_session_id'],
      ),
      updatedAtUtcMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc_ms'],
      )!,
    );
  }

  @override
  $WakeUpStateTable createAlias(String alias) {
    return $WakeUpStateTable(attachedDatabase, alias);
  }
}

class WakeUpStateRow extends DataClass implements Insertable<WakeUpStateRow> {
  final int id;
  final bool isActive;
  final int? activatedAtUtcMs;
  final String? relatedSessionId;
  final int updatedAtUtcMs;
  const WakeUpStateRow({
    required this.id,
    required this.isActive,
    this.activatedAtUtcMs,
    this.relatedSessionId,
    required this.updatedAtUtcMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || activatedAtUtcMs != null) {
      map['activated_at_utc_ms'] = Variable<int>(activatedAtUtcMs);
    }
    if (!nullToAbsent || relatedSessionId != null) {
      map['related_session_id'] = Variable<String>(relatedSessionId);
    }
    map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs);
    return map;
  }

  WakeUpStateCompanion toCompanion(bool nullToAbsent) {
    return WakeUpStateCompanion(
      id: Value(id),
      isActive: Value(isActive),
      activatedAtUtcMs: activatedAtUtcMs == null && nullToAbsent
          ? const Value.absent()
          : Value(activatedAtUtcMs),
      relatedSessionId: relatedSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedSessionId),
      updatedAtUtcMs: Value(updatedAtUtcMs),
    );
  }

  factory WakeUpStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WakeUpStateRow(
      id: serializer.fromJson<int>(json['id']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      activatedAtUtcMs: serializer.fromJson<int?>(json['activatedAtUtcMs']),
      relatedSessionId: serializer.fromJson<String?>(json['relatedSessionId']),
      updatedAtUtcMs: serializer.fromJson<int>(json['updatedAtUtcMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isActive': serializer.toJson<bool>(isActive),
      'activatedAtUtcMs': serializer.toJson<int?>(activatedAtUtcMs),
      'relatedSessionId': serializer.toJson<String?>(relatedSessionId),
      'updatedAtUtcMs': serializer.toJson<int>(updatedAtUtcMs),
    };
  }

  WakeUpStateRow copyWith({
    int? id,
    bool? isActive,
    Value<int?> activatedAtUtcMs = const Value.absent(),
    Value<String?> relatedSessionId = const Value.absent(),
    int? updatedAtUtcMs,
  }) => WakeUpStateRow(
    id: id ?? this.id,
    isActive: isActive ?? this.isActive,
    activatedAtUtcMs: activatedAtUtcMs.present
        ? activatedAtUtcMs.value
        : this.activatedAtUtcMs,
    relatedSessionId: relatedSessionId.present
        ? relatedSessionId.value
        : this.relatedSessionId,
    updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
  );
  WakeUpStateRow copyWithCompanion(WakeUpStateCompanion data) {
    return WakeUpStateRow(
      id: data.id.present ? data.id.value : this.id,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      activatedAtUtcMs: data.activatedAtUtcMs.present
          ? data.activatedAtUtcMs.value
          : this.activatedAtUtcMs,
      relatedSessionId: data.relatedSessionId.present
          ? data.relatedSessionId.value
          : this.relatedSessionId,
      updatedAtUtcMs: data.updatedAtUtcMs.present
          ? data.updatedAtUtcMs.value
          : this.updatedAtUtcMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WakeUpStateRow(')
          ..write('id: $id, ')
          ..write('isActive: $isActive, ')
          ..write('activatedAtUtcMs: $activatedAtUtcMs, ')
          ..write('relatedSessionId: $relatedSessionId, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    isActive,
    activatedAtUtcMs,
    relatedSessionId,
    updatedAtUtcMs,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WakeUpStateRow &&
          other.id == this.id &&
          other.isActive == this.isActive &&
          other.activatedAtUtcMs == this.activatedAtUtcMs &&
          other.relatedSessionId == this.relatedSessionId &&
          other.updatedAtUtcMs == this.updatedAtUtcMs);
}

class WakeUpStateCompanion extends UpdateCompanion<WakeUpStateRow> {
  final Value<int> id;
  final Value<bool> isActive;
  final Value<int?> activatedAtUtcMs;
  final Value<String?> relatedSessionId;
  final Value<int> updatedAtUtcMs;
  const WakeUpStateCompanion({
    this.id = const Value.absent(),
    this.isActive = const Value.absent(),
    this.activatedAtUtcMs = const Value.absent(),
    this.relatedSessionId = const Value.absent(),
    this.updatedAtUtcMs = const Value.absent(),
  });
  WakeUpStateCompanion.insert({
    this.id = const Value.absent(),
    this.isActive = const Value.absent(),
    this.activatedAtUtcMs = const Value.absent(),
    this.relatedSessionId = const Value.absent(),
    required int updatedAtUtcMs,
  }) : updatedAtUtcMs = Value(updatedAtUtcMs);
  static Insertable<WakeUpStateRow> custom({
    Expression<int>? id,
    Expression<bool>? isActive,
    Expression<int>? activatedAtUtcMs,
    Expression<String>? relatedSessionId,
    Expression<int>? updatedAtUtcMs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isActive != null) 'is_active': isActive,
      if (activatedAtUtcMs != null) 'activated_at_utc_ms': activatedAtUtcMs,
      if (relatedSessionId != null) 'related_session_id': relatedSessionId,
      if (updatedAtUtcMs != null) 'updated_at_utc_ms': updatedAtUtcMs,
    });
  }

  WakeUpStateCompanion copyWith({
    Value<int>? id,
    Value<bool>? isActive,
    Value<int?>? activatedAtUtcMs,
    Value<String?>? relatedSessionId,
    Value<int>? updatedAtUtcMs,
  }) {
    return WakeUpStateCompanion(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      activatedAtUtcMs: activatedAtUtcMs ?? this.activatedAtUtcMs,
      relatedSessionId: relatedSessionId ?? this.relatedSessionId,
      updatedAtUtcMs: updatedAtUtcMs ?? this.updatedAtUtcMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (activatedAtUtcMs.present) {
      map['activated_at_utc_ms'] = Variable<int>(activatedAtUtcMs.value);
    }
    if (relatedSessionId.present) {
      map['related_session_id'] = Variable<String>(relatedSessionId.value);
    }
    if (updatedAtUtcMs.present) {
      map['updated_at_utc_ms'] = Variable<int>(updatedAtUtcMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WakeUpStateCompanion(')
          ..write('id: $id, ')
          ..write('isActive: $isActive, ')
          ..write('activatedAtUtcMs: $activatedAtUtcMs, ')
          ..write('relatedSessionId: $relatedSessionId, ')
          ..write('updatedAtUtcMs: $updatedAtUtcMs')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SleepSessionsTable sleepSessions = $SleepSessionsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $WakeUpStateTable wakeUpState = $WakeUpStateTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    sleepSessions,
    appSettings,
    wakeUpState,
  ];
}

typedef $$SleepSessionsTableCreateCompanionBuilder =
    SleepSessionsCompanion Function({
      required String id,
      required int startedAtUtcMs,
      Value<int?> endedAtUtcMs,
      required String startTimezone,
      Value<String?> endTimezone,
      required int startOffsetMinutes,
      Value<int?> endOffsetMinutes,
      required int startElapsedMs,
      Value<int?> endElapsedMs,
      required int startBootCount,
      Value<int?> endBootCount,
      Value<bool> isStartManual,
      Value<bool> isEndManual,
      Value<String> timeAccuracyStatus,
      required int createdAtUtcMs,
      required int updatedAtUtcMs,
      Value<int> rowid,
    });
typedef $$SleepSessionsTableUpdateCompanionBuilder =
    SleepSessionsCompanion Function({
      Value<String> id,
      Value<int> startedAtUtcMs,
      Value<int?> endedAtUtcMs,
      Value<String> startTimezone,
      Value<String?> endTimezone,
      Value<int> startOffsetMinutes,
      Value<int?> endOffsetMinutes,
      Value<int> startElapsedMs,
      Value<int?> endElapsedMs,
      Value<int> startBootCount,
      Value<int?> endBootCount,
      Value<bool> isStartManual,
      Value<bool> isEndManual,
      Value<String> timeAccuracyStatus,
      Value<int> createdAtUtcMs,
      Value<int> updatedAtUtcMs,
      Value<int> rowid,
    });

class $$SleepSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SleepSessionsTable> {
  $$SleepSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAtUtcMs => $composableBuilder(
    column: $table.startedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAtUtcMs => $composableBuilder(
    column: $table.endedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTimezone => $composableBuilder(
    column: $table.startTimezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endTimezone => $composableBuilder(
    column: $table.endTimezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startOffsetMinutes => $composableBuilder(
    column: $table.startOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endOffsetMinutes => $composableBuilder(
    column: $table.endOffsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startElapsedMs => $composableBuilder(
    column: $table.startElapsedMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endElapsedMs => $composableBuilder(
    column: $table.endElapsedMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startBootCount => $composableBuilder(
    column: $table.startBootCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endBootCount => $composableBuilder(
    column: $table.endBootCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStartManual => $composableBuilder(
    column: $table.isStartManual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEndManual => $composableBuilder(
    column: $table.isEndManual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeAccuracyStatus => $composableBuilder(
    column: $table.timeAccuracyStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SleepSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SleepSessionsTable> {
  $$SleepSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAtUtcMs => $composableBuilder(
    column: $table.startedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAtUtcMs => $composableBuilder(
    column: $table.endedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTimezone => $composableBuilder(
    column: $table.startTimezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endTimezone => $composableBuilder(
    column: $table.endTimezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startOffsetMinutes => $composableBuilder(
    column: $table.startOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endOffsetMinutes => $composableBuilder(
    column: $table.endOffsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startElapsedMs => $composableBuilder(
    column: $table.startElapsedMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endElapsedMs => $composableBuilder(
    column: $table.endElapsedMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startBootCount => $composableBuilder(
    column: $table.startBootCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endBootCount => $composableBuilder(
    column: $table.endBootCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStartManual => $composableBuilder(
    column: $table.isStartManual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEndManual => $composableBuilder(
    column: $table.isEndManual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeAccuracyStatus => $composableBuilder(
    column: $table.timeAccuracyStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SleepSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SleepSessionsTable> {
  $$SleepSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get startedAtUtcMs => $composableBuilder(
    column: $table.startedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endedAtUtcMs => $composableBuilder(
    column: $table.endedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get startTimezone => $composableBuilder(
    column: $table.startTimezone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get endTimezone => $composableBuilder(
    column: $table.endTimezone,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startOffsetMinutes => $composableBuilder(
    column: $table.startOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endOffsetMinutes => $composableBuilder(
    column: $table.endOffsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startElapsedMs => $composableBuilder(
    column: $table.startElapsedMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endElapsedMs => $composableBuilder(
    column: $table.endElapsedMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get startBootCount => $composableBuilder(
    column: $table.startBootCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endBootCount => $composableBuilder(
    column: $table.endBootCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isStartManual => $composableBuilder(
    column: $table.isStartManual,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEndManual => $composableBuilder(
    column: $table.isEndManual,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeAccuracyStatus => $composableBuilder(
    column: $table.timeAccuracyStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtUtcMs => $composableBuilder(
    column: $table.createdAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => column,
  );
}

class $$SleepSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SleepSessionsTable,
          SleepSessionRow,
          $$SleepSessionsTableFilterComposer,
          $$SleepSessionsTableOrderingComposer,
          $$SleepSessionsTableAnnotationComposer,
          $$SleepSessionsTableCreateCompanionBuilder,
          $$SleepSessionsTableUpdateCompanionBuilder,
          (
            SleepSessionRow,
            BaseReferences<_$AppDatabase, $SleepSessionsTable, SleepSessionRow>,
          ),
          SleepSessionRow,
          PrefetchHooks Function()
        > {
  $$SleepSessionsTableTableManager(_$AppDatabase db, $SleepSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SleepSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SleepSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SleepSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> startedAtUtcMs = const Value.absent(),
                Value<int?> endedAtUtcMs = const Value.absent(),
                Value<String> startTimezone = const Value.absent(),
                Value<String?> endTimezone = const Value.absent(),
                Value<int> startOffsetMinutes = const Value.absent(),
                Value<int?> endOffsetMinutes = const Value.absent(),
                Value<int> startElapsedMs = const Value.absent(),
                Value<int?> endElapsedMs = const Value.absent(),
                Value<int> startBootCount = const Value.absent(),
                Value<int?> endBootCount = const Value.absent(),
                Value<bool> isStartManual = const Value.absent(),
                Value<bool> isEndManual = const Value.absent(),
                Value<String> timeAccuracyStatus = const Value.absent(),
                Value<int> createdAtUtcMs = const Value.absent(),
                Value<int> updatedAtUtcMs = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SleepSessionsCompanion(
                id: id,
                startedAtUtcMs: startedAtUtcMs,
                endedAtUtcMs: endedAtUtcMs,
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
                timeAccuracyStatus: timeAccuracyStatus,
                createdAtUtcMs: createdAtUtcMs,
                updatedAtUtcMs: updatedAtUtcMs,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int startedAtUtcMs,
                Value<int?> endedAtUtcMs = const Value.absent(),
                required String startTimezone,
                Value<String?> endTimezone = const Value.absent(),
                required int startOffsetMinutes,
                Value<int?> endOffsetMinutes = const Value.absent(),
                required int startElapsedMs,
                Value<int?> endElapsedMs = const Value.absent(),
                required int startBootCount,
                Value<int?> endBootCount = const Value.absent(),
                Value<bool> isStartManual = const Value.absent(),
                Value<bool> isEndManual = const Value.absent(),
                Value<String> timeAccuracyStatus = const Value.absent(),
                required int createdAtUtcMs,
                required int updatedAtUtcMs,
                Value<int> rowid = const Value.absent(),
              }) => SleepSessionsCompanion.insert(
                id: id,
                startedAtUtcMs: startedAtUtcMs,
                endedAtUtcMs: endedAtUtcMs,
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
                timeAccuracyStatus: timeAccuracyStatus,
                createdAtUtcMs: createdAtUtcMs,
                updatedAtUtcMs: updatedAtUtcMs,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SleepSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SleepSessionsTable,
      SleepSessionRow,
      $$SleepSessionsTableFilterComposer,
      $$SleepSessionsTableOrderingComposer,
      $$SleepSessionsTableAnnotationComposer,
      $$SleepSessionsTableCreateCompanionBuilder,
      $$SleepSessionsTableUpdateCompanionBuilder,
      (
        SleepSessionRow,
        BaseReferences<_$AppDatabase, $SleepSessionsTable, SleepSessionRow>,
      ),
      SleepSessionRow,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      required String settingKey,
      required String settingValue,
      required int updatedAtUtcMs,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> settingKey,
      Value<String> settingValue,
      Value<int> updatedAtUtcMs,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSettingRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSettingRow,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>,
          ),
          AppSettingRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> settingKey = const Value.absent(),
                Value<String> settingValue = const Value.absent(),
                Value<int> updatedAtUtcMs = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                settingKey: settingKey,
                settingValue: settingValue,
                updatedAtUtcMs: updatedAtUtcMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String settingKey,
                required String settingValue,
                required int updatedAtUtcMs,
              }) => AppSettingsCompanion.insert(
                id: id,
                settingKey: settingKey,
                settingValue: settingValue,
                updatedAtUtcMs: updatedAtUtcMs,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSettingRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSettingRow,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSettingRow>,
      ),
      AppSettingRow,
      PrefetchHooks Function()
    >;
typedef $$WakeUpStateTableCreateCompanionBuilder =
    WakeUpStateCompanion Function({
      Value<int> id,
      Value<bool> isActive,
      Value<int?> activatedAtUtcMs,
      Value<String?> relatedSessionId,
      required int updatedAtUtcMs,
    });
typedef $$WakeUpStateTableUpdateCompanionBuilder =
    WakeUpStateCompanion Function({
      Value<int> id,
      Value<bool> isActive,
      Value<int?> activatedAtUtcMs,
      Value<String?> relatedSessionId,
      Value<int> updatedAtUtcMs,
    });

class $$WakeUpStateTableFilterComposer
    extends Composer<_$AppDatabase, $WakeUpStateTable> {
  $$WakeUpStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activatedAtUtcMs => $composableBuilder(
    column: $table.activatedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatedSessionId => $composableBuilder(
    column: $table.relatedSessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WakeUpStateTableOrderingComposer
    extends Composer<_$AppDatabase, $WakeUpStateTable> {
  $$WakeUpStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activatedAtUtcMs => $composableBuilder(
    column: $table.activatedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatedSessionId => $composableBuilder(
    column: $table.relatedSessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WakeUpStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $WakeUpStateTable> {
  $$WakeUpStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get activatedAtUtcMs => $composableBuilder(
    column: $table.activatedAtUtcMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get relatedSessionId => $composableBuilder(
    column: $table.relatedSessionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtcMs => $composableBuilder(
    column: $table.updatedAtUtcMs,
    builder: (column) => column,
  );
}

class $$WakeUpStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WakeUpStateTable,
          WakeUpStateRow,
          $$WakeUpStateTableFilterComposer,
          $$WakeUpStateTableOrderingComposer,
          $$WakeUpStateTableAnnotationComposer,
          $$WakeUpStateTableCreateCompanionBuilder,
          $$WakeUpStateTableUpdateCompanionBuilder,
          (
            WakeUpStateRow,
            BaseReferences<_$AppDatabase, $WakeUpStateTable, WakeUpStateRow>,
          ),
          WakeUpStateRow,
          PrefetchHooks Function()
        > {
  $$WakeUpStateTableTableManager(_$AppDatabase db, $WakeUpStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WakeUpStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WakeUpStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WakeUpStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int?> activatedAtUtcMs = const Value.absent(),
                Value<String?> relatedSessionId = const Value.absent(),
                Value<int> updatedAtUtcMs = const Value.absent(),
              }) => WakeUpStateCompanion(
                id: id,
                isActive: isActive,
                activatedAtUtcMs: activatedAtUtcMs,
                relatedSessionId: relatedSessionId,
                updatedAtUtcMs: updatedAtUtcMs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int?> activatedAtUtcMs = const Value.absent(),
                Value<String?> relatedSessionId = const Value.absent(),
                required int updatedAtUtcMs,
              }) => WakeUpStateCompanion.insert(
                id: id,
                isActive: isActive,
                activatedAtUtcMs: activatedAtUtcMs,
                relatedSessionId: relatedSessionId,
                updatedAtUtcMs: updatedAtUtcMs,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WakeUpStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WakeUpStateTable,
      WakeUpStateRow,
      $$WakeUpStateTableFilterComposer,
      $$WakeUpStateTableOrderingComposer,
      $$WakeUpStateTableAnnotationComposer,
      $$WakeUpStateTableCreateCompanionBuilder,
      $$WakeUpStateTableUpdateCompanionBuilder,
      (
        WakeUpStateRow,
        BaseReferences<_$AppDatabase, $WakeUpStateTable, WakeUpStateRow>,
      ),
      WakeUpStateRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SleepSessionsTableTableManager get sleepSessions =>
      $$SleepSessionsTableTableManager(_db, _db.sleepSessions);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$WakeUpStateTableTableManager get wakeUpState =>
      $$WakeUpStateTableTableManager(_db, _db.wakeUpState);
}
