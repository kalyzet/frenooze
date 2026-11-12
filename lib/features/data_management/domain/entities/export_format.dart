/// Supported export formats for sleep data (PRD §4.9).
enum ExportFormat {
  /// Full JSON backup suitable for restore.
  json('json', 'Backup JSON'),

  /// Spreadsheet-oriented CSV; export only (PRD §4.10).
  csv('csv', 'CSV analisis');

  const ExportFormat(this.fileExtension, this.label);

  /// Extension used in the suggested file name.
  final String fileExtension;

  /// Human-readable label for UI.
  final String label;
}
