import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frenooze/features/sleep_session/domain/entities/sleep_session.dart';
import 'package:frenooze/features/wake_up/domain/entities/wake_up_status.dart';
import 'package:frenooze/features/wake_up/domain/repositories/wake_up_repository.dart';
import 'package:frenooze/features/wake_up/domain/services/wake_up_hardware.dart';
import 'package:frenooze/features/wake_up/domain/usecases/activate_wake_up_mode.dart';
import 'package:frenooze/features/wake_up/domain/usecases/close_wake_up_mode.dart';
import 'package:frenooze/features/wake_up/domain/usecases/restore_wake_up_state.dart';
import 'package:frenooze/features/wake_up/presentation/bloc/wake_up_bloc.dart';
import 'package:frenooze/features/wake_up/presentation/pages/wake_up_page.dart';

/// Repository fake that records every call so tests can assert the PRD
/// ordering (persist status -> hardware, and stop hardware -> persist off).
class _RecordingWakeUpRepository implements WakeUpRepository {
  _RecordingWakeUpRepository({required this.initiallyActive});

  bool initiallyActive;
  final List<String> events = <String>[];

  @override
  Future<WakeUpStatus> getActive() async {
    if (initiallyActive) {
      return WakeUpStatus(
        isActive: true,
        activatedAtUtc: DateTime.utc(2026, 11, 10, 21),
        relatedSessionId: 'sess-1',
        updatedAtUtc: DateTime.utc(2026, 11, 10, 21),
      );
    }
    return WakeUpStatus.inactive();
  }

  @override
  Future<WakeUpStatus> markActive(String relatedSessionId) async {
    events.add('markActive:$relatedSessionId');
    initiallyActive = true;
    return WakeUpStatus(
      isActive: true,
      activatedAtUtc: DateTime.utc(2026, 11, 10, 21),
      relatedSessionId: relatedSessionId,
      updatedAtUtc: DateTime.utc(2026, 11, 10, 21),
    );
  }

  @override
  Future<WakeUpStatus> markInactive() async {
    events.add('markInactive');
    initiallyActive = false;
    return WakeUpStatus.inactive();
  }
}

class _RecordingWakeUpHardware implements WakeUpHardware {
  final List<String> events = <String>[];

  /// When true the first arming call throws, exercising the best-effort
  /// hardware path of `ActivateWakeUpMode` (PRD §4.4 still requires a
  /// reachable close button).
  bool failKeepScreenOn = false;

  @override
  Future<void> startVibration() async {
    events.add('startVibration');
  }

  @override
  Future<void> stopVibration() async {
    events.add('stopVibration');
  }

  @override
  Future<void> keepScreenOn() async {
    events.add('keepScreenOn');
    if (failKeepScreenOn) {
      throw Exception('window flag denied');
    }
  }

  @override
  Future<void> releaseScreenOn() async {
    events.add('releaseScreenOn');
  }
}

WakeUpBloc _buildBloc({
  required WakeUpRepository repository,
  required WakeUpHardware hardware,
}) => WakeUpBloc(
  activateWakeUpMode: ActivateWakeUpMode(
    repository: repository,
    hardware: hardware,
  ),
  closeWakeUpMode: CloseWakeUpMode(
    repository: repository,
    hardware: hardware,
  ),
  restoreWakeUpState: RestoreWakeUpState(repository: repository),
);

/// Completed session: 14:00Z -> 21:00Z (7h) with WIB offset (+420).
SleepSession _completedSession() => SleepSession(
  id: 'sess-1',
  startedAtUtc: DateTime.utc(2026, 11, 10, 14),
  endedAtUtc: DateTime.utc(2026, 11, 10, 21),
  startTimezone: 'Asia/Jakarta',
  endTimezone: 'Asia/Jakarta',
  startOffsetMinutes: 420,
  endOffsetMinutes: 420,
  startElapsedMs: 1000,
  // Start + exactly 7h of monotonic time, matching the UTC wall clock so
  // DurationCalculator reports TimeAccuracy.ok and a clean "7j 0m".
  endElapsedMs: 25201000,
  startBootCount: 1,
  endBootCount: 1,
  createdAtUtc: DateTime.utc(2026, 11, 10, 21),
  updatedAtUtc: DateTime.utc(2026, 11, 10, 21),
);

/// The page keeps a repeating pulse animation and a one-second ticker, so
/// every test must unmount it before finishing (no `pumpAndSettle` either).
Future<void> _unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
}

