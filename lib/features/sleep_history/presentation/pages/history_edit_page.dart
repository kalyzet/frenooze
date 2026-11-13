import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/theme/app_theme.dart';
import '../../../../core/time/timestamp_converter.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../sleep_session/domain/entities/sleep_session.dart';
import '../bloc/history_bloc.dart';

/// Manual edit form for one sleep session (PRD §4.6, DESIGN §7.2).
///
/// Editable: start date/time, wake date/time, timezone (WIB/WITA/WIT).
/// Validation runs before the save event; `UpdateSleepSession` re-checks
/// end > start and stamps the manual flags + `updatedAtUtc`.
/// Active sessions only expose start fields so an open session is never
/// treated as completed from this form (PRD §4.6).
class HistoryEditPage extends StatefulWidget {
  const HistoryEditPage({super.key});

  @override
  State<HistoryEditPage> createState() => _HistoryEditPageState();
}

class _HistoryEditPageState extends State<HistoryEditPage> {
  late SleepSession _session;
  late DateTime _startDate;
  late DateTime _startTime;
  late DateTime? _endDate;
  late DateTime? _endTime;
  late String _timezoneId;
  String? _formError;
  bool _initialised = false;

  static const Map<String, String> _timezones = <String, String>{
    'WIB': 'Asia/Jakarta',
    'WITA': 'Asia/Makassar',
    'WIT': 'Asia/Jayapura',
  };

  @override
  void initState() {
    super.initState();
    _hydrateFromBloc();
  }

  void _hydrateFromBloc() {
    final HistoryState state = context.read<HistoryBloc>().state;
    if (state is! HistoryLoaded || state.detail == null) {
      return;
    }
    _session = state.detail!;
    final DateTime startLocal = _toLocal(
      _session.startedAtUtc,
      _session.startOffsetMinutes,
    );
    _startDate = startLocal;
    _startTime = startLocal;
    if (_session.endedAtUtc != null) {
      final DateTime endLocal = _toLocal(
        _session.endedAtUtc!,
        _session.endOffsetMinutes ?? _session.startOffsetMinutes,
      );
      _endDate = endLocal;
      _endTime = endLocal;
    } else {
      _endDate = null;
      _endTime = null;
    }
    _timezoneId = _session.startTimezone;
    _initialised = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialised) {
      // Detail was not ready yet — wait for the bloc before showing fields.
      return BlocBuilder<HistoryBloc, HistoryState>(
        builder: (BuildContext context, HistoryState state) {
          if (state is HistoryLoaded && state.detail != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_initialised) {
                setState(_hydrateFromBloc);
              }
            });
          }
          return Scaffold(
            appBar: AppBar(title: const LogoTitle('Edit Sesi')),
            body: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    }

    final bool showEnd = _session.endedAtUtc != null;

