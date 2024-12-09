import 'package:url_launcher/url_launcher.dart';

class MyLaunch {
  Future<void> launchEmail(String? email) async {
    if (email == null || email.isEmpty) {
      throw 'E-posta adresi geçerli değil.';
    }

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Ürün Hakkında&body=Merhaba,',
    );

    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      throw 'E-posta açılamadı: $email';
    }
  }

  Future<void> launchPhoneNumber(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Telefon numarası açılamadı: $url';
    }
  }
}
