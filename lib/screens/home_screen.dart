import 'package:flutter/material.dart';
import '../widgets/water_button.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _totalMl = 0;
  final int _step = 250; // объём за одно нажатие

  void _addWater() {
    setState(() {
      _totalMl += _step;
    });
  }

  void _resetWater() {
    setState(() {
      _totalMl = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Отображаем литры с двумя знаками после точки
    final liters = (_totalMl / 1000).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Выпито: $liters л', style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WaterButton(label: '+250 мл', onPressed: _addWater),
                WaterButton(label: 'Сброс', onPressed: _resetWater),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (i) {
          if (i == 1) Navigator.pushNamed(context, HistoryScreen.routeName);
          if (i == 2) Navigator.pushNamed(context, ProfileScreen.routeName);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.local_drink), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}