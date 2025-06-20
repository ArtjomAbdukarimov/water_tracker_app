import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';           // ← импорт для инициализации Firebase
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();                // ← обязательно вызвать до инициализации
  await Firebase.initializeApp(); // ← инициализируем Firebase

  // Диагностический вывод — ставим здесь, сразу после инициализации
  print('✅ Firebase initialized: ${Firebase.apps.map((a) => a.name).toList()}');

  runApp(const WaterTrackerApp());
}

class WaterTrackerApp extends StatelessWidget {
  const WaterTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
        HistoryScreen.routeName: (_) => const HistoryScreen(),
        ProfileScreen.routeName: (_) => const ProfileScreen(),
      },
    );
  }
}
