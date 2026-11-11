/// Abstraction over the device clock so time can be controlled in tests.
abstract interface class ClockProvider {
  DateTime nowUtc();
}

/// Production clock backed by the system wall clock.
class SystemClockProvider implements ClockProvider {
  const SystemClockProvider();

  @override
  DateTime nowUtc() => DateTime.now().toUtc();
}