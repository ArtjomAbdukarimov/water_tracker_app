import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final int _step = 250;
  final TextEditingController _customController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTodayTotal();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  Future<void> _loadTodayTotal() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T').first;
    setState(() {
      _totalMl = prefs.getInt('water_$today') ?? 0;
    });
  }

  Future<void> _saveTotal() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T').first;
    await prefs.setInt('water_$today', _totalMl);
  }

  Future<void> _addWater() async {
    setState(() => _totalMl += _step);
    await _saveTotal();
  }

  Future<void> _resetWater() async {
    setState(() => _totalMl = 0);
    await _saveTotal();
  }

  Future<void> _addCustom() async {
    final value = int.tryParse(_customController.text);
    if (value != null && value > 0) {
      setState(() => _totalMl += value);
      _customController.clear();
      await _saveTotal();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите число мл больше нуля')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final liters = (_totalMl / 1000).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Выпито: $liters л', style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WaterButton(label: '+$_step мл', onPressed: _addWater),
                WaterButton(label: 'Сброс', onPressed: _resetWater),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Введите мл (например, 150)',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(onPressed: _addCustom, child: const Text('Добавить')),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (i) {
          switch (i) {
            case 0:
              break; // остаёмся
            case 1:
              Navigator.pushReplacementNamed(context, HistoryScreen.routeName);
              break;
            case 2:
              Navigator.pushReplacementNamed(context, ProfileScreen.routeName);
              break;
          }
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