import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/core/widgets/welcome_button.dart';
import 'package:yesil_piyasa/core/widgets/welcome_textfield.dart';
import 'package:yesil_piyasa/model/my_user.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';

enum LoginState { initialize, login, signup }

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeySignup = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _anonymousLogin() async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    MyUser? user = await userModel.signInAnonymously();
    if (kDebugMode) {
      print('Oturum acan user: ${user!.userID}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                width: width,
                height: height,
                child: Image.asset(
                  'assets/images/background.png',
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 100,
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(
                        text: "Giriş Yap",
                        icon: Icon(Icons.login, color: Colors.white),
                      ),
                      Tab(
                        text: "Kayıt Ol",
                        icon: Icon(Icons.app_registration, color: Colors.white),
                      ),
                    ],
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.white,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      height: 500,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          showLogin(),
                          showSignup(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  WelcomeButton(
                    text: 'Misafir Girişi',
                    onPressed: _anonymousLogin,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showLogin() {
    return Form(
      key: _formKeyLogin,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WelcomeTextField(
              hintText: 'E-posta Adresiniz...',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen e-posta adresinizi girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            WelcomeTextField(
              hintText: 'Şifreniz...',
              icon: Icons.lock,
              obscureText: true,
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Şifreniz en az 6 karakter olmalıdır';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            WelcomeButton(
              text: 'Giriş Yap',
              onPressed: () {
                if (_formKeyLogin.currentState?.validate() ?? false) {
                  // Giriş işlemi
                }
              },
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Şifrenizi mi unuttunuz işlemi
              },
              child: const Text(
                'Şifrenizi mi unuttunuz?',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showSignup() {
    return SingleChildScrollView(
      child: Form(
        key: _formKeySignup,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WelcomeTextField(
                hintText: 'Adınız...',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen adınızı girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              WelcomeTextField(
                hintText: 'Soyadınız...',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen soyadınızı girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              WelcomeTextField(
                hintText: 'E-posta Adresiniz...',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen e-posta adresinizi girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              WelcomeTextField(
                hintText: 'Şifreniz...',
                icon: Icons.lock,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Şifreniz en az 6 karakter olmalıdır';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              WelcomeTextField(
                hintText: 'Konumunuz...',
                icon: Icons.location_on,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen konumunuzu girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              WelcomeButton(
                text: 'Kayıt Ol',
                onPressed: () {
                  if (_formKeySignup.currentState?.validate() ?? false) {
                    // Kayıt işlemi
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
