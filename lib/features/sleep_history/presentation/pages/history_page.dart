import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/time/clock_provider.dart';
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
///
/// The list is grouped under section dividers: sessions started today or
/// within the previous six calendar days under "7 Hari Terakhir", everything
/// older under "Lainnya" — the same window as `StatisticsRange.days7`.
class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, this.clock = const SystemClockProvider()});

  /// Clock used to split sessions into the two sections; injectable so
  /// widget tests can pin "now".
  final ClockProvider clock;

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
            final List<_HistoryEntry> entries = _entriesFor(
              state.sessions,
              widget.clock.nowUtc(),
            );
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
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) =>
                    switch (entries[index]) {
                  final _SessionCardEntry card => _HistoryCard(
                        session: card.session,
                        onTap: () => context
                            .read<HistoryBloc>()
                            .add(OpenSessionRequested(card.session.id)),
                      ),
                  final _SectionHeaderEntry header =>
                    _SectionHeader(title: header.title),
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  /// Splits [sessions] (newest first) into the labelled sections, preserving
  /// order. Empty sections are omitted entirely.
  static List<_HistoryEntry> _entriesFor(
    List<SleepSession> sessions,
    DateTime nowUtc,
  ) {
    final List<SleepSession> recent = <SleepSession>[];
    final List<SleepSession> older = <SleepSession>[];
    for (final SleepSession session in sessions) {
      if (_isWithinRecentDays(session, nowUtc)) {
        recent.add(session);
      } else {
        older.add(session);
      }
    }
    return <_HistoryEntry>[
      if (recent.isNotEmpty) ...<_HistoryEntry>[
        const _SectionHeaderEntry('7 Hari Terakhir'),
        for (final SleepSession session in recent)
          _SessionCardEntry(session),
      ],
      if (older.isNotEmpty) ...<_HistoryEntry>[
        const _SectionHeaderEntry('Lainnya'),
        for (final SleepSession session in older) _SessionCardEntry(session),
      ],
    ];
  }

  /// True when [session] starts today or within the previous six calendar
  /// days, evaluated in the session's own recorded UTC offset — the same
  /// window as `StatisticsRange.days7` (statistics_calculator.dart, the
  /// `range.days` cutoff).
  static bool _isWithinRecentDays(SleepSession session, DateTime nowUtc) {
    final DateTime startLocal = _shiftByOffset(
      session.startedAtUtc,
      session.startOffsetMinutes,
    );
    final DateTime nowLocal = _shiftByOffset(
      nowUtc,
      session.startOffsetMinutes,
    );
    final DateTime cutoff = DateTime(
      nowLocal.year,
      nowLocal.month,
      nowLocal.day,
    ).subtract(const Duration(days: 6));
    final DateTime startDay = DateTime(
      startLocal.year,
      startLocal.month,
      startLocal.day,
    );
    return !startDay.isBefore(cutoff);
  }

  static DateTime _shiftByOffset(DateTime utc, int offsetMinutes) =>
      DateTime.fromMillisecondsSinceEpoch(
        utc.millisecondsSinceEpoch + offsetMinutes * 60000,
        isUtc: true,
      );

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

/// One row of the history list: either a section divider or a session card.
sealed class _HistoryEntry {
  const _HistoryEntry();
}

/// Divider row: category label on the left, hairline rule filling the rest
/// of the row (DESIGN §7.1 grouping).
final class _SectionHeaderEntry extends _HistoryEntry {
  const _SectionHeaderEntry(this.title);

  final String title;
}

/// A [_HistoryCard] row for one session.
final class _SessionCardEntry extends _HistoryEntry {
  const _SessionCardEntry(this.session);

  final SleepSession session;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.md,
        bottom: AppSpacing.xs,
      ),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: AppTypography.caption.copyWith(
              color: Theme.of(context).hintColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Divider(color: Theme.of(context).dividerColor, height: 1),
          ),
        ],
      ),
    );
  }
}
