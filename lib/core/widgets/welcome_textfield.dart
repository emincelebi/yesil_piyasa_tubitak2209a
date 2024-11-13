import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // FilteringTextInputFormatter için

class WelcomeTextField extends StatefulWidget {
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
  final List<TextInputFormatter>? inputFormatters; // Giriş formatlayıcıları
  final Function(String)? onChanged; // Değişiklik olduğunda çalışacak fonksiyon

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
    this.inputFormatters, // Giriş formatlayıcıları
    this.onChanged, // Değişiklik fonksiyonu
  });

  @override
  _WelcomeTextFieldState createState() => _WelcomeTextFieldState();
}

class _WelcomeTextFieldState extends State<WelcomeTextField> {
  bool _isObscure = false;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscure, // Şifre alanıysa gizli yazı
      keyboardType: widget.keyboardType, // Klavye tipi
      validator: widget.validator, // Doğrulama işlevi
      inputFormatters: widget.inputFormatters, // Giriş formatlayıcıları
      onChanged: widget.onChanged, // Değişikliklerde çalışacak fonksiyon
      decoration: InputDecoration(
        errorStyle: const TextStyle(color: Colors.white),
        hintText: widget.hintText,
        prefixIcon: Icon(widget.icon), // İlgili ikon
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null, // Sadece şifre alanıysa göz ikonu ekle
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(widget.borderRadius), // Oval kenarlar
          borderSide: BorderSide(color: widget.borderColor!), // Kenar rengi
        ),
        filled: true,
        fillColor: widget.fillColor, // Arka plan rengi
      ),
      style: TextStyle(color: widget.textColor), // Yazı rengi
    );
  }
}
