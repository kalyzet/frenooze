import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../sleep_session/domain/entities/sleep_session.dart';
import '../../../sleep_session/domain/entities/time_accuracy.dart';
import '../../../sleep_session/domain/services/duration_calculator.dart';
import '../bloc/history_bloc.dart';
import 'history_edit_page.dart';

/// Full detail of one sleep session with edit / delete actions
/// (DESIGN §7.2–7.3, PRD §4.5).
///
/// Mutations go through [HistoryBloc]; after a successful delete the bloc
/// clears `detailId` and this route pops back to the refreshed list.
class HistoryDetailPage extends StatelessWidget {
  const HistoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HistoryBloc, HistoryState>(
      listener: (BuildContext context, HistoryState state) {
        if (state is HistoryLoaded && state.detailId == null) {
          Navigator.of(context).pop();
          return;
        }
        if (state is HistoryFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (BuildContext context, HistoryState state) {
        if (state is! HistoryLoaded || state.detail == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Sesi')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        final SleepSession session = state.detail!;
        final SleepDuration result =
            const DurationCalculator().calculate(session);
        final bool busy = state.busy;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Sesi'),
            actions: <Widget>[
              IconButton(
                tooltip: 'Edit sesi',
                icon: const Icon(Icons.edit_outlined),
                onPressed: busy
                    ? null
                    : () {
                        Navigator.of(context).push<void>(
                          MaterialPageRoute<void>(
                            builder: (_) => const HistoryEditPage(),
                          ),
                        );
                      },
              ),
              IconButton(
                tooltip: 'Hapus sesi',
                icon: busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete_outline),
                onPressed: busy ? null : () => _confirmDelete(context, session),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        session.isActive
                            ? 'Sesi masih berlangsung'
                            : _formatDuration(result.duration),
                        style: AppTypography.display,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        session.isActive
                            ? 'Belum dianggap selesai — durasi tidak dihitung.'
                            : _accuracyLabel(session, result.accuracy),
                        style: AppTypography.caption,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: <Widget>[
                      _row(
                        'Mulai',
                        _formatLocal(
                          session.startedAtUtc,
                          session.startOffsetMinutes,
                        ),
                      ),
                      const Divider(height: AppSpacing.sm),
                      _row(
                        'Bangun',
                        session.endedAtUtc == null
                            ? 'Masih berlangsung'
                            : _formatLocal(
                                session.endedAtUtc!,
                                session.endOffsetMinutes ??
                                    session.startOffsetMinutes,
                              ),
                      ),
                      const Divider(height: AppSpacing.sm),
                      _row(
                        'Zona waktu mulai',
                        _timezoneLabel(session.startTimezone),
                      ),
                      const Divider(height: AppSpacing.sm),
                      _row(
                        'Zona waktu bangun',
                        session.endTimezone == null
                            ? '—'
                            : _timezoneLabel(session.endTimezone!),
                      ),
                      if (session.isStartManual || session.isEndManual) ...<
                          Widget>[
                        const Divider(height: AppSpacing.sm),
                        _row('Catatan', 'Diesit manual'),
                      ],
                      const Divider(height: AppSpacing.sm),
                      _row(
                        'Terakhir diubah',
                        _formatLocal(
                          session.updatedAtUtc,
                          session.startOffsetMinutes,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    SleepSession session,
  ) async {
    final bool confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: const Text('Hapus sesi ini?'),
        content: const Text(
          'Riwayat tidur yang dihapus tidak dapat dikembalikan.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    ) ??
        false;
    if (!confirmed || !context.mounted) {
      return;
    }
    context.read<HistoryBloc>().add(DeleteSessionRequested(session.id));
  }

  static Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 120,
            child: Text(label, style: AppTypography.caption),
          ),
          Expanded(
            child: Text(value, style: AppTypography.secondary),
          ),
        ],
      ),
    );
  }

  static String _formatLocal(DateTime utc, int offsetMinutes) {
    final DateTime shifted = DateTime.fromMillisecondsSinceEpoch(
      utc.millisecondsSinceEpoch + offsetMinutes * 60000,
      isUtc: true,
    );
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
    final String day = shifted.day.toString().padLeft(2, '0');
    final String hour = shifted.hour.toString().padLeft(2, '0');
    final String minute = shifted.minute.toString().padLeft(2, '0');
    return '$day ${months[shifted.month - 1]} ${shifted.year}, $hour:$minute';
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

  static String _accuracyLabel(SleepSession session, TimeAccuracy accuracy) {
    if (session.isStartManual || session.isEndManual) {
      return 'Diesit manual';
    }
    return switch (accuracy) {
      TimeAccuracy.manual => 'Diesit manual',
      TimeAccuracy.clockChanged => 'Jam berubah saat tidur',
      TimeAccuracy.bootChanged => 'Perangkat restart saat tidur',
      TimeAccuracy.invalid => 'Waktu tidak valid',
      TimeAccuracy.ok => 'Tersimpan',
    };
  }

  static String _timezoneLabel(String ianaId) {
    return switch (ianaId) {
      'Asia/Jakarta' => 'WIB (Asia/Jakarta)',
      'Asia/Makassar' => 'WITA (Asia/Makassar)',
      'Asia/Jayapura' => 'WIT (Asia/Jayapura)',
      'UTC' => 'UTC',
      _ => ianaId,
    };
  }
}
