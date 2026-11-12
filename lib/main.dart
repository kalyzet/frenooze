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

  runApp(
    FrenoozeApp(
      themeModeController: ThemeModeController(),
      sleepSessionBloc: sleepSessionBloc,
    ),
  );
}
