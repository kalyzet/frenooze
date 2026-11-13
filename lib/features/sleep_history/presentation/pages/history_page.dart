import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../sleep_session/domain/entities/sleep_session.dart';
import '../../../sleep_session/domain/entities/time_accuracy.dart';
import '../../../sleep_session/domain/services/duration_calculator.dart';
import '../bloc/history_bloc.dart';
import 'history_detail_page.dart';

/// Sleep history list (DESIGN §7.1, PRD §4.5).
///
/// Newest session first. Each card shows the local start/end wall clock
/// derived from the stored UTC timestamp and recorded offset — never a
/// continuously running clock. An active session is listed with an explicit
/// "Berlangsung" status so incomplete records stay visible and recoverable
/// (PRD §7.4) without being mistaken for completed ones.
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(const LoadHistoryRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const LogoTitle('Riwayat Tidur')),
      body: BlocConsumer<HistoryBloc, HistoryState>(
        listener: (BuildContext context, HistoryState state) {
          if (state is HistoryLoaded && state.detailId != null) {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const HistoryDetailPage(),
              ),
            );
          }
        },
        builder: (BuildContext context, HistoryState state) {
          if (state is HistoryLoading || state is HistoryInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HistoryFailure) {
            return _errorView(context, state.message);
          }
          if (state is HistoryLoaded) {
            if (state.sessions.isEmpty) {
              return _emptyView(context);
            }
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<HistoryBloc>()
                    .add(const RefreshHistoryRequested());
                await context.read<HistoryBloc>().stream.firstWhere(
                      (HistoryState s) => s is HistoryLoaded,
                    );
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: state.sessions.length,
                itemBuilder: (BuildContext context, int index) {
                  final SleepSession session = state.sessions[index];
                  return _HistoryCard(
                    session: session,
                    onTap: () => context
                        .read<HistoryBloc>()
                        .add(OpenSessionRequested(session.id)),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _emptyView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.history, size: 48),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Belum ada riwayat tidur.',
              style: AppTypography.heading3,
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Mulai catat tidur pertamamu dari dashboard.',
              style: AppTypography.secondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: () {
                final ScaffoldMessengerState messenger =
                    ScaffoldMessenger.of(context);
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Buka Dashboard untuk mulai mencatat.'),
                  ),
                );
              },
              child: const Text('Buka Dashboard'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: () => context
                  .read<HistoryBloc>()
                  .add(const LoadHistoryRequested()),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.session, required this.onTap});

  final SleepSession session;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final SleepDuration result = const DurationCalculator().calculate(
      session,
    );
    final String dateLabel = _formatDate(session.startedAtUtc);
    final String startLabel = _formatClock(
      session.startedAtUtc,
      session.startOffsetMinutes,
    );
    final String endLabel = session.endedAtUtc == null
        ? '—'
        : _formatClock(
            session.endedAtUtc!,
            session.endOffsetMinutes ?? session.startOffsetMinutes,
          );
    final String durationLabel = session.isActive
        ? 'Berjalan…'
        : _formatDuration(result.duration);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      dateLabel,
                      style: AppTypography.heading3,
                    ),
                  ),
                  _StatusChip(session: session, accuracy: result.accuracy),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Mulai $startLabel  ·  Bangun $endLabel',
                style: AppTypography.secondary,
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                durationLabel,
                style: AppTypography.caption,
              ),
              if (session.isStartManual || session.isEndManual) ...<Widget>[
                const SizedBox(height: AppSpacing.xxs),
                const Text(
                  'Diesit manual',
                  style: AppTypography.caption,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _formatDate(DateTime utc) {
    final DateTime shifted = DateTime.fromMillisecondsSinceEpoch(
      utc.millisecondsSinceEpoch,
      isUtc: true,
    ).toLocal();
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${shifted.day} ${months[shifted.month - 1]} ${shifted.year}';
  }

  static String _formatClock(DateTime utc, int offsetMinutes) {
    final DateTime shifted = DateTime.fromMillisecondsSinceEpoch(
      utc.millisecondsSinceEpoch + offsetMinutes * 60000,
      isUtc: true,
    );
    final String hour = shifted.hour.toString().padLeft(2, '0');
    final String minute = shifted.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}j ${duration.inMinutes % 60}m';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    }
    return '${duration.inSeconds}d';
  }
}

/// Status pill that never relies on colour alone (DESIGN §11).
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.session, required this.accuracy});

  final SleepSession session;
  final TimeAccuracy accuracy;

  @override
  Widget build(BuildContext context) {
    final String label;
    final Color color;
    if (session.isActive) {
      label = 'Berlangsung';
      color = Theme.of(context).colorScheme.primary;
    } else if (accuracy == TimeAccuracy.invalid ||
        accuracy == TimeAccuracy.clockChanged ||
        accuracy == TimeAccuracy.bootChanged) {
      label = 'Perlu dicek';
      color = Theme.of(context).colorScheme.secondary;
    } else if (session.isStartManual || session.isEndManual ||
        accuracy == TimeAccuracy.manual) {
      label = 'Diesit manual';
      color = Theme.of(context).colorScheme.primary;
    } else {
      label = 'Tersimpan';
      color = Theme.of(context).colorScheme.secondary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(color: color),
      ),
    );
  }
}
