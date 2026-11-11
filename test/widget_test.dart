import 'package:flutter_test/flutter_test.dart';

import 'package:frenooze/app.dart';
import 'package:frenooze/core/theme/theme_mode_controller.dart';

void main() {
  testWidgets('Dashboard renders sleep action card', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      FrenoozeApp(themeModeController: ThemeModeController()),
    );

    expect(find.text('Saya mau tidur'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
  });
}