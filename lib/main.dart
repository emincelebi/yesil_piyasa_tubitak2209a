import 'package:flutter/material.dart';
import 'screens/giris_ekrani.dart';

void main() {
  runApp(YesilPiyasaApp());
}

class YesilPiyasaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green, // Uygulamanın genel renk teması
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87, fontSize: 18),
          labelLarge: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
      home: GirisEkrani(), // Giriş ekranı burada çağrılıyor
    );
  }
}
