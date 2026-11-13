import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../domain/entities/sleep_statistics.dart';
import '../../domain/entities/statistics_range.dart';
import '../bloc/statistics_bloc.dart';

/// Statistics dashboard (PRD §4.8, DESIGN §8).
///
/// Shows only valid completed sessions; empty metrics mean "no data",
/// never zero-duration sleep. No medical claims — duration patterns only.
class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  StatisticsRange _range = StatisticsRange.days7;

  @override
  void initState() {
    super.initState();
    context
        .read<StatisticsBloc>()
        .add(LoadStatisticsRequested(range: _range));
  }

  void _changeRange(StatisticsRange range) {
    if (range == _range) {
      return;
    }
    setState(() => _range = range);
    context.read<StatisticsBloc>().add(ChangeRangeRequested(range));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const LogoTitle('Statistik')),
      body: BlocConsumer<StatisticsBloc, StatisticsState>(
        listener: (BuildContext context, StatisticsState state) {
          if (state is StatisticsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (BuildContext context, StatisticsState state) {
          return Column(
            children: <Widget>[
              _rangeSelector(),
              Expanded(child: _body(state)),
            ],
          );
        },
      ),
    );
  }

  Widget _rangeSelector() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: SegmentedButton<StatisticsRange>(
        // No selected icon: the checkmark's icon+padding made the selected
        // label exceed the per-segment width cap (lebar/4), forcing wraps
        // like "Sem/ua". The selected fill is the indicator instead.
        showSelectedIcon: false,
        segments: <ButtonSegment<StatisticsRange>>[
          for (final StatisticsRange range in StatisticsRange.values)
            ButtonSegment<StatisticsRange>(
              value: range,
              label: Text(range.label),
            ),
        ],
        selected: <StatisticsRange>{_range},
        onSelectionChanged: (Set<StatisticsRange> selection) {
          if (selection.isNotEmpty) {
            _changeRange(selection.first);
          }
        },
      ),
    );
  }

  Widget _body(StatisticsState state) {
    if (state is StatisticsLoading || state is StatisticsInitial) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is StatisticsFailure) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: AppSpacing.md),
              Text(state.message, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.md),
              FilledButton(
                onPressed: () => context.read<StatisticsBloc>().add(
                      LoadStatisticsRequested(range: _range),
                    ),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }
    if (state is StatisticsLoaded) {
      final SleepStatistics stats = state.statistics;
      if (stats.isEmpty) {
        return _emptyView();
      }
      return RefreshIndicator(
        onRefresh: () async {
          context
              .read<StatisticsBloc>()
              .add(const RefreshStatisticsRequested());
          await context.read<StatisticsBloc>().stream.firstWhere(
                (StatisticsState s) => s is StatisticsLoaded ||
                    s is StatisticsFailure,
              );
        },
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: <Widget>[
            _metricGrid(stats),
            const SizedBox(height: AppSpacing.md),
            _chartCard(stats),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Statistik ringkasan berdasarkan sesi selesai yang valid. '
              'Bukan diagnosis medis.',
              style: AppTypography.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _emptyView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.insights, size: 48),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Belum ada data untuk periode ini.',
              style: AppTypography.heading3,
            ),
            const SizedBox(height: AppSpacing.xs),
            const Text(
              'Statistik muncul setelah ada sesi tidur selesai '
              'yang valid.',
              style: AppTypography.secondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Periode: ${_range.label}',
              style: AppTypography.caption,
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricGrid(SleepStatistics stats) {
    final List<_Metric> metrics = <_Metric>[
      _Metric(
        label: 'Rata-rata durasi',
        value: stats.averageDuration == null
            ? '—'
            : _formatDuration(stats.averageDuration!),
        icon: Icons.schedule,
      ),
      _Metric(
        label: 'Total tidur',
        value: stats.totalDuration == null
            ? '—'
            : _formatDuration(stats.totalDuration!),
        icon: Icons.nightlight,
      ),
      _Metric(
        label: 'Rata-rata tidur',
        value: stats.averageSleepTimeLabel ?? '—',
        icon: Icons.bedtime,
      ),
      _Metric(
        label: 'Rata-rata bangun',
        value: stats.averageWakeTimeLabel ?? '—',
        icon: Icons.wb_sunny,
      ),
      _Metric(
        label: 'Terlama',
        value: stats.longestDuration == null
            ? '—'
            : _formatDuration(stats.longestDuration!),
        icon: Icons.trending_up,
      ),
      _Metric(
        label: 'Terpendek',
        value: stats.shortestDuration == null
            ? '—'
            : _formatDuration(stats.shortestDuration!),
        icon: Icons.trending_down,
      ),
      _Metric(
        label: 'Jumlah sesi',
        value: '${stats.sessionCount}',
        icon: Icons.list_alt,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 1.55,
      children: <Widget>[
        for (final _Metric metric in metrics) _metricCard(metric),
      ],
    );
  }

  Widget _metricCard(_Metric metric) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(metric.icon, size: 16),
                const SizedBox(width: AppSpacing.xxs),
                Expanded(
                  child: Text(
                    metric.label,
                    style: AppTypography.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(metric.value, style: AppTypography.heading3),
          ],
        ),
      ),
    );
  }

  Widget _chartCard(SleepStatistics stats) {
    final List<DailySleepPoint> trend = stats.dailyTrend;
    if (trend.isEmpty) {
      return const SizedBox.shrink();
    }
    // Cap bars so 90-day range stays readable (DESIGN §8.4).
    final List<DailySleepPoint> visible = trend.length > 30
        ? trend.sublist(trend.length - 30)
        : trend;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Tren durasi harian${trend.length > visible.length ? ' (30 hari terakhir)' : ''}',
              style: AppTypography.heading3,
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _maxHours(visible),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (BarChartGroupData group, int groupIndex,
                          BarChartRodData rod, int rodIndex) {
                        final DailySleepPoint point = visible[group.x];
                        return BarTooltipItem(
                          '${_formatDuration(point.duration)}\n'
                          '${_shortDate(point.localDate)}',
                          AppTypography.caption.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              '${value.toStringAsFixed(0)}j',
                              style: AppTypography.caption,
                              textAlign: TextAlign.right,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: _bottomInterval(visible.length),
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final int index = value.round();
                          if (index < 0 || index >= visible.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${visible[index].localDate.day}',
                              style: AppTypography.caption,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: <BarChartGroupData>[
                    for (int i = 0; i < visible.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: <BarChartRodData>[
                          BarChartRodData(
                            toY: visible[i].duration.inMinutes / 60.0,
                            width: visible.length > 14 ? 6 : 14,
                            borderRadius: BorderRadius.circular(4),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static double _maxHours(List<DailySleepPoint> points) {
    double max = 8;
    for (final DailySleepPoint point in points) {
      final double hours = point.duration.inMinutes / 60.0;
      if (hours > max) {
        max = hours;
      }
    }
    return max * 1.15;
  }

  static double? _bottomInterval(int length) {
    if (length <= 7) {
      return 1;
    }
    if (length <= 14) {
      return 2;
    }
    if (length <= 30) {
      return 5;
    }
    return 10;
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

  static String _shortDate(DateTime local) {
    return '${local.day}/${local.month}';
  }
}

class _Metric {
  const _Metric({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;
}
