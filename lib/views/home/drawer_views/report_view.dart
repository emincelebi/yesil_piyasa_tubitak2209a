import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _telefonController =
      TextEditingController(text: '0');
  final TextEditingController _sikayetController = TextEditingController();
  final TextEditingController _konuController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late final AnimationController _animationController;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Animasyon kontrolcüsü ve animasyon tanımı
    _animationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(); // Sonsuz döngü

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _sikayetGonder() async {
    if (_formKey.currentState!.validate()) {
      // E-posta içeriği
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'piyasayesil@gmail.com',
        query: Uri(queryParameters: {
          'subject': _konuController.text,
          'body':
              '${tr('phoneNumber')}: ${_telefonController.text}\n\n${tr('complaint')}: ${_sikayetController.text}'
        }).query,
      );

      // Mail uygulamasını aç
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'mail_app_could_not_open'.tr(),
              style: const TextStyle(
                  color: Colors.white), // Metin rengini beyaz yapıyoruz.
            ),
            backgroundColor: Colors.green, // Arka plan rengini yeşil yapıyoruz.
          ),
        );
      }
    }
  }

  String? _telefonuDogrula(String? deger) {
    final telefon = deger ?? '';
    if (telefon.length != 11 || !RegExp(r'^0\d{10}$').hasMatch(telefon)) {
      return 'phone_number_warning'.tr();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.05,
              horizontal: screenSize.width * 0.05,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.002) // Perspektif efekti
                          ..rotateY(
                              _rotationAnimation.value), // Y ekseninde dönme
                        child: child,
                      );
                    },
                    child: Image.asset(
                      'assets/images/logo.png', // Logonuzun yolu
                      height: screenSize.height * 0.15,
                    ),
                  ),
                  Text(
                    'report'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  Card(
                    color: Colors.white.withOpacity(0.8),
                    child: Padding(
                      padding: EdgeInsets.all(screenSize.width * 0.02),
                      child: TextFormField(
                        controller: _telefonController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText:
                              'number_complain'.tr(), //Şikayet edilecek numara
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                        validator: _telefonuDogrula,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            _telefonController.text = '0';
                            _telefonController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: _telefonController.text.length),
                            );
                          } else if (!value.startsWith('0')) {
                            _telefonController.text = '0$value';
                            _telefonController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: _telefonController.text.length),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Card(
                    color: Colors.white.withOpacity(0.8),
                    child: Padding(
                      padding: EdgeInsets.all(screenSize.width * 0.02),
                      child: TextFormField(
                        controller: _konuController,
                        maxLength: 30,
                        decoration: InputDecoration(
                          labelText: 'complaint_subject'.tr(), //Şikayet konusu
                          counterText: '',
                        ),
                        validator: (deger) {
                          if (deger == null || deger.isEmpty) {
                            return 'complaint_subject_warning'.tr();
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Card(
                    color: Colors.white.withOpacity(0.8),
                    child: Padding(
                      padding: EdgeInsets.all(screenSize.width * 0.02),
                      child: TextFormField(
                        controller: _sikayetController,
                        maxLines: 5,
                        maxLength: 150,
                        decoration: InputDecoration(
                          labelText: 'write_explanation'.tr(), //Açıklamayı yaz
                          counterText: '',
                        ),
                        validator: (deger) {
                          if (deger == null || deger.isEmpty) {
                            return 'explanation_warning'.tr();
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  ElevatedButton(
                    onPressed: _sikayetGonder,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.025,
                      ),
                      backgroundColor: Colors.blue[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'send'.tr(),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
