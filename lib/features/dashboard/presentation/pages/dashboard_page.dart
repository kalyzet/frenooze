import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../sleep_session/domain/entities/sleep_session.dart';
import '../../../sleep_session/domain/services/duration_calculator.dart';
import '../../../sleep_session/presentation/bloc/sleep_session_bloc.dart';

/// Dashboard with the Main Sleep Action Card (DESIGN §4.4).
///
/// Idle: one tap starts a session (PRD §4.2.1). Active: shows the start time
/// and the running duration derived from the stored timestamp — recomputed
/// on screen, never by a background timer (PRD §4.2.3).
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // Restore an interrupted session when the app is opened (PRD recovery).
    context.read<SleepSessionBloc>().add(const RecoverSessionRequested());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  /// Ticks only while a session runs so the duration display stays fresh
  /// without any background work when idle.
  void _syncTicker(SleepSessionState state) {
    final bool shouldTick = state is SleepSessionSleeping;
    if (shouldTick && _ticker == null) {
      _ticker = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (mounted) {
          setState(() {});
        }
      });
    } else if (!shouldTick && _ticker != null) {
      _ticker!.cancel();
      _ticker = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SleepSessionBloc, SleepSessionState>(
      listener: (BuildContext context, SleepSessionState state) {
        _syncTicker(state);
        final ScaffoldMessengerState messenger =
            ScaffoldMessenger.of(context);
        if (state is SleepSessionFailure) {
          messenger.showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is SleepSessionSuccess &&
            state.completed != null) {
          final SleepDuration result = const DurationCalculator()
              .calculate(state.completed!);
          messenger.showSnackBar(
            SnackBar(
              content: Text('Tidur tersimpan · ${_formatSummary(result.duration)}'),
            ),
          );
        }
      },
      builder: (BuildContext context, SleepSessionState state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Frenooze')),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text('Selamat malam', style: AppTypography.heading1),
                const SizedBox(height: AppSpacing.xs),
                const Text(
                  'Catat tidurmu dengan satu ketukan.',
                  style: AppTypography.secondary,
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildCard(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, SleepSessionState state) {
    if (state is SleepSessionSleeping) {
      return _activeCard(context, state.session);
    }
    if (state is SleepSessionCompleting) {
      return _loadingCard('Menyimpan sesi...');
    }
    if (state is SleepSessionInitial || state is SleepSessionLoading) {
      return _loadingCard('Memuat...');
    }
    // Idle, ReadyToSleep, Success and Failure all show the idle card so the
    // user always has a way forward.
    return _idleCard(
      context,
      onPressed: () => context
          .read<SleepSessionBloc>()
          .add(const StartSleepRequested()),
    );
  }

  Widget _idleCard(BuildContext context, {required VoidCallback onPressed}) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: <Widget>[
              Icon(Icons.bedtime, size: 48),
              SizedBox(height: AppSpacing.md),
              Text('Saya mau tidur', style: AppTypography.heading2),
              SizedBox(height: AppSpacing.xs),
              Text(
                'Satu ketukan untuk mulai mencatat.',
                style: AppTypography.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activeCard(BuildContext context, SleepSession session) {
    final Duration elapsed = const DurationCalculator()
        .running(session, DateTime.now().toUtc());
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.nightlight),
                SizedBox(width: AppSpacing.xs),
                Text('Sedang tidur', style: AppTypography.heading3),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Mulai pukul ${_formatClock(session.startedAtUtc, session.startOffsetMinutes)}',
              style: AppTypography.secondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              _formatRunning(elapsed),
              style: AppTypography.display,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: () => context
                  .read<SleepSessionBloc>()
                  .add(const EndSleepRequested()),
              child: const Text('Saya sudah bangun'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingCard(String label) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: <Widget>[
            const SizedBox(height: AppSpacing.xl),
            const CircularProgressIndicator(),
            const SizedBox(height: AppSpacing.md),
            Text(label, style: AppTypography.caption),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  /// Local wall-clock time for a recorded UTC timestamp and offset; the
  /// offset stored with the session is authoritative (ARCHITECTURE §8.2).
  static String _formatClock(DateTime utc, int offsetMinutes) {
    final DateTime shifted = DateTime.fromMillisecondsSinceEpoch(
      utc.millisecondsSinceEpoch + offsetMinutes * 60000,
      isUtc: true,
    );
    final String hour = shifted.hour.toString().padLeft(2, '0');
    final String minute = shifted.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String _formatRunning(Duration elapsed) {
    final String hours = elapsed.inHours.toString().padLeft(2, '0');
    final String minutes =
        (elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final String seconds =
        (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  static String _formatSummary(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}j ${duration.inMinutes % 60}m';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    }
    return '${duration.inSeconds}d';
  }
}
