import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  _ReportViewState createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  final TextEditingController _telefonController =
      TextEditingController(text: '0');
  final TextEditingController _sikayetController = TextEditingController();
  final TextEditingController _konuController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _sikayetGonder() async {
    if (_formKey.currentState!.validate()) {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: 'piyasayesil@gmail.com',
        queryParameters: {
          'subject': _konuController.text,
          'body':
              'Telefon Numarası: ${_telefonController.text}\n\nŞikayet: ${_sikayetController.text}',
        },
      );

      // Simüle edilmiş e-posta gönderme
      final success = await _sendEmail(emailUri);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Başarıyla gönderildi")),
        );
        _telefonController.text = '0';
        _sikayetController.clear();
        _konuController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gönderim başarısız, tekrar deneyin")),
        );
      }
    }
  }

  Future<bool> _sendEmail(Uri emailUri) async {
    try {
      // E-posta API'nize burada bağlanabilirsiniz.
      // Bu örnekte canLaunch ve launch simüle ediliyor:
      if (await canLaunch(emailUri.toString())) {
        await launch(emailUri.toString());
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  String? _telefonuDogrula(String? deger) {
    final telefon = deger ?? '';
    if (telefon.length != 11 || !RegExp(r'^0\d{10}$').hasMatch(telefon)) {
      return 'Telefon numarası 0 ile başlamalı ve 11 haneli olmalı';
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
                  Image.asset(
                    'assets/images/logo.png', // Kendi logonuzla değiştirin
                    height: screenSize.height * 0.15,
                  ),
                  const Text(
                    'Şikayet Et',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                        decoration: const InputDecoration(
                          labelText: 'Şikayet edilecek numarayı giriniz',
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
                        decoration: const InputDecoration(
                          labelText: 'Şikayet konusu',
                          counterText: '',
                        ),
                        validator: (deger) {
                          if (deger == null || deger.isEmpty) {
                            return 'Şikayet konusu zorunludur';
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
                        decoration: const InputDecoration(
                          labelText: 'Açıklamayı Yazın...',
                          counterText: '',
                        ),
                        validator: (deger) {
                          if (deger == null || deger.isEmpty) {
                            return 'Şikayet açıklaması zorunludur';
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
                    child: const Text(
                      'Gönder',
                      style: TextStyle(color: Colors.white, fontSize: 18),
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
