import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frenooze/app.dart';
import 'package:frenooze/core/platform/device_time_provider.dart';
import 'package:frenooze/core/theme/theme_mode_controller.dart';
import 'package:frenooze/features/data_management/domain/repositories/data_management_repository.dart';
import 'package:frenooze/features/data_management/domain/usecases/apply_sleep_data_import.dart';
import 'package:frenooze/features/data_management/domain/usecases/export_sleep_data.dart';
import 'package:frenooze/features/data_management/domain/usecases/preview_sleep_data_import.dart';
import 'package:frenooze/features/data_management/presentation/bloc/data_management_bloc.dart';
import 'package:frenooze/features/sleep_history/presentation/bloc/history_bloc.dart';
import 'package:frenooze/features/sleep_session/domain/entities/sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/entities/time_accuracy.dart';
import 'package:frenooze/features/sleep_session/domain/repositories/sleep_session_repository.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/delete_sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/end_sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/get_active_sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/get_sleep_session_by_id.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/get_sleep_sessions.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/recover_active_session.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/start_sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/update_sleep_session.dart';
import 'package:frenooze/features/sleep_session/presentation/bloc/sleep_session_bloc.dart';
import 'package:frenooze/features/statistics/domain/usecases/get_sleep_statistics.dart';
import 'package:frenooze/features/statistics/presentation/bloc/statistics_bloc.dart';
import 'package:frenooze/features/statistics/presentation/pages/statistics_page.dart';
import 'package:frenooze/features/wake_up/domain/entities/wake_up_status.dart';
import 'package:frenooze/features/wake_up/domain/repositories/wake_up_repository.dart';
import 'package:frenooze/features/wake_up/domain/services/wake_up_hardware.dart';
import 'package:frenooze/features/wake_up/domain/usecases/activate_wake_up_mode.dart';
import 'package:frenooze/features/wake_up/domain/usecases/close_wake_up_mode.dart';
import 'package:frenooze/features/wake_up/domain/usecases/restore_wake_up_state.dart';
import 'package:frenooze/features/wake_up/presentation/bloc/wake_up_bloc.dart';

class _FakeSleepSessionRepository implements SleepSessionRepository {
  _FakeSleepSessionRepository({this.sessions = const <SleepSession>[]});

  final List<SleepSession> sessions;

  @override
  Future<SleepSession?> getActiveSession() async => null;

  @override
  Future<SleepSession?> getById(String id) async => null;

  @override
  Future<List<SleepSession>> getAll() async => sessions;

  @override
  Future<void> insert(SleepSession session) async {}

  @override
  Future<void> update(SleepSession session) async {}

  @override
  Future<void> delete(String id) async {}
}

class _FakeDeviceTimeProvider implements DeviceTimeProvider {
  @override
  Future<DeviceTimeSnapshot> capture() async => throw UnimplementedError();
}

class _FakeWakeUpRepository implements WakeUpRepository {
  @override
  Future<WakeUpStatus> getActive() async => WakeUpStatus.inactive();

  @override
  Future<WakeUpStatus> markActive(String relatedSessionId) async =>
      WakeUpStatus(
        isActive: true,
        activatedAtUtc: DateTime.utc(2026),
        relatedSessionId: relatedSessionId,
        updatedAtUtc: DateTime.utc(2026),
      );

  @override
  Future<WakeUpStatus> markInactive() async => WakeUpStatus.inactive();
}

class _FakeWakeUpHardware implements WakeUpHardware {
  @override
  Future<void> startVibration() async {}

  @override
  Future<void> stopVibration() async {}

  @override
  Future<void> keepScreenOn() async {}

  @override
  Future<void> releaseScreenOn() async {}
}

class _FakeDataManagementRepository implements DataManagementRepository {
  @override
  Future<List<SleepSession>> getAllSessions() async => <SleepSession>[];

  @override
  Future<String?> getActiveSessionId() async => null;

  @override
  Future<Set<String>> getExistingIds() async => <String>{};

  @override
  Future<void> replaceAll(List<SleepSession> sessions) async {}

  @override
  Future<int> insertMissing(List<SleepSession> sessions) async => 0;
}

SleepSession _sampleSession({
  String id = 's1',
  DateTime? startedAtUtc,
  DateTime? endedAtUtc,
}) {
  final DateTime start = startedAtUtc ?? DateTime.utc(2026, 11, 11, 15);
  return SleepSession(
    id: id,
    startedAtUtc: start,
    endedAtUtc: endedAtUtc ?? start.add(const Duration(hours: 7)),
    startTimezone: 'Asia/Jakarta',
    endTimezone: 'Asia/Jakarta',
    startOffsetMinutes: 420,
    endOffsetMinutes: 420,
    startElapsedMs: 0,
    endElapsedMs: 7 * 3600 * 1000,
    startBootCount: 1,
    endBootCount: 1,
    accuracy: TimeAccuracy.ok,
    createdAtUtc: start,
    updatedAtUtc: start.add(const Duration(hours: 7)),
  );
}