    return BlocListener<HistoryBloc, HistoryState>(
      listener: (BuildContext context, HistoryState state) {
        if (state is HistoryFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          return;
        }
        if (state is HistoryLoaded) {
          final SleepSession? detail = state.detail;
          // Successful save: updatedAtUtc changed on the same row.
          if (detail != null &&
              detail.id == _session.id &&
              detail.updatedAtUtc != _session.updatedAtUtc) {
            Navigator.of(context).pop();
          }
        }
      },
      child: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (BuildContext context, HistoryState state) {
          final bool busy = state is HistoryLoaded && state.busy;
          return Scaffold(
            appBar: AppBar(title: const LogoTitle('Edit Sesi')),
            body: Form(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: <Widget>[
                  if (_formError != null) ...<Widget>[
                    Text(
                      _formError!,
                      style: AppTypography.secondary.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  const Text('Waktu mulai', style: AppTypography.heading3),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _dateButton(
                          label: _formatDate(_startDate),
                          onPressed:
                              busy ? null : () => _pickDate(isStart: true),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: _dateButton(
                          label: _formatTime(_startTime),
                          onPressed:
                              busy ? null : () => _pickTime(isStart: true),
                        ),
                      ),
                    ],
                  ),
                  if (showEnd) ...<Widget>[
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      'Waktu bangun',
                      style: AppTypography.heading3,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _dateButton(
                            label: _endDate == null
                                ? 'Pilih tanggal'
                                : _formatDate(_endDate!),
                            onPressed:
                                busy ? null : () => _pickDate(isStart: false),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: _dateButton(
                            label: _endTime == null
                                ? 'Pilih jam'
                                : _formatTime(_endTime!),
                            onPressed:
                                busy ? null : () => _pickTime(isStart: false),
                          ),
                        ),
                      ],
                    ),
                  ] else ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      'Sesi masih berlangsung. Waktu bangun diatur '
                      'lewat tombol "Saya sudah bangun" di dashboard.',
                      style: AppTypography.caption,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  const Text('Zona waktu', style: AppTypography.heading3),
                  const SizedBox(height: AppSpacing.xs),
                  DropdownButtonFormField<String>(
                    initialValue: _timezones.values.contains(_timezoneId)
                        ? _timezoneId
                        : 'Asia/Jakarta',
                    items: _timezones.entries
                        .map(
                          (MapEntry<String, String> e) =>
                              DropdownMenuItem<String>(
                            value: e.value,
                            child: Text('${e.key} (${e.value})'),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: busy
                        ? null
                        : (String? value) {
                            if (value != null) {
                              setState(() => _timezoneId = value);
                            }
                          },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FilledButton(
                    onPressed: busy ? null : _save,
                    child: busy
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Simpan perubahan'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _dateButton({
    required String label,
    required VoidCallback? onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final DateTime initial = isStart ? _startDate : _endDate ?? _startDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _pickTime({required bool isStart}) async {
    final DateTime initial = isStart ? _startTime : _endTime ?? _startTime;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initial.hour, minute: initial.minute),
    );
    if (picked == null || !mounted) {
      return;
    }
    setState(() {
      if (isStart) {
        _startTime = DateTime(
          _startTime.year,
          _startTime.month,
          _startTime.day,
          picked.hour,
          picked.minute,
        );
      } else {
        _endTime = DateTime(
          (_endTime ?? _startTime).year,
          (_endTime ?? _startTime).month,
          (_endTime ?? _startTime).day,
          picked.hour,
          picked.minute,
        );
      }
    });
  }

  void _save() {
    setState(() => _formError = null);

    final DateTime startLocal = DateTime(
      _startDate.year,
      _startDate.month,
      _startDate.day,
      _startTime.hour,
      _startTime.minute,
    );
    final int startOffset = _offsetMinutes(_timezoneId, startLocal);
    final int startUtcMs = TimestampConverter.fromLocal(
      startLocal,
      _timezoneId,
    );

    DateTime? endLocal;
    int? endUtcMs;
    int? endOffset;
    if (_session.endedAtUtc != null) {
      if (_endDate == null || _endTime == null) {
        setState(
          () =>
              _formError = 'Sesi selesai harus punya tanggal dan jam bangun.',
        );
        return;
      }
      endLocal = DateTime(
        _endDate!.year,
        _endDate!.month,
        _endDate!.day,
        _endTime!.hour,
        _endTime!.minute,
      );
      if (!endLocal.isAfter(startLocal)) {
        setState(
          () => _formError = 'Waktu bangun harus setelah waktu mulai.',
        );
        return;
      }
      endOffset = _offsetMinutes(_timezoneId, endLocal);
      endUtcMs = TimestampConverter.fromLocal(endLocal, _timezoneId);
    }

    final SleepSession edited = SleepSession(
      id: _session.id,
      startedAtUtc: DateTime.fromMillisecondsSinceEpoch(
        startUtcMs,
        isUtc: true,
      ),
      endedAtUtc: endUtcMs == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(endUtcMs, isUtc: true),
      startTimezone: _timezoneId,
      endTimezone: endUtcMs == null ? null : _timezoneId,
      startOffsetMinutes: startOffset,
      endOffsetMinutes: endOffset,
      startElapsedMs: _session.startElapsedMs,
      endElapsedMs: _session.endElapsedMs,
      startBootCount: _session.startBootCount,
      endBootCount: _session.endBootCount,
      isStartManual: _session.isStartManual,
      isEndManual: _session.isEndManual,
      accuracy: _session.accuracy,
      createdAtUtc: _session.createdAtUtc,
      updatedAtUtc: _session.updatedAtUtc,
    );

    if (edited.endedAtUtc != null &&
        !edited.endedAtUtc!.isAfter(edited.startedAtUtc)) {
      setState(
        () => _formError = 'Waktu bangun harus setelah waktu mulai.',
      );
      return;
    }

    context.read<HistoryBloc>().add(SaveEditRequested(edited));
  }

  static int _offsetMinutes(String ianaId, DateTime local) {
    try {
      final tz.Location location = tz.getLocation(ianaId);
      return tz.TZDateTime(
        location,
        local.year,
        local.month,
        local.day,
        local.hour,
        local.minute,
      ).timeZoneOffset.inMinutes;
    } on Exception {
      return local.timeZoneOffset.inMinutes;
    }
  }

  static DateTime _toLocal(DateTime utc, int offsetMinutes) {
    return DateTime.fromMillisecondsSinceEpoch(
      utc.millisecondsSinceEpoch + offsetMinutes * 60000,
      isUtc: true,
    );
  }

  static String _formatDate(DateTime local) {
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
    return '${local.day} ${months[local.month - 1]} ${local.year}';
  }

  static String _formatTime(DateTime local) {
    final String hour = local.hour.toString().padLeft(2, '0');
    final String minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
