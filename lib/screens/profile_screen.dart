import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'history_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  Future<void> _signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // пользователь отменил
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final userCred = await _auth.signInWithCredential(credential);
      setState(() => _user = userCred.user);
      await _syncHistoryToCloud();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка входа: $e')),
      );
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    setState(() => _user = null);
  }

  Future<void> _syncHistoryToCloud() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = _user!.uid;
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    for (var key in prefs.getKeys().where((k) => k.startsWith('water_'))) {
      final date = key.substring('water_'.length);
      final ml = prefs.getInt(key) ?? 0;
      final docRef = firestore
          .collection('users')
          .doc(userId)
          .collection('history')
          .doc(date);
      batch.set(docRef, {'ml': ml});
    }
    await batch.commit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: _user == null
            ? ElevatedButton.icon(
          icon: const Icon(Icons.login),
          label: const Text('Sign in with Google'),
          onPressed: _signInWithGoogle,
        )
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_user!.photoURL != null)
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(_user!.photoURL!),
              ),
            const SizedBox(height: 12),
            Text(_user!.displayName ?? '',
                style: const TextStyle(fontSize: 18)),
            Text(_user!.email ?? '',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _signOut,
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (i) {
          if (i == 0) {
            Navigator.pushReplacementNamed(
                context, HomeScreen.routeName);
          } else if (i == 1) {
            Navigator.pushReplacementNamed(
                context, HistoryScreen.routeName);
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.local_drink), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}