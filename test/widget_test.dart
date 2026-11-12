import 'package:flutter_test/flutter_test.dart';

import 'package:frenooze/app.dart';
import 'package:frenooze/core/platform/device_time_provider.dart';
import 'package:frenooze/core/theme/theme_mode_controller.dart';
import 'package:frenooze/features/sleep_session/domain/entities/sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/repositories/sleep_session_repository.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/delete_sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/end_sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/get_active_sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/recover_active_session.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/start_sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/update_sleep_session.dart';
import 'package:frenooze/features/sleep_session/presentation/bloc/sleep_session_bloc.dart';

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

void main() {
  testWidgets('Dashboard renders sleep action card', (
    WidgetTester tester,
  ) async {
    final SleepSessionBloc bloc = SleepSessionBloc(
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
    addTearDown(bloc.close);

    await tester.pumpWidget(
      FrenoozeApp(
        themeModeController: ThemeModeController(),
        sleepSessionBloc: bloc,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Saya mau tidur'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
