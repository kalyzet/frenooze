import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frenooze/core/database/app_database.dart';
import 'package:frenooze/features/sleep_session/data/datasources/sleep_session_local_datasource.dart';
import 'package:frenooze/features/sleep_session/data/repositories/sleep_session_repository_impl.dart';
import 'package:frenooze/features/sleep_session/domain/entities/sleep_session.dart';
import 'package:frenooze/features/wake_up/data/datasources/wake_up_local_datasource.dart';
import 'package:frenooze/features/wake_up/data/repositories/wake_up_repository_impl.dart';
import 'package:frenooze/main.dart' as app;
import 'package:integration_test/integration_test.dart';

/// Pumps frames until [finder] matches, bounded so a broken flow fails fast
/// with the last state instead of hanging (the wake-up overlay animates
/// forever, so `pumpAndSettle` must never be used while it is mounted).
Future<void> _waitFor(
  WidgetTester tester,
  Finder finder, {
  int maxIterations = 60,
}) async {
  for (int i = 0; i < maxIterations; i++) {
    if (tester.any(finder)) {
      return;
    }
    await tester.pump(const Duration(milliseconds: 250));
  }
  final String snack = tester.any(find.byType(SnackBar))
      ? tester
          .widgetList<Text>(
            find.descendant(
              of: find.byType(SnackBar),
              matching: find.byType(Text),
            ),
          )
          .map((Text text) => text.data ?? '')
          .join(' | ')
      : 'tidak ada';
  expect(
    tester.any(finder),
    isTrue,
    reason: 'Widget tidak muncul dalam batas waktu: $finder '
        '(snackbar: $snack)',
  );
}

Future<void> _waitUntilGone(
  WidgetTester tester,
  Finder finder, {
  int maxIterations = 60,
}) async {
  for (int i = 0; i < maxIterations; i++) {
    if (!tester.any(finder)) {
      return;
    }
    await tester.pump(const Duration(milliseconds: 250));
  }
  expect(
    tester.any(finder),
    isFalse,
    reason: 'Widget tidak hilang dalam batas waktu: $finder',
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // The test's verification connection and the app's own connection are
  // separate executors on the same file (shareAcrossIsolates is off), so
  // drift's instance-count warning does not apply here.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets(
    'Alur lengkap: tidur, bangun, wake-up, riwayat, statistik',
    (WidgetTester tester) async {
      final AppDatabase database = AppDatabase();
      final SleepSessionRepositoryImpl repository =
          SleepSessionRepositoryImpl(SleepSessionLocalDataSource(database));
      final WakeUpRepositoryImpl wakeUpRepository = WakeUpRepositoryImpl(
        WakeUpLocalDataSource(database),
      );

      // Clean slate: a crash from an earlier run must not leave an active
      // session or an armed wake-up mode behind.
      final SleepSession? staleActive = await repository.getActiveSession();
      if (staleActive != null) {
        await repository.update(
          SleepSession(
            id: staleActive.id,
            startedAtUtc: staleActive.startedAtUtc,
            endedAtUtc: staleActive.startedAtUtc.add(
              const Duration(minutes: 1),
            ),
            startTimezone: staleActive.startTimezone,
            endTimezone: staleActive.startTimezone,
            startOffsetMinutes: staleActive.startOffsetMinutes,
            endOffsetMinutes: staleActive.startOffsetMinutes,
            startElapsedMs: staleActive.startElapsedMs,
            endElapsedMs: staleActive.startElapsedMs + 60000,
            startBootCount: staleActive.startBootCount,
            endBootCount: staleActive.startBootCount,
            createdAtUtc: staleActive.createdAtUtc,
            updatedAtUtc: staleActive.startedAtUtc.add(
              const Duration(minutes: 1),
            ),
          ),
        );
      }
      await wakeUpRepository.markInactive();
      final List<String> preexistingIds = (await repository.getAll())
          .map((SleepSession session) => session.id)
          .toList(growable: false);

      try {
        app.main();
        await tester.pump(const Duration(milliseconds: 500));

        // 1. Dashboard: start a session with one tap (PRD §4.2.1).
        await _waitFor(tester, find.text('Saya mau tidur'));
        await tester.tap(find.text('Saya mau tidur'));
        await _waitFor(tester, find.text('Sedang tidur'));
        expect(find.text('Saya sudah bangun'), findsOneWidget);

        // 2. End it immediately; the record is saved before the wake-up
        // flow starts (PRD §4.3). The overlay mounts in the Activating
        // state first, so wait for the armed state instead of asserting
        // at the first frame.
        await tester.tap(find.text('Saya sudah bangun'));
        await _waitFor(tester, find.byTooltip('Tutup'));
        await _waitFor(tester, find.text('Getaran aktif'));

        // 3. Close the wake-up overlay (the only exit, PRD §4.4.3).
        await tester.tap(find.byTooltip('Tutup'));
        await _waitUntilGone(tester, find.byTooltip('Tutup'));
        expect(find.text('Saya mau tidur'), findsOneWidget);

        // The session row exists and is completed.
        final List<SleepSession> all = await repository.getAll();
        final List<SleepSession> created = all
            .where(
              (SleepSession session) => !preexistingIds.contains(session.id),
            )
            .toList(growable: false);
        expect(created, hasLength(1));
        expect(created.single.endedAtUtc, isNotNull);

        // 4. History shows the fresh entry (RefreshHistoryRequested ran in
        // the app listener when the session completed).
        await tester.tap(find.text('Riwayat'));
        await _waitFor(tester, find.widgetWithText(AppBar, 'Riwayat Tidur'));
        await _waitFor(tester, find.textContaining('·  Bangun'));
        expect(find.text('Tersimpan'), findsWidgets);

        // 5. Statistics recomputed with the new session (PRD §4.8).
        await tester.tap(find.text('Statistik'));
        await _waitFor(tester, find.widgetWithText(AppBar, 'Statistik'));
        expect(find.text('Jumlah sesi'), findsOneWidget);
        expect(find.text('Belum ada data untuk periode ini.'), findsNothing);
      } finally {
        // Teardown: remove every session created by this run and rearm a
        // clean wake-up mode so the device is left exactly as found.
        final List<SleepSession> all = await repository.getAll();
        for (final SleepSession session in all) {
          if (!preexistingIds.contains(session.id)) {
            await repository.delete(session.id);
          }
        }
        await wakeUpRepository.markInactive();
        await database.close();
      }
    },
  );
}
