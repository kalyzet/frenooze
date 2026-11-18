import 'package:fl_chart/fl_chart.dart';
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
  Duration duration = const Duration(hours: 7),
}) {
  // Default start is 12 hours ago so the session always lands inside the
  // default 7-day statistics window, whenever the suite runs.
  final DateTime start = startedAtUtc ??
      DateTime.now().toUtc().subtract(const Duration(hours: 12));
  final DateTime end = endedAtUtc ?? start.add(duration);
  return SleepSession(
    id: id,
    startedAtUtc: start,
    endedAtUtc: end,
    startTimezone: 'Asia/Jakarta',
    endTimezone: 'Asia/Jakarta',
    startOffsetMinutes: 420,
    endOffsetMinutes: 420,
    startElapsedMs: 0,
    endElapsedMs: end.difference(start).inMilliseconds,
    startBootCount: 1,
    endBootCount: 1,
    accuracy: TimeAccuracy.ok,
    createdAtUtc: start,
    updatedAtUtc: end,
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

Future<void> _scrollIntoView(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
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

    await _scrollIntoView(tester, find.textContaining('Bukan diagnosis medis.'));
    expect(find.textContaining('Bukan diagnosis medis.'), findsOneWidget);
  });

  testWidgets('Statistics daily chart shows unique hour labels',
      (tester) async {
    await _pumpApp(
      tester,
      sessions: <SleepSession>[
        _sampleSession(
          id: 'long',
          duration: const Duration(hours: 8, minutes: 54),
        ),
      ],
    );
    await _goToTab(tester, 'Statistik');
    await _scrollIntoView(tester, find.textContaining('Tren durasi harian'));

    // maxY used to be raw 10.235h: fl_chart drew both the 10h tick and
    // the max tick, each formatted "10j". The snapped axis shows 10j
    // exactly once and adds 12j as the new top label.
    expect(find.text('10j'), findsOneWidget);
    expect(find.text('12j'), findsOneWidget);
  });

  testWidgets('Statistics chart toggle switches bar and line chart',
      (tester) async {
    await _pumpApp(
      tester,
      sessions: <SleepSession>[_sampleSession()],
    );
    await _goToTab(tester, 'Statistik');
    await _scrollIntoView(tester, find.textContaining('Tren durasi harian'));

    expect(find.byType(BarChart), findsOneWidget);
    expect(find.byType(LineChart), findsNothing);

    await tester.tap(find.byIcon(Icons.show_chart_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.byType(BarChart), findsNothing);

    await tester.tap(find.byIcon(Icons.bar_chart_rounded));
    await tester.pumpAndSettle();
    expect(find.byType(BarChart), findsOneWidget);
    expect(find.byType(LineChart), findsNothing);
  });

  testWidgets('Statistics chart filters bottom labels above 7 points',
      (tester) async {
    // 10 consecutive local days: with 30-day range the trend has 10
    // points, so bottomInterval = 2 and only even indices keep a label.
    final DateTime nowLocal = DateTime.now();
    final DateTime todayLocal = DateTime(
      nowLocal.year,
      nowLocal.month,
      nowLocal.day,
    );
    String dayNumber(int daysAgo) =>
        '${todayLocal.subtract(Duration(days: daysAgo)).day}';

    await _pumpApp(
      tester,
      sessions: List<SleepSession>.generate(10, (int i) {
        // i = 0 is the oldest (9 days ago), i = 9 is today; 13:00 local
        // start keeps every session on its own local calendar day.
        final DateTime startLocal = todayLocal
            .subtract(Duration(days: 9 - i))
            .add(const Duration(hours: 13));
        return _sampleSession(
          id: 'd$i',
          startedAtUtc: startLocal.subtract(const Duration(minutes: 420)),
          duration: const Duration(hours: 7),
        );
      }),
    );
    await _goToTab(tester, 'Statistik');
    await tester.tap(find.text('30 hari'));
    await tester.pumpAndSettle();
    await _scrollIntoView(tester, find.textContaining('Tren durasi harian'));

    // Scope to the chart card so the "Jumlah sesi" metric (a bare
    // number) cannot collide with a day-of-month label.
    final Finder chartCard = find.ancestor(
      of: find.text('Tren durasi harian'),
      matching: find.byType(Card),
    );

    // Even indices (0, 2, 4, 6, 8) = days 9, 7, 5, 3, 1 ago.
    for (final int daysAgo in <int>[9, 7, 5, 3, 1]) {
      expect(
        find.descendant(of: chartCard, matching: find.text(dayNumber(daysAgo))),
        findsOneWidget,
        reason: 'day label ${daysAgo}d ago should be visible',
      );
    }
    // Odd indices (1, 3, 5, 7, 9) are filtered out.
    for (final int daysAgo in <int>[8, 6, 4, 2, 0]) {
      expect(
        find.descendant(of: chartCard, matching: find.text(dayNumber(daysAgo))),
        findsNothing,
        reason: 'day label ${daysAgo}d ago should be filtered out',
      );
    }
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
