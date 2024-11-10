import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  // Sosyal medya ve iletişim bağlantılarına yönlendirme
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
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

                    // Logo
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Hakkımızda Kartı
                    _buildCard(
                      title: 'HAKKIMIZDA',
                      content:
                          'Yeşil Piyasa, tarım dünyasına dijital bir soluk getiren bir mobil uygulamadır. Çiftçilerin emeğini değerli kılarken, tüketicilere taze, doğal ürünlere kolay erişim sunar. \n\n'
                          'Bu platform, yerel ekonomiyi güçlendirmeyi hedefler; çiftçilerin ürünlerini doğrudan pazarlayabilmesini sağlarken, sağlıklı gıda alışverişini her zamankinden daha kolay ve güvenli hale getirir. \n\n'
                          'Yeşil Piyasa, tarımın geleceğini dijital dünyada şekillendirerek, hem çiftçilere hem de tüketicilere fayda sağlamayı amaçlar.',
                      context: context,
                    ),
                    const SizedBox(height: 20),

                    // Misyonumuz Kartı
                    _buildCard(
                      title: 'MİSYONUMUZ',
                      content:
                          'Çiftçilere emeğinin karşılığını alabileceği, sürdürülebilir ve kazançlı bir pazar alanı sunmak en büyük amacımızdır. \n\n'
                          'Tüketicilere ise taze, doğal ürünlere ulaşmanın kolay ve güvenli yollarını sağlıyoruz. Yerel tarım ekonomisini güçlendirmeye odaklanan Yeşil Piyasa, çiftçilerle alıcılar arasında doğrudan bir köprü kurar ve tarımı dijitalleştirerek modernize eder. \n\n'
                          'Her bir ürünün arkasındaki emeğe saygı gösteriyor, sağlıklı beslenmeyi destekliyor ve yerel ekonomilere katkıda bulunuyoruz.',
                      context: context,
                    ),
                    const SizedBox(height: 20),

                    // İletişim Kartı
                    _buildContactCard(context),
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
          _buildContactItem(
            icon: Icons.phone,
            text: '0505-422-9003',
            onTap: () => _launchUrl('tel:05054229003'),
          ),
          const Divider(),
          _buildContactItem(
            icon: Icons.email,
            text: 'piyasayesil@gmail.com',
            onTap: () => _launchUrl('mailto:piyasayesil@gmail.com'),
          ),
          const Divider(),
          _buildContactItem(
            icon: Icons.link,
            text: 'LinkedIn',
            onTap: () => _launchUrl(
                'https://www.linkedin.com/in/mustafa-k%C4%B1ra%C3%A7-1790b31bb/'),
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
}
