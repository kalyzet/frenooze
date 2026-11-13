import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frenooze/features/sleep_history/presentation/bloc/history_bloc.dart';
import 'package:frenooze/features/sleep_history/presentation/pages/history_edit_page.dart';
import 'package:frenooze/features/sleep_session/domain/entities/sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/entities/time_accuracy.dart';
import 'package:frenooze/features/sleep_session/domain/repositories/sleep_session_repository.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/delete_sleep_session.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/get_sleep_session_by_id.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/get_sleep_sessions.dart';
import 'package:frenooze/features/sleep_session/domain/usecases/update_sleep_session.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;

/// Mutable in-memory repository so tests can assert what was persisted.
class _FakeSleepSessionRepository implements SleepSessionRepository {
  _FakeSleepSessionRepository(this.sessions);

  final List<SleepSession> sessions;
  final List<SleepSession> updates = <SleepSession>[];

  @override
  Future<SleepSession?> getActiveSession() async {
    for (final SleepSession session in sessions) {
      if (session.isActive) {
        return session;
      }
    }
    return null;
  }

  @override
  Future<SleepSession?> getById(String id) async {
    for (final SleepSession session in sessions) {
      if (session.id == id) {
        return session;
      }
    }
    return null;
  }

  @override
  Future<List<SleepSession>> getAll() async => sessions;

  @override
  Future<void> insert(SleepSession session) async {
    sessions.add(session);
  }

  @override
  Future<void> update(SleepSession session) async {
    updates.add(session);
    final int index = sessions.indexWhere(
      (SleepSession stored) => stored.id == session.id,
    );
    if (index >= 0) {
      sessions[index] = session;
    }
  }

  @override
  Future<void> delete(String id) async {
    sessions.removeWhere((SleepSession stored) => stored.id == id);
  }
}

/// Stand-in for the history list so the edit page is pushed exactly like the
/// real flow and `Navigator.pop()` after a save returns to something.
class _HistoryShell extends StatefulWidget {
  const _HistoryShell();

  @override
  State<_HistoryShell> createState() => _HistoryShellState();
}

class _HistoryShellState extends State<_HistoryShell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const HistoryEditPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('Riwayat'));
}

HistoryBloc _buildBloc(_FakeSleepSessionRepository repository) => HistoryBloc(
  getSleepSessions: GetSleepSessions(repository: repository),
  getSleepSessionById: GetSleepSessionById(repository: repository),
  updateSleepSession: UpdateSleepSession(repository: repository),
  deleteSleepSession: DeleteSleepSession(repository: repository),
);

/// Completed session: 10 Nov 14:00Z -> 21:00Z with WIB (+420), so the
/// hydrated local wall-clock labels are 10 Nov 21:00 -> 11 Nov 04:00.
SleepSession _completedSession() => SleepSession(
  id: 's-done',
  startedAtUtc: DateTime.utc(2026, 11, 10, 14),
  endedAtUtc: DateTime.utc(2026, 11, 10, 21),
  startTimezone: 'Asia/Jakarta',
  endTimezone: 'Asia/Jakarta',
  startOffsetMinutes: 420,
  endOffsetMinutes: 420,
  startElapsedMs: 1000,
  endElapsedMs: 26201000,
  startBootCount: 1,
  endBootCount: 1,
  createdAtUtc: DateTime.utc(2026, 11, 10, 21),
  updatedAtUtc: DateTime.utc(2026, 11, 10, 21),
);

SleepSession _activeSession() => SleepSession(
  id: 's-live',
  startedAtUtc: DateTime.utc(2026, 11, 12, 22),
  startTimezone: 'Asia/Jakarta',
  startOffsetMinutes: 420,
  startElapsedMs: 5000,
  startBootCount: 2,
  createdAtUtc: DateTime.utc(2026, 11, 12, 22),
  updatedAtUtc: DateTime.utc(2026, 11, 12, 22),
);

