import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:water_tracker_app_new/main.dart';

void main() {
  testWidgets('Smoke test for WaterTrackerApp Home↔History', (WidgetTester tester) async {
    // Собираем приложение
    await tester.pumpWidget(const WaterTrackerApp());

    // Проверяем, что AppBar показывает "Home"
    expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);

    // Переходим на History
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();

    // Проверяем, что AppBar показывает "History"
    expect(find.widgetWithText(AppBar, 'History'), findsOneWidget);

    // Возвращаемся обратно на Home
    await tester.tap(find.byIcon(Icons.local_drink));
    await tester.pumpAndSettle();

    // Проверяем, что AppBar снова "Home"
    expect(find.widgetWithText(AppBar, 'Home'), findsOneWidget);
  });
}