void main() {
  testWidgets('Restore aktif: getaran aktif, close berhenti getaran', (
    WidgetTester tester,
  ) async {
    final _RecordingWakeUpRepository repository = _RecordingWakeUpRepository(
      initiallyActive: true,
    );
    final _RecordingWakeUpHardware hardware = _RecordingWakeUpHardware();
    final WakeUpBloc bloc = _buildBloc(
      repository: repository,
      hardware: hardware,
    );
    addTearDown(bloc.close);

    bloc.add(const RestoreWakeUpRequested());
    await tester.idle();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<WakeUpBloc>.value(
          value: bloc,
          child: const WakeUpPage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Sesi tidur sudah tersimpan.'), findsOneWidget);
    expect(find.text('Getaran aktif'), findsOneWidget);
    final IconButton close = tester.widget<IconButton>(find.byType(IconButton));
    expect(close.onPressed, isNotNull);

    await tester.tap(find.byTooltip('Tutup'));
    await tester.idle();
    await tester.pump();

    expect(hardware.events, <String>['stopVibration', 'releaseScreenOn']);
    expect(repository.events, <String>['markInactive']);
    expect(find.text('Mengaktifkan...'), findsOneWidget);

    await _unmount(tester);
  });

  testWidgets('Restore non-aktif: tanpa ringkasan, close dinonaktifkan', (
    WidgetTester tester,
  ) async {
    final _RecordingWakeUpRepository repository = _RecordingWakeUpRepository(
      initiallyActive: false,
    );
    final _RecordingWakeUpHardware hardware = _RecordingWakeUpHardware();
    final WakeUpBloc bloc = _buildBloc(
      repository: repository,
      hardware: hardware,
    );
    addTearDown(bloc.close);

    bloc.add(const RestoreWakeUpRequested());
    await tester.idle();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<WakeUpBloc>.value(
          value: bloc,
          child: const WakeUpPage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Mengaktifkan...'), findsOneWidget);
    expect(find.text('Getaran aktif'), findsNothing);
    final IconButton close = tester.widget<IconButton>(find.byType(IconButton));
    expect(close.onPressed, isNull);
    expect(hardware.events, isEmpty);
    expect(repository.events, isEmpty);

    await _unmount(tester);
  });

  testWidgets('Aktivasi membawa sesi: ringkasan durasi + getaran diarm', (
    WidgetTester tester,
  ) async {
    final _RecordingWakeUpRepository repository = _RecordingWakeUpRepository(
      initiallyActive: false,
    );
    final _RecordingWakeUpHardware hardware = _RecordingWakeUpHardware();
    final WakeUpBloc bloc = _buildBloc(
      repository: repository,
      hardware: hardware,
    );
    addTearDown(bloc.close);

    bloc.add(ActivateWakeUpRequested(_completedSession()));
    await tester.idle();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<WakeUpBloc>.value(
          value: bloc,
          child: const WakeUpPage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Tidur 7j 0m'), findsOneWidget);
    expect(find.text('Getaran aktif'), findsOneWidget);
    // PRD §4.4.1 order: persist active, then screen on, then vibration.
    expect(
      repository.events,
      <String>['markActive:sess-1'],
    );
    expect(
      hardware.events,
      <String>['keepScreenOn', 'startVibration'],
    );

    await _unmount(tester);
  });

  testWidgets('Gagal arming layar: mode tetap aktif dan close tetap jalan', (
    WidgetTester tester,
  ) async {
    final _RecordingWakeUpRepository repository = _RecordingWakeUpRepository(
      initiallyActive: false,
    );
    final _RecordingWakeUpHardware hardware = _RecordingWakeUpHardware()
      ..failKeepScreenOn = true;
    final WakeUpBloc bloc = _buildBloc(
      repository: repository,
      hardware: hardware,
    );
    addTearDown(bloc.close);

    bloc.add(ActivateWakeUpRequested(_completedSession()));
    await tester.idle();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<WakeUpBloc>.value(
          value: bloc,
          child: const WakeUpPage(),
        ),
      ),
    );
    await tester.pump();

    // Status was persisted before the hardware failure, so the close button
    // must remain reachable (PRD §4.4 best-effort arming).
    expect(find.text('Getaran aktif'), findsOneWidget);
    final IconButton close = tester.widget<IconButton>(find.byType(IconButton));
    expect(close.onPressed, isNotNull);

    await tester.tap(find.byTooltip('Tutup'));
    await tester.idle();
    await tester.pump();

    expect(hardware.events, <String>[
      'keepScreenOn',
      'stopVibration',
      'releaseScreenOn',
    ]);
    expect(repository.events, <String>[
      'markActive:sess-1',
      'markInactive',
    ]);

    await _unmount(tester);
  });
}
