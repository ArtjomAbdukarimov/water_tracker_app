import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class HistoryScreen extends StatelessWidget {
  static const routeName = '/history';

  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: const Center(child: Text('Здесь будет история по дням')),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (i) {
          if (i == 0) Navigator.pushNamed(context, HomeScreen.routeName);
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