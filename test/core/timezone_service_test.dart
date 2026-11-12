import 'package:flutter_test/flutter_test.dart';
import 'package:frenooze/core/time/timezone_service.dart';

void main() {
  test('SystemTimezoneService returns offset and id', () {
    const SystemTimezoneService service = SystemTimezoneService();
    final TimezoneInfo info = service.current();

    expect(info.offsetMinutes, greaterThanOrEqualTo(-14 * 60));
    expect(info.offsetMinutes, lessThanOrEqualTo(14 * 60));
    expect(info.ianaId, isNotEmpty);
    if (info.ianaId != 'UTC') {
      expect(info.ianaId, contains('/'));
    }
  });
}
