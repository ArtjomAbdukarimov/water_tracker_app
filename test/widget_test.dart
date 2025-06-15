import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:water_tracker_app/main.dart';

void main() {
  testWidgets('Smoke test for WaterTrackerApp', (WidgetTester tester) async {
    // Строим приложение и запускаем первый кадр
    await tester.pumpWidget(const WaterTrackerApp());

    // Проверяем, что наше приложение отображается
    expect(find.byType(WaterTrackerApp), findsOneWidget);

    // Проверяем, что в AppBar есть надпись "Home"
    expect(find.text('Home'), findsOneWidget);

    // Нажмём вкладку "History" в BottomNavigationBar и проверим, что переключение произошло
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();
    expect(find.text('History'), findsOneWidget);

    // Нажмём вкладку "Profile" и проверим
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    expect(find.text('Profile'), findsOneWidget);
  });
}