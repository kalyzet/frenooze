import 'package:equatable/equatable.dart';

import 'time_accuracy.dart';

/// Immutable sleep session record.
///
/// Absolute time is stored as UTC; local wall-clock time is derived from the
/// recorded IANA timezone and UTC offset (ARCHITECTURE §8). Duration is never
/// stored as an editable value — it is always derived from the timestamps.
class SleepSession extends Equatable {
  const SleepSession({
    required this.id,
    required this.startedAtUtc,
    this.endedAtUtc,
    required this.startTimezone,
    this.endTimezone,
    required this.startOffsetMinutes,
    this.endOffsetMinutes,
    required this.startElapsedMs,
    this.endElapsedMs,
    required this.startBootCount,
    this.endBootCount,
    this.isStartManual = false,
    this.isEndManual = false,
    this.accuracy = TimeAccuracy.ok,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });

  /// Stable identifier (primary key).
  final String id;

  /// Absolute start time in UTC.
  final DateTime startedAtUtc;

  /// Absolute end time in UTC; `null` while the session is active.
  final DateTime? endedAtUtc;

  /// IANA timezone identifier when the session started.
  final String startTimezone;

  /// IANA timezone identifier when the session ended.
  final String? endTimezone;

  /// UTC offset in minutes when the session started.
  final int startOffsetMinutes;

  /// UTC offset in minutes when the session ended.
  final int? endOffsetMinutes;

  /// Monotonic `elapsedRealtime()` at start.
  final int startElapsedMs;

  /// Monotonic `elapsedRealtime()` at end.
  final int? endElapsedMs;

  /// Boot counter at start; used to detect a reboot mid-session.
  final int startBootCount;

  /// Boot counter at end.
  final int? endBootCount;

  /// `true` when the start timestamp was edited manually.
  final bool isStartManual;

  /// `true` when the end timestamp was edited manually.
  final bool isEndManual;

  /// Reliability marker for the derived duration.
  final TimeAccuracy accuracy;

  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;

  /// A session without an end timestamp is still running (PRD §4.2.2).
  bool get isActive => endedAtUtc == null;

  @override
  List<Object?> get props => <Object?>[
        id,
        startedAtUtc,
        endedAtUtc,
        startTimezone,
        endTimezone,
        startOffsetMinutes,
        endOffsetMinutes,
        startElapsedMs,
        endElapsedMs,
        startBootCount,
        endBootCount,
        isStartManual,
        isEndManual,
        accuracy,
        createdAtUtc,
        updatedAtUtc,
      ];
}
