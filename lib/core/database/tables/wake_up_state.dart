import 'package:drift/drift.dart';

/// Persisted Wake-up Mode status, kept separate from sleep session data so a
/// wake-up failure can never erase a completed session.
@DataClassName('WakeUpStateRow')
class WakeUpState extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  IntColumn get activatedAtUtcMs => integer().nullable()();
  TextColumn get relatedSessionId => text().nullable()();
  IntColumn get updatedAtUtcMs => integer()();
}