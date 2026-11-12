import 'package:flutter_test/flutter_test.dart';
import 'package:frenooze/features/sleep_session/domain/entities/time_accuracy.dart';

void main() {
  test('fromDb maps known values', () {
    expect(TimeAccuracy.fromDb('ok'), TimeAccuracy.ok);
    expect(TimeAccuracy.fromDb('clockChanged'), TimeAccuracy.clockChanged);
    expect(TimeAccuracy.fromDb('bootChanged'), TimeAccuracy.bootChanged);
    expect(TimeAccuracy.fromDb('invalid'), TimeAccuracy.invalid);
    expect(TimeAccuracy.fromDb('manual'), TimeAccuracy.manual);
  });

  test('fromDb falls back to ok for unknown', () {
    expect(TimeAccuracy.fromDb('something_new'), TimeAccuracy.ok);
    expect(TimeAccuracy.fromDb(''), TimeAccuracy.ok);
  });
}
