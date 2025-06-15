import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class HistoryScreen extends StatefulWidget {
  static const routeName = '/history';
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<MapEntry<String, int>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final entries = prefs
        .getKeys()
        .where((k) => k.startsWith('water_'))
        .map((k) {
      final date = k.substring('water_'.length);
      final ml = prefs.getInt(k) ?? 0;
      return MapEntry(date, ml);
    })
        .toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    setState(() {
      _history = entries;
    });

    // Для отладки можно распечатать в консоль:
    // debugPrint('History entries: $_history');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: _history.isEmpty
          ? const Center(child: Text('Нет данных за прошлые дни'))
          : ListView.builder(
        itemCount: _history.length,
        itemBuilder: (ctx, i) {
          final date = _history[i].key;
          final liters = (_history[i].value / 1000).toStringAsFixed(2);
          return ListTile(
            title: Text(date),
            trailing: Text('$liters л'),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (i) {
          switch (i) {
            case 0:
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
              break;
            case 1:
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