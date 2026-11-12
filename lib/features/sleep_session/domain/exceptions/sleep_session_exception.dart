/// Domain errors raised by sleep session use cases.
///
/// Messages are user-facing Bahasa Indonesia and are shown directly in the
/// UI, so they stay actionable and free of technical jargon.
class SleepSessionException implements Exception {
  const SleepSessionException(this.code, this.message);

  /// Stable machine-readable code for logging and tests.
  final String code;

  /// User-facing message.
  final String message;

  static const SleepSessionException activeSessionExists =
      SleepSessionException(
    'active_session_exists',
    'Masih ada sesi tidur yang sedang berlangsung. '
        'Selesaikan sesi sebelumnya sebelum memulai sesi baru.',
  );

  static const SleepSessionException noActiveSession = SleepSessionException(
    'no_active_session',
    'Tidak ada sesi tidur yang sedang berlangsung.',
  );

  static const SleepSessionException sessionNotFound = SleepSessionException(
    'session_not_found',
    'Sesi tidur tidak ditemukan.',
  );

  static const SleepSessionException invalidSession = SleepSessionException(
    'invalid_session',
    'Waktu sesi tidur tidak valid. Periksa pengaturan jam perangkat.',
  );

  static const SleepSessionException platformUnavailable =
      SleepSessionException(
    'platform_unavailable',
    'Waktu perangkat tidak dapat dibaca. Coba lagi.',
  );

  static const SleepSessionException storageFailure = SleepSessionException(
    'storage_failure',
    'Data gagal disimpan. Coba lagi.',
  );

  static const SleepSessionException loadFailure = SleepSessionException(
    'load_failure',
    'Gagal memuat data. Coba lagi.',
  );

  @override
  String toString() => 'SleepSessionException($code): $message';
}
