import 'package:flutter/material.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;

import 'app.dart';
import 'core/database/app_database.dart';
import 'core/platform/android_device_time_provider.dart';
import 'core/platform/android_platform_api.g.dart';
import 'core/theme/theme_mode_controller.dart';
import 'features/sleep_session/data/datasources/sleep_session_local_datasource.dart';
import 'features/sleep_session/data/repositories/sleep_session_repository_impl.dart';
import 'features/sleep_session/domain/usecases/delete_sleep_session.dart';
import 'features/sleep_session/domain/usecases/end_sleep_session.dart';
import 'features/sleep_session/domain/usecases/get_active_sleep_session.dart';
import 'features/sleep_session/domain/usecases/recover_active_session.dart';
import 'features/sleep_session/domain/usecases/start_sleep_session.dart';
import 'features/sleep_session/domain/usecases/update_sleep_session.dart';
import 'features/sleep_session/presentation/bloc/sleep_session_bloc.dart';
import 'features/wake_up/data/datasources/wake_up_local_datasource.dart';
import 'features/wake_up/data/platform/pigeon_wake_up_hardware.dart';
import 'features/wake_up/data/repositories/wake_up_repository_impl.dart';
import 'features/wake_up/domain/usecases/activate_wake_up_mode.dart';
import 'features/wake_up/domain/usecases/close_wake_up_mode.dart';
import 'features/wake_up/domain/usecases/restore_wake_up_state.dart';
import 'features/wake_up/presentation/bloc/wake_up_bloc.dart';

void main() {
  tzdata.initializeTimeZones();

  // Composition root: the only place that wires concrete implementations.
  final AppDatabase database = AppDatabase();
  final AndroidPlatformApi platformApi = AndroidPlatformApi();
  final AndroidDeviceTimeProvider timeProvider =
      AndroidDeviceTimeProvider(platformApi);
  final SleepSessionRepositoryImpl repository = SleepSessionRepositoryImpl(
    SleepSessionLocalDataSource(database),
  );

  final SleepSessionBloc sleepSessionBloc = SleepSessionBloc(
    startSleepSession: StartSleepSession(
      repository: repository,
      timeProvider: timeProvider,
    ),
    endSleepSession: EndSleepSession(
      repository: repository,
      timeProvider: timeProvider,
    ),
    getActiveSleepSession: GetActiveSleepSession(repository: repository),
    updateSleepSession: UpdateSleepSession(repository: repository),
    deleteSleepSession: DeleteSleepSession(repository: repository),
    recoverActiveSession: RecoverActiveSession(repository: repository),
  );

  final WakeUpRepositoryImpl wakeUpRepository = WakeUpRepositoryImpl(
    WakeUpLocalDataSource(database),
  );
  final WakeUpBloc wakeUpBloc = WakeUpBloc(
    activateWakeUpMode: ActivateWakeUpMode(
      repository: wakeUpRepository,
      hardware: PigeonWakeUpHardware(platformApi),
    ),
    closeWakeUpMode: CloseWakeUpMode(
      repository: wakeUpRepository,
      hardware: PigeonWakeUpHardware(platformApi),
    ),
    restoreWakeUpState: RestoreWakeUpState(repository: wakeUpRepository),
  );
  // Re-open an interrupted Wake-up Mode before the first frame (PRD §7.3).
  wakeUpBloc.add(const RestoreWakeUpRequested());

  runApp(
    FrenoozeApp(
      themeModeController: ThemeModeController(),
      sleepSessionBloc: sleepSessionBloc,
      wakeUpBloc: wakeUpBloc,
    ),
  );
}
