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
  final int _step = 250;
  final TextEditingController _customController = TextEditingController();

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

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

  void _addCustom() {
    final value = int.tryParse(_customController.text);
    if (value != null && value > 0) {
      setState(() {
        _totalMl += value;
      });
      _customController.clear();
    } else {
      // Показать ошибку, если ввод некорректен
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Выпито: $liters л', style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 32),

            // Кнопки +250 и Сброс
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                WaterButton(label: '+$_step мл', onPressed: _addWater),
                WaterButton(label: 'Сброс', onPressed: _resetWater),
              ],
            ),

            const SizedBox(height: 24),

            // Поле для ввода своего объёма и кнопка «Добавить»
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
                ElevatedButton(
                  onPressed: _addCustom,
                  child: const Text('Добавить'),
                ),
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