Future<void> _pumpApp(
  WidgetTester tester, {
  List<SleepSession> sessions = const <SleepSession>[],
}) async {
  final _FakeSleepSessionRepository sleepRepo =
      _FakeSleepSessionRepository(sessions: sessions);

  final SleepSessionBloc sleepBloc = SleepSessionBloc(
    startSleepSession: StartSleepSession(
      repository: sleepRepo,
      timeProvider: _FakeDeviceTimeProvider(),
    ),
    endSleepSession: EndSleepSession(
      repository: sleepRepo,
      timeProvider: _FakeDeviceTimeProvider(),
    ),
    getActiveSleepSession: GetActiveSleepSession(repository: sleepRepo),
    updateSleepSession: UpdateSleepSession(repository: sleepRepo),
    deleteSleepSession: DeleteSleepSession(repository: sleepRepo),
    recoverActiveSession: RecoverActiveSession(repository: sleepRepo),
  );
  addTearDown(sleepBloc.close);

  final _FakeWakeUpRepository wakeRepo = _FakeWakeUpRepository();
  final WakeUpBloc wakeBloc = WakeUpBloc(
    activateWakeUpMode: ActivateWakeUpMode(
      repository: wakeRepo,
      hardware: _FakeWakeUpHardware(),
    ),
    closeWakeUpMode: CloseWakeUpMode(
      repository: wakeRepo,
      hardware: _FakeWakeUpHardware(),
    ),
    restoreWakeUpState: RestoreWakeUpState(repository: wakeRepo),
  );
  addTearDown(wakeBloc.close);

  final HistoryBloc historyBloc = HistoryBloc(
    getSleepSessions: GetSleepSessions(repository: sleepRepo),
    getSleepSessionById: GetSleepSessionById(repository: sleepRepo),
    updateSleepSession: UpdateSleepSession(repository: sleepRepo),
    deleteSleepSession: DeleteSleepSession(repository: sleepRepo),
  );
  addTearDown(historyBloc.close);

  final StatisticsBloc statisticsBloc = StatisticsBloc(
    getSleepStatistics: GetSleepStatistics(repository: sleepRepo),
  );
  addTearDown(statisticsBloc.close);

  final DataManagementBloc dataManagementBloc = DataManagementBloc(
    exportSleepData: ExportSleepData(repository: sleepRepo),
    previewSleepDataImport: PreviewSleepDataImport(
      repository: _FakeDataManagementRepository(),
    ),
    applySleepDataImport: ApplySleepDataImport(
      repository: _FakeDataManagementRepository(),
    ),
  );
  addTearDown(dataManagementBloc.close);

  await tester.pumpWidget(
    FrenoozeApp(
      themeModeController: ThemeModeController(),
      sleepSessionBloc: sleepBloc,
      wakeUpBloc: wakeBloc,
      historyBloc: historyBloc,
      statisticsBloc: statisticsBloc,
      dataManagementBloc: dataManagementBloc,
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _goToTab(WidgetTester tester, String label) async {
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Settings shows export and import actions', (tester) async {
    await _pumpApp(tester);
    await _goToTab(tester, 'Pengaturan');

    expect(find.text('Pengaturan'), findsWidgets);
    expect(find.text('Export JSON'), findsOneWidget);
    expect(find.text('Export CSV'), findsOneWidget);
    expect(find.text('Import JSON'), findsOneWidget);
    expect(find.text('Tentang Frenooze'), findsOneWidget);
  });

  testWidgets('History empty state shows guidance', (tester) async {
    await _pumpApp(tester);
    await _goToTab(tester, 'Riwayat');

    expect(find.text('Belum ada riwayat tidur.'), findsOneWidget);
    expect(find.text('Buka Dashboard'), findsOneWidget);
  });

  testWidgets('History lists completed sessions', (tester) async {
    await _pumpApp(
      tester,
      sessions: <SleepSession>[
        _sampleSession(id: 'a'),
        _sampleSession(
          id: 'b',
          startedAtUtc: DateTime.utc(2026, 11, 10, 15),
        ),
      ],
    );
    await _goToTab(tester, 'Riwayat');

    expect(find.textContaining('Tersimpan'), findsWidgets);
    expect(find.textContaining('Mulai'), findsWidgets);
  });

  testWidgets('Statistics empty state when no valid sessions', (tester) async {
    await _pumpApp(tester);
    await _goToTab(tester, 'Statistik');

    expect(find.text('Belum ada data untuk periode ini.'), findsOneWidget);
    expect(find.text('7 hari'), findsOneWidget);
  });

  testWidgets('Statistics shows metrics when data exists', (tester) async {
    await _pumpApp(
      tester,
      sessions: <SleepSession>[_sampleSession()],
    );
    await _goToTab(tester, 'Statistik');

    expect(find.text('Rata-rata durasi'), findsOneWidget);
    expect(find.text('Total tidur'), findsOneWidget);
    expect(find.text('Jumlah sesi'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.textContaining('Bukan diagnosis medis.'),
      300,
      scrollable: find
          .descendant(
            of: find.descendant(
              of: find.byType(StatisticsPage),
              matching: find.byType(ListView),
            ),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Bukan diagnosis medis.'), findsOneWidget);
  });

  testWidgets('Bottom navigation switches tabs', (tester) async {
    await _pumpApp(tester);

    expect(find.text('Dashboard'), findsOneWidget);

    await _goToTab(tester, 'Statistik');
    expect(find.text('Statistik'), findsWidgets);

    await _goToTab(tester, 'Dashboard');
    expect(find.text('Saya mau tidur'), findsOneWidget);
  });
}
