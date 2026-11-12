/// Domain errors raised by Wake-up Mode use cases.
///
/// Messages are user-facing Bahasa Indonesia, shown directly in the UI.
class WakeUpException implements Exception {
  const WakeUpException(this.code, this.message);

  final String code;
  final String message;

  static const WakeUpException storageFailure = WakeUpException(
    'storage_failure',
    'Status Wake-up Mode gagal disimpan. Coba lagi.',
  );

  static const WakeUpException loadFailure = WakeUpException(
    'load_failure',
    'Gagal memuat status Wake-up Mode. Coba lagi.',
  );

  static const WakeUpException hardwareFailure = WakeUpException(
    'hardware_failure',
    'Getaran atau layar tidak dapat diaktifkan. Coba lagi.',
  );

  @override
  String toString() => 'WakeUpException($code): $message';
}
