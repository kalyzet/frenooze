/// Selectable statistics window (DESIGN §8.3).
enum StatisticsRange {
  days7(7, '7 hari'),
  days30(30, '30 hari'),
  days90(90, '90 hari'),
  all(null, 'Semua');

  const StatisticsRange(this.days, this.label);

  /// Inclusive day count from "now" back; `null` means no lower bound.
  final int? days;

  /// Short label for the range selector.
  final String label;
}
