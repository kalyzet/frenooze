import 'package:drift/drift.dart';

/// Generic local application settings key/value store.
@DataClassName('AppSettingRow')
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get settingKey => text().unique()();
  TextColumn get settingValue => text()();
  IntColumn get updatedAtUtcMs => integer()();
}