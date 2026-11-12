import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../sleep_session/domain/entities/sleep_session.dart';
import '../../../sleep_session/domain/services/duration_calculator.dart';
import '../bloc/wake_up_bloc.dart';

/// Full-screen Wake-up Experience (DESIGN §6.3, PRD §4.4).
///
/// Shown as an overlay above the shell while the mode is active so the
/// bottom navigation cannot dismiss it by accident (PRD §4.4.3). The small
/// close button is the only exit and dispatches an idempotent close.
class WakeUpPage extends StatefulWidget {
  const WakeUpPage({super.key});

  @override
  State<WakeUpPage> createState() => _WakeUpPageState();
}

class _WakeUpPageState extends State<WakeUpPage>
    with SingleTickerProviderStateMixin {
  Timer? _ticker;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    // Refresh the live clock once a second while the page is visible.
    _ticker = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {});
      }
    });
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WakeUpBloc, WakeUpState>(
      builder: (BuildContext context, WakeUpState state) {
        final SleepSession? session = switch (state) {
          WakeUpActivating(:final completedSession) => completedSession,
          WakeUpActive(:final completedSession) => completedSession,
          _ => null,
        };
        final bool armed = state is WakeUpActive;
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: armed
                          ? () => context
                              .read<WakeUpBloc>()
                              .add(const CloseWakeUpRequested())
                          : null,
                      icon: const Icon(Icons.close),
                      tooltip: 'Tutup',
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.wb_sunny,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    _greeting(),
                    style: AppTypography.heading1,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  const Text(
                    'Sesi tidur sudah tersimpan.',
                    style: AppTypography.secondary,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (session != null) _summaryCard(session),
                  const SizedBox(height: AppSpacing.lg),
                  _statusIndicator(armed: armed),
                  const Spacer(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Time-of-day greeting; the app itself never infers state from the clock
  /// for logic, only for this friendly label (DESIGN §6.3).
  static String _greeting() {
    final int hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) {
      return 'Selamat pagi!';
    }
    if (hour >= 11 && hour < 15) {
      return 'Selamat siang!';
    }
    if (hour >= 15 && hour < 18) {
      return 'Selamat sore!';
    }
    return 'Selamat malam!';
  }

  Widget _summaryCard(SleepSession session) {
    final SleepDuration result = const DurationCalculator().calculate(session);
    // Completed sessions always carry an end; fall back to the start offset
    // only for the rare record missing an end offset.
    final DateTime ended = session.endedAtUtc ?? session.startedAtUtc;
    final int endOffset = session.endOffsetMinutes ?? session.startOffsetMinutes;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: <Widget>[
            Text(
              'Tidur ${_formatSummary(result.duration)}',
              style: AppTypography.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${_formatClock(session.startedAtUtc, session.startOffsetMinutes)}'
              ' – '
              '${_formatClock(ended, endOffset)}',
              style: AppTypography.secondary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusIndicator({required bool armed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FadeTransition(
          opacity: Tween<double>(begin: 0.35, end: 1.0).animate(_pulse),
          child: Icon(
            armed ? Icons.vibration : Icons.hourglass_empty,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          armed ? 'Getaran aktif' : 'Mengaktifkan...',
          style: AppTypography.caption,
        ),
      ],
    );
  }

  /// Same local wall-clock formatting as the dashboard (ARCHITECTURE §8.2).
  static String _formatClock(DateTime utc, int offsetMinutes) {
    final DateTime shifted = DateTime.fromMillisecondsSinceEpoch(
      utc.millisecondsSinceEpoch + offsetMinutes * 60000,
      isUtc: true,
    );
    final String hour = shifted.hour.toString().padLeft(2, '0');
    final String minute = shifted.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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
