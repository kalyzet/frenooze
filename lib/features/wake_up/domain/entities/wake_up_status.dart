import 'package:equatable/equatable.dart';

/// Persisted Wake-up Mode status (ARCHITECTURE §13.3).
///
/// A single row tracks whether the mode is currently active and which sleep
/// session it belongs to. Closing the mode never touches the sleep session
/// itself (PRD §4.4.4).
class WakeUpStatus extends Equatable {
  const WakeUpStatus({
    required this.isActive,
    this.activatedAtUtc,
    this.relatedSessionId,
    required this.updatedAtUtc,
  });

  /// Inactive placeholder used before anything is stored.
  ///
  /// Not `const` because [DateTime.utc] is not a const constructor.
  factory WakeUpStatus.inactive() => WakeUpStatus(
        isActive: false,
        updatedAtUtc: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      );

  final bool isActive;
  final DateTime? activatedAtUtc;
  final String? relatedSessionId;
  final DateTime updatedAtUtc;

  @override
  List<Object?> get props => <Object?>[
        isActive,
        activatedAtUtc,
        relatedSessionId,
        updatedAtUtc,
      ];
}
