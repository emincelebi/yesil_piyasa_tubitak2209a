import 'package:easy_localization/easy_localization.dart'; // Import the easy_localization package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/core/components/validate_check.dart';
import 'package:yesil_piyasa/core/widgets/error_display.dart';
import 'package:yesil_piyasa/core/widgets/welcome_button.dart';
import 'package:yesil_piyasa/core/widgets/welcome_textfield.dart';
import 'package:yesil_piyasa/main.dart';
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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    nameController.dispose();
    surNameController.dispose();
    locationController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  String get email => _emailController.text;
  String get password => _passwordController.text;

  signUpEmailAndPassword(String email, String password, MyUser myUser) async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    try {
      if (_formKeyLogin.currentState != null) {
        _formKeyLogin.currentState!.save();
      }
      MyUser? user = await userModel.createUserWithEmailAndPassword(
          email, password, myUser);
      if (user != null && mounted) {
        debugPrint("$email $password");
        setState(() {});
      }
    } on FirebaseAuthException catch (e) {
      showError(e.code);
    }
  }

  signInEmailAndPassword(String email, String password) async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    try {
      if (_formKeySignup.currentState != null) {
        _formKeySignup.currentState!.save();
      }
      MyUser? user =
          await userModel.signInWithEmailAndPassword(email, password);
      if (user != null && mounted) {
        debugPrint("$email $password");
        setState(() {});
      }
    } on FirebaseAuthException catch (e) {
      showError(e.code);
    }
  }

  void showError(String englishCode) {
    BuildContext? context = rootNavigatorKey.currentState?.context;
    ErrorDisplay.showTopError(context!, englishCode);
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 170,
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(
                        text: "login".tr(), // Use localization key here
                        icon: const Icon(Icons.login, color: Colors.white),
                      ),
                      Tab(
                        text: "signup".tr(), // Use localization key here
                        icon: const Icon(Icons.app_registration,
                            color: Colors.white),
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
              hintText: "enter_email".tr(), // Use localization key for hint
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'email_error'
                      .tr(); // Use localization for validation error
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            WelcomeTextField(
              hintText: "enter_password".tr(), // Use localization key for hint
              icon: Icons.lock,
              obscureText: true,
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'password_error'
                      .tr(); // Use localization for validation error
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            WelcomeButton(
              text: "sign_in".tr(), // Use localization key for button text
              onPressed: () {
                if (_formKeyLogin.currentState?.validate() ?? false) {
                  signInEmailAndPassword(
                      _emailController.text, _passwordController.text);
                }
              },
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Handle forgotten password logic here
              },
              child: Text(
                "forgot_password"
                    .tr(), // Use localization key for forgot password text
                style: const TextStyle(color: Colors.white),
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
                hintText: "enter_name".tr(), // Use localization for hint text
                icon: Icons.person,
                controller: nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'name_error'
                        .tr(); // Use localization for validation error
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              WelcomeTextField(
                hintText:
                    "enter_surname".tr(), // Use localization for hint text
                icon: Icons.person_outline,
                controller: surNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'surname_error'
                        .tr(); // Use localization for validation error
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              WelcomeTextField(
                hintText: "enter_email".tr(), // Use localization for hint text
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: ValidateCheck().validateEmail,
              ),
              const SizedBox(height: 10),
              WelcomeTextField(
                hintText:
                    "enter_password".tr(), // Use localization for hint text
                icon: Icons.lock,
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'password_error'
                        .tr(); // Use localization for validation error
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              WelcomeTextField(
                hintText:
                    "enter_location".tr(), // Use localization for hint text
                icon: Icons.location_on,
                controller: locationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'location_error'
                        .tr(); // Use localization for validation error
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              WelcomeTextField(
                hintText: "enter_phone".tr(), // Use localization for hint text
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                controller: phoneController,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'phone_error'
                        .tr(); // Use localization for validation error
                  }
                  if (value.length != 10 && value.length != 11) {
                    return 'phone_length_error'.tr(); // Localization for error
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              WelcomeButton(
                text: "register".tr(), // Use localization for button text
                onPressed: () {
                  if (_formKeySignup.currentState?.validate() ?? false) {
                    signUpEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                      MyUser(
                          userID: "1",
                          email: _emailController.text,
                          name: nameController.text,
                          surName: surNameController.text,
                          location: locationController.text,
                          phoneNumber: phoneController.text),
                    );
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
