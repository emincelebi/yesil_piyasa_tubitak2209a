import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    // Animasyon denetleyicisi başlatılıyor
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(); // Animasyonu sürekli tekrar ettiriyoruz
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true, // Arka planı appbar ile birleştirir
      body: Stack(
        children: [
          // Arka plan resmi
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.3),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // İçerik kısmı
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                        height: 100), // Logoyu biraz daha aşağıya çektik

                    // Animasyonlu Logo
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..rotateY(_animationController.value *
                                2 *
                                pi), // Y ekseninde 3D dönüş
                          child: child,
                        );
                      },
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Hakkımızda Kartı
                    _buildCard(
                      title: 'HAKKIMIZDA',
                      content:
                          'Yeşil Piyasa, tarım dünyasına dijital bir soluk getiren bir mobil uygulamadır. Çiftçilerin emeğini değerli kılarken, tüketicilere taze ve doğal ürünlere kolay erişim sunar.\n\n'
                          'Bu platform, yerel ekonomiyi güçlendirmeyi hedefler; çiftçilerin ürünlerini doğrudan pazarlayabilmesini sağlarken, sağlıklı gıda alışverişini daha kolay ve güvenli hale getirir.\n\n'
                          'Yeşil Piyasa, tarımın geleceğini dijital dünyada şekillendirerek, hem çiftçilere hem de tüketicilere fayda sağlamayı amaçlar.',
                      context: context,
                    ),
                    const SizedBox(height: 20),

                    // Misyonumuz Kartı
                    _buildCard(
                      title: 'MİSYONUMUZ',
                      content:
                          'Çiftçilere emeğinin karşılığını alabileceği, sürdürülebilir ve kazançlı bir pazar alanı sunmak en büyük amacımızdır.\n\n'
                          'Tüketicilere ise taze ve doğal ürünlere ulaşmanın kolay ve güvenli yollarını sağlıyoruz. Yerel tarım ekonomisini güçlendirmeye odaklanan Yeşil Piyasa, çiftçilerle alıcılar arasında doğrudan bir köprü kurar ve tarımı dijitalleştirerek modernize eder.\n\n'
                          'Her bir ürünün arkasındaki emeğe saygı gösteriyor, sağlıklı beslenmeyi destekliyor ve yerel ekonomilere katkıda bulunuyoruz.',
                      context: context,
                    ),
                    const SizedBox(height: 20),

                    // İletişim Kartı
                    _buildContactCard(context),
                    const SizedBox(height: 10), // Ekstra boşluk
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Kart yapısı (Başlık ve içerik ile birlikte)
  Widget _buildCard(
      {required String title,
      required String content,
      required BuildContext context}) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.045,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // İletişim kartı
  Widget _buildContactCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 20.0), // Dinamik boşluk
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'İLETİŞİM',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildContactItem(
                  icon: Icons.phone,
                  text: '0551-553-1541',
                  onTap: () => _launchUrl('tel:05515531541'),
                ),
              ),
              Expanded(
                child: _buildContactItem(
                  icon: Icons.phone,
                  text: '0505-422-9003',
                  onTap: () => _launchUrl('tel:05054229003'),
                ),
              ),
            ],
          ),
          const Divider(),
          _buildContactItem(
            icon: Icons.email,
            text: 'piyasayesil@gmail.com',
            onTap: () => _launchUrl(
                'mailto:piyasayesil@gmail.com?subject=İletişim&body=Merhaba%20Yeşil%20Piyasa%20Ekibi'),
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: _buildContactItem(
                  icon: Icons.link,
                  text: 'Emin Çelebi',
                  onTap: () =>
                      _launchUrl('https://www.linkedin.com/in/emincelebi/'),
                ),
              ),
              Expanded(
                child: _buildContactItem(
                  icon: Icons.link,
                  text: 'Mustafa Kıraç',
                  onTap: () => _launchUrl(
                      'https://www.linkedin.com/in/mustafa-k%C4%B1ra%C3%A7-1790b31bb/'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // İletişim bilgileri için tekrar kullanılabilir widget
  Widget _buildContactItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[500]),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
