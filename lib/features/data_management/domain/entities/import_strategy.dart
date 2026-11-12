/// How imported records are written into the local database (PRD §4.10).
enum ImportStrategy {
  /// Add imported records without replacing existing ones; duplicates by id
  /// are skipped.
  merge('Gabung', 'Tambah data impor tanpa mengganti data yang ada.'),

  /// Replace all existing sleep data with the imported data after explicit
  /// confirmation.
  replace(
    'Ganti',
    'Hapus semua data tidur yang ada, lalu simpan data dari file impor.',
  );

  const ImportStrategy(this.label, this.description);

  /// Short label for segmented buttons / radio tiles.
  final String label;

  /// One-line explanation shown in the confirmation dialog.
  final String description;
}
