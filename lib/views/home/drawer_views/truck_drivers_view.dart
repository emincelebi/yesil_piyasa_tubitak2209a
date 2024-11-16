import 'package:flutter/material.dart';

class TruckDriversView extends StatelessWidget {
  const TruckDriversView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tırcılar'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[100]!, Colors.blue[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_shipping,
                size: 100,
                color: Colors.green[800],
              ),
              const SizedBox(height: 20),
              Text(
                'Yakında Geliyor!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Çiftçiler için özel taşıma çözümleri sunacağız.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.green[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
