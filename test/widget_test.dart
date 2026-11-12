import 'package:flutter_test/flutter_test.dart';

import 'package:frenooze/app.dart';
import 'package:frenooze/core/platform/device_time_provider.dart';
import 'package:frenooze/core/theme/theme_mode_controller.dart';
import 'package:frenooze/features/sleep_history/presentation/bloc/history_bloc.dart';
import 'package:frenooze/features/sleep_session/domain/entities/sleep_session.dart';
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
import 'package:frenooze/features/wake_up/domain/entities/wake_up_status.dart';
import 'package:frenooze/features/wake_up/domain/repositories/wake_up_repository.dart';
import 'package:frenooze/features/wake_up/domain/services/wake_up_hardware.dart';
import 'package:frenooze/features/wake_up/domain/usecases/activate_wake_up_mode.dart';
import 'package:frenooze/features/wake_up/domain/usecases/close_wake_up_mode.dart';
import 'package:frenooze/features/wake_up/domain/usecases/restore_wake_up_state.dart';
import 'package:frenooze/features/wake_up/presentation/bloc/wake_up_bloc.dart';

class _FakeSleepSessionRepository implements SleepSessionRepository {
  @override
  Future<SleepSession?> getActiveSession() async => null;

  @override
  Future<SleepSession?> getById(String id) async => null;

  @override
  Future<List<SleepSession>> getAll() async => <SleepSession>[];

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

void main() {
  testWidgets('Dashboard renders sleep action card', (
    WidgetTester tester,
  ) async {
    final SleepSessionBloc sleepBloc = SleepSessionBloc(
      startSleepSession: StartSleepSession(
        repository: _FakeSleepSessionRepository(),
        timeProvider: _FakeDeviceTimeProvider(),
      ),
      endSleepSession: EndSleepSession(
        repository: _FakeSleepSessionRepository(),
        timeProvider: _FakeDeviceTimeProvider(),
      ),
      getActiveSleepSession: GetActiveSleepSession(
        repository: _FakeSleepSessionRepository(),
      ),
      updateSleepSession: UpdateSleepSession(
        repository: _FakeSleepSessionRepository(),
      ),
      deleteSleepSession: DeleteSleepSession(
        repository: _FakeSleepSessionRepository(),
      ),
      recoverActiveSession: RecoverActiveSession(
        repository: _FakeSleepSessionRepository(),
      ),
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

    final _FakeSleepSessionRepository historyRepo = _FakeSleepSessionRepository();
    final HistoryBloc historyBloc = HistoryBloc(
      getSleepSessions: GetSleepSessions(repository: historyRepo),
      getSleepSessionById: GetSleepSessionById(repository: historyRepo),
      updateSleepSession: UpdateSleepSession(repository: historyRepo),
      deleteSleepSession: DeleteSleepSession(repository: historyRepo),
    );
    addTearDown(historyBloc.close);

    final StatisticsBloc statisticsBloc = StatisticsBloc(
      getSleepStatistics: GetSleepStatistics(repository: historyRepo),
    );
    addTearDown(statisticsBloc.close);

    await tester.pumpWidget(
      FrenoozeApp(
        themeModeController: ThemeModeController(),
        sleepSessionBloc: sleepBloc,
        wakeUpBloc: wakeBloc,
        historyBloc: historyBloc,
        statisticsBloc: statisticsBloc,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Saya mau tidur'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
