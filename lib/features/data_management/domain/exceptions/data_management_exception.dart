/// Domain errors for export / import (PRD §4.9–§4.10).
///
/// Messages are user-facing Bahasa Indonesia shown directly in the UI.
class DataManagementException implements Exception {
  const DataManagementException(this.code, this.message);

  final String code;
  final String message;

  static const DataManagementException fileTooLarge = DataManagementException(
    'file_too_large',
    'File terlalu besar untuk diimpor. Maksimal 10 MB.',
  );

  static const DataManagementException invalidJson = DataManagementException(
    'invalid_json',
    'File bukan JSON yang valid.',
  );

  static const DataManagementException invalidStructure =
      DataManagementException(
    'invalid_structure',
    'Struktur file backup tidak valid. Gunakan file backup dari Frenooze.',
  );

  static const DataManagementException unsupportedVersion =
      DataManagementException(
    'unsupported_version',
    'Versi backup tidak didukung. Perbarui aplikasi atau gunakan file lain.',
  );

  static const DataManagementException noValidRecords =
      DataManagementException(
    'no_valid_records',
    'Tidak ada record tidur yang valid di dalam file.',
  );

  static const DataManagementException activeSessionConflict =
      DataManagementException(
    'active_session_conflict',
    'Impor akan membuat lebih dari satu sesi aktif. '
        'Selesaikan atau hapus sesi aktif terlebih dahulu.',
  );

  static const DataManagementException storageFailure =
      DataManagementException(
    'storage_failure',
    'Data gagal disimpan. Tidak ada perubahan yang diterapkan.',
  );

  static const DataManagementException exportEmptyFailure =
      DataManagementException(
    'export_failure',
    'Gagal membuat file export. Coba lagi.',
  );

  @override
  String toString() => 'DataManagementException($code): $message';
}
