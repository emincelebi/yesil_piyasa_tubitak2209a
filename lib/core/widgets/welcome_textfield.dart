import 'package:flutter/material.dart';

class WelcomeTextField extends StatelessWidget {
  final String hintText; // İpucu metni
  final IconData icon; // İlgili ikon
  final bool obscureText; // Şifre alanı olup olmadığını belirtir
  final TextInputType keyboardType; // Klavye tipi
  final Color? fillColor; // Arka plan rengi
  final Color? borderColor; // Kenar rengi
  final Color? textColor; // Yazı rengi
  final double borderRadius; // Kenar yuvarlama oranı
  final String? Function(String?)? validator; // Doğrulama işlevi
  final TextEditingController? controller; // Metin düzenleyici kontrolü

  const WelcomeTextField({
    super.key,
    required this.hintText,
    required this.icon,
    this.obscureText = false, // Varsayılan olarak şifre alanı değil
    this.keyboardType = TextInputType.text, // Varsayılan klavye tipi
    this.fillColor = Colors.white, // Varsayılan arka plan rengi
    this.borderColor = Colors.grey, // Varsayılan kenar rengi
    this.textColor = Colors.black, // Varsayılan yazı rengi
    this.borderRadius = 30.0, // Varsayılan kenar yuvarlama oranı
    this.validator, // Doğrulama işlevi
    this.controller, // Metin düzenleyici kontrolü
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText, // Şifre alanıysa gizli yazı
      keyboardType: keyboardType, // Klavye tipi
      validator: validator, // Doğrulama işlevi
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon), // İlgili ikon
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius), // Oval kenarlar
          borderSide: BorderSide(color: borderColor!), // Kenar rengi
        ),
        filled: true,
        fillColor: fillColor, // Arka plan rengi
      ),
      style: TextStyle(color: textColor), // Yazı rengi
    );
  }
}
