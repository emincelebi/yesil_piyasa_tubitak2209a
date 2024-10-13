import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class HomeView extends StatelessWidget {
  HomeView({super.key, required this.user, required this.onSignOut});

  User? user;
  final VoidCallback onSignOut;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    onSignOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          IconButton(
              onPressed: () async {
                await _signOut();
              },
              icon: const Icon(Icons.logout))
        ],
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Yeşil Piyasaya Hoşgeldiniz'),
      ),
    );
  }
}
