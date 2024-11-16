import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:yesil_piyasa/core/components/enums/locales.dart';
import 'package:yesil_piyasa/init/product_localization.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        title: Text(tr('settings')),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[50]!, Colors.blue[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Bildirimler Ayarı
            ListTile(
              leading: Icon(Icons.notifications, color: Colors.green[800]),
              title: Text(tr('notifications')),
              trailing: Switch(
                value: _notificationsEnabled,
                activeColor: Colors.green[700],
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),
            const Divider(),

            // Karanlık Mod Ayarı
            ListTile(
              leading: Icon(Icons.dark_mode, color: Colors.green[800]),
              title: Text(tr('dark_mode')),
              trailing: Switch(
                value: _darkModeEnabled,
                activeColor: Colors.green[700],
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                },
              ),
            ),
            const Divider(),

            // Dil Seçenekleri
            ListTile(
              leading: Icon(Icons.language, color: Colors.green[800]),
              title: Text(tr('language_options')),
              subtitle:
                  Text('${tr('selected_language')}: ${tr('languageName')}'),
              onTap: () {
                _showLanguageDialog(context);
              },
            ),
            const Divider(),

            // Yardım ve Destek
            ListTile(
              leading: Icon(Icons.help, color: Colors.green[800]),
              title: Text(tr('help_and_support')),
              onTap: () {
                // Buraya destek sayfasına yönlendirme yapılabilir.
              },
            ),
          ],
        ),
      ),
    );
  }

  // Dil Seçim Diyaloğu
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language, size: 48, color: Colors.blue),
                const SizedBox(height: 10),
                Text(
                  tr('select_language'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                // Türkçe
                _buildLanguageOption(
                  context,
                  flagPath: 'assets/flags/turkiye.png',
                  languageName: 'Türkçe',
                  locale: Locales.tr,
                ),
                const Divider(thickness: 1, color: Colors.blueGrey),
                // English
                _buildLanguageOption(
                  context,
                  flagPath: 'assets/flags/england.png',
                  languageName: 'English',
                  locale: Locales.en,
                ),
                const Divider(thickness: 1, color: Colors.blueGrey),
                // Deutsch
                _buildLanguageOption(
                  context,
                  flagPath: 'assets/flags/germany.png',
                  languageName: 'Deutsch',
                  locale: Locales.de,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String flagPath,
    required String languageName,
    required Locales locale,
  }) {
    return GestureDetector(
      onTap: () async {
        await ProductLocalization.updateLanguage(
          context: context,
          value: locale,
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(flagPath),
              radius: 18,
            ),
            const SizedBox(width: 10),
            Text(
              languageName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
