import 'package:drift/drift.dart';

/// Immutable sleep session record.
///
/// Absolute time is stored as UTC milliseconds; local time is always derived
/// from the recorded IANA timezone and UTC offset. Duration is never stored as
/// an editable value.
@DataClassName('SleepSessionRow')
class SleepSessions extends Table {
  TextColumn get id => text()();

  IntColumn get startedAtUtcMs => integer()();
  IntColumn get endedAtUtcMs => integer().nullable()();

  TextColumn get startTimezone => text()();
  TextColumn get endTimezone => text().nullable()();

  IntColumn get startOffsetMinutes => integer()();
  IntColumn get endOffsetMinutes => integer().nullable()();

  IntColumn get startElapsedMs => integer()();
  IntColumn get endElapsedMs => integer().nullable()();

  IntColumn get startBootCount => integer()();
  IntColumn get endBootCount => integer().nullable()();

  BoolColumn get isStartManual =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isEndManual =>
      boolean().withDefault(const Constant(false))();

  TextColumn get timeAccuracyStatus =>
      text().withDefault(const Constant('ok'))();

  IntColumn get createdAtUtcMs => integer()();
  IntColumn get updatedAtUtcMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}