/// Seeds the bloc with one open detail, then pushes the edit page over the
/// shell. The bloc state is ready before the page hydrates.
Future<HistoryBloc> _seedAndPush(
  WidgetTester tester,
  _FakeSleepSessionRepository repository,
  String sessionId,
) async {
  final HistoryBloc bloc = _buildBloc(repository);
  addTearDown(bloc.close);
  bloc.add(OpenSessionRequested(sessionId));
  await tester.idle();

  // The provider must sit above the Navigator so pushed routes can read it.
  await tester.pumpWidget(
    BlocProvider<HistoryBloc>.value(
      value: bloc,
      child: const MaterialApp(home: _HistoryShell()),
    ),
  );
  await tester.pumpAndSettle();
  expect(find.byType(HistoryEditPage), findsOneWidget);
  return bloc;
}

void main() {
  setUpAll(tzdata.initializeTimeZones);

  testWidgets('Form edit sesi selesai menampilkan semua field', (
    WidgetTester tester,
  ) async {
    final _FakeSleepSessionRepository repository =
        _FakeSleepSessionRepository(<SleepSession>[_completedSession()]);
    await _seedAndPush(tester, repository, 's-done');

    expect(find.text('Edit Sesi'), findsOneWidget);
    expect(find.text('Waktu mulai'), findsOneWidget);
    expect(find.text('Waktu bangun'), findsOneWidget);
    expect(find.text('Zona waktu'), findsOneWidget);
    expect(find.text('Simpan perubahan'), findsOneWidget);

    // Hydrated from the stored row: WIB labels, not host timezone.
    expect(find.text('10 Nov 2026'), findsOneWidget);
    expect(find.text('21:00'), findsOneWidget);
    expect(find.text('11 Nov 2026'), findsOneWidget);
    expect(find.text('04:00'), findsOneWidget);
    expect(find.text('WIB (Asia/Jakarta)'), findsOneWidget);
  });

  testWidgets('Sesi berlangsung hanya menampilkan waktu mulai', (
    WidgetTester tester,
  ) async {
    final _FakeSleepSessionRepository repository =
        _FakeSleepSessionRepository(<SleepSession>[_activeSession()]);
    await _seedAndPush(tester, repository, 's-live');

    expect(find.text('Waktu mulai'), findsOneWidget);
    expect(find.text('Waktu bangun'), findsNothing);
    expect(
      find.textContaining('Sesi masih berlangsung'),
      findsOneWidget,
    );
    expect(find.text('WIB (Asia/Jakarta)'), findsOneWidget);
  });

  testWidgets('Validasi menolak bangun sebelum mulai', (
    WidgetTester tester,
  ) async {
    final _FakeSleepSessionRepository repository =
        _FakeSleepSessionRepository(<SleepSession>[_completedSession()]);
    await _seedAndPush(tester, repository, 's-done');

    // Move the wake date back to the start day (10 Nov, 04:00 < 21:00).
    await tester.tap(find.text('11 Nov 2026'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('10'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simpan perubahan'));
    await tester.pumpAndSettle();

    expect(
      find.text('Waktu bangun harus setelah waktu mulai.'),
      findsOneWidget,
    );
    expect(find.byType(HistoryEditPage), findsOneWidget);
    expect(repository.updates, isEmpty);
  });

  testWidgets('Simpan perubahan zona waktu menandai edit manual', (
    WidgetTester tester,
  ) async {
    final _FakeSleepSessionRepository repository =
        _FakeSleepSessionRepository(<SleepSession>[_completedSession()]);
    await _seedAndPush(tester, repository, 's-done');

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('WITA (Asia/Makassar)'));
    await tester.pumpAndSettle();
    expect(find.text('WITA (Asia/Makassar)'), findsOneWidget);

    await tester.tap(find.text('Simpan perubahan'));
    await tester.idle();
    await tester.pumpAndSettle();

    // Save succeeded: the page popped back to the history shell.
    expect(find.byType(HistoryEditPage), findsNothing);
    expect(find.text('Riwayat'), findsOneWidget);

    expect(repository.updates, hasLength(1));
    final SleepSession saved = repository.updates.single;
    expect(saved.startTimezone, 'Asia/Makassar');
    expect(saved.endTimezone, 'Asia/Makassar');
    // Changing the zone shifts the stored UTC instant -> manual edit stamp.
    expect(saved.isStartManual, isTrue);
    expect(saved.accuracy, TimeAccuracy.manual);
    expect(saved.updatedAtUtc.isAfter(DateTime.utc(2026, 11, 10, 21)), isTrue);
  });
}
