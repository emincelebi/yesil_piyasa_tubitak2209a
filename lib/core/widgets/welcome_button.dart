import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WelcomeButton extends StatelessWidget {
  final String text; // Butonun üzerinde yazacak metin
  final VoidCallback onPressed; // Butona basıldığında çalışacak fonksiyon
  double width; // Buton genişliği
  double height; // Buton yüksekliği
  double circular; // Yuvarlatılmış kenarlıklar
  double fontSize; // Font büyüklüğü

  WelcomeButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 50,
    this.circular = 30,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Arkaplan rengi
          foregroundColor: Colors.white, // Yazı rengi
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(circular), // Yuvarlatılmış kenarlar
          ),
          elevation: 5, // Butona hafif gölge
          shadowColor: Colors.blue[200], // Gölge rengi
          padding: const EdgeInsets.symmetric(vertical: 12), // Dikey padding
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize, // Daha büyük ve okunaklı metin
            fontWeight: FontWeight.bold, // Kalın yazı
          ),
        ),
      ),
    );
  }
}
