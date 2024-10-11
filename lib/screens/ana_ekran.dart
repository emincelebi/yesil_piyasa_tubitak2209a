import 'package:flutter/material.dart';

class AnaEkran extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ana Ekran"),
      ),
      body: Center(
        child: Text(
          "Hoş Geldiniz!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
