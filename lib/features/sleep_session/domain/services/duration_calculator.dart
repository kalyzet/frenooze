import '../entities/sleep_session.dart';
import '../entities/time_accuracy.dart';

/// Derived duration of a finished session together with its reliability.
class SleepDuration {
  const SleepDuration({required this.duration, required this.accuracy});

  final Duration duration;
  final TimeAccuracy accuracy;
}

/// Computes sleep duration from stored timestamps (PRD §4.2.3).
///
/// Never uses a continuously running timer. Prefers the monotonic Android
/// clock when the boot identity is unchanged and falls back to absolute UTC
/// timestamps otherwise (ARCHITECTURE §8.5).
class DurationCalculator {
  const DurationCalculator({
    this.clockTolerance = const Duration(minutes: 1),
  });

  /// How far wall-clock and monotonic durations may differ before the result
  /// is flagged as potentially affected by a manual clock change.
  final Duration clockTolerance;

  /// Computes the duration of a finished session.
  ///
  /// Returns [TimeAccuracy.invalid] when the session is still running or the
  /// recorded timestamps contradict each other.
  SleepDuration calculate(SleepSession session) {
    final DateTime? endedAtUtc = session.endedAtUtc;
    if (endedAtUtc == null) {
      return const SleepDuration(
        duration: Duration.zero,
        accuracy: TimeAccuracy.invalid,
      );
    }

    final Duration wall = endedAtUtc.difference(session.startedAtUtc);
    final int startElapsed = session.startElapsedMs;
    final int? endElapsed = session.endElapsedMs;
    final int? endBoot = session.endBootCount;
    final bool sameBoot = endBoot != null && endBoot == session.startBootCount;

    if (sameBoot && endElapsed != null) {
      final int monotonicMs = endElapsed - startElapsed;
      if (monotonicMs < 0) {
        return const SleepDuration(
          duration: Duration.zero,
          accuracy: TimeAccuracy.invalid,
        );
      }
      final Duration monotonic = Duration(milliseconds: monotonicMs);
      if (wall.isNegative || (monotonic - wall).abs() > clockTolerance) {
        // The monotonic clock still measures a truthful interval even when
        // the wall clock was shifted; keep the duration and warn.
        return SleepDuration(
          duration: monotonic,
          accuracy: TimeAccuracy.clockChanged,
        );
      }
      return SleepDuration(duration: monotonic, accuracy: TimeAccuracy.ok);
    }

    if (wall.isNegative) {
      return const SleepDuration(
        duration: Duration.zero,
        accuracy: TimeAccuracy.invalid,
      );
    }

    if (endBoot != null && !sameBoot) {
      // Rebooted mid-session: only the wall clock spans the boundary.
      return SleepDuration(duration: wall, accuracy: TimeAccuracy.bootChanged);
    }

    return SleepDuration(duration: wall, accuracy: TimeAccuracy.ok);
  }

  /// Elapsed time of a still-running session at [nowUtc].
  ///
  /// Used by the dashboard while a session is active; it never starts a
  /// background timer by itself (PRD §4.2.3).
  Duration running(SleepSession session, DateTime nowUtc) {
    final Duration elapsed = nowUtc.difference(session.startedAtUtc);
    return elapsed.isNegative ? Duration.zero : elapsed;
  }
}
