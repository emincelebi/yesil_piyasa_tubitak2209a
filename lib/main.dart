import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/init/product_localization.dart';
import 'package:yesil_piyasa/locator.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';
import 'package:yesil_piyasa/views/landing_view.dart';

GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey();
void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProductLocalization(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
        locale: context.locale, // Varsayılan dil
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        navigatorKey: rootNavigatorKey,
        title: 'Yeşil Piyasa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const LandingView(),
      ),
    );
  }
}
