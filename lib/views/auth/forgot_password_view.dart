import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/core/widgets/error_display.dart';
import 'package:yesil_piyasa/core/widgets/welcome_button.dart';
import 'package:yesil_piyasa/core/widgets/welcome_textfield.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  bool isOtpSent = false;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  Future<void> sendOtp(String phoneNumber) async {
    final userModel = Provider.of<UserModel>(context, listen: false);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+90$phoneNumber", // Ülke koduyla birlikte
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Doğrudan doğrulanırsa
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ErrorDisplay.showTopError(
              context, e.message ?? "verification_failed".tr());
        },
        codeSent: (String verificationId, int? resendToken) {
          userModel.verificationId = verificationId;
          setState(() {
            isOtpSent = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          userModel.verificationId = verificationId;
        },
      );
    } catch (e) {
      ErrorDisplay.showTopError(context, e.toString());
    }
  }

  Future<void> verifyOtpAndResetPassword(String otp, String newPassword) async {
    final userModel = Provider.of<UserModel>(context, listen: false);

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: userModel.verificationId,
        smsCode: otp,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        await userCredential.user!.updatePassword(newPassword);
        ErrorDisplay.showTopError(context, "password_reset_success".tr());
        Navigator.pop(context);
      }
    } catch (e) {
      ErrorDisplay.showTopError(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // AppBar'ı arka planda yerleştirir
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "forgot_password".tr(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent, // Şeffaf AppBar
        elevation: 0, // AppBar gölgesini kaldırır
      ),
      body: Stack(
        children: [
          // Arka plan görseli
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png', // Arka plan fotoğrafı
              fit: BoxFit.cover,
            ),
          ),
          // İçerik
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isOtpSent)
                  WelcomeTextField(
                    hintText: "enter_phone".tr(),
                    icon: Icons.phone,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                  ),
                if (isOtpSent) ...[
                  WelcomeTextField(
                    hintText: "enter_otp".tr(),
                    icon: Icons.code,
                    controller: otpController,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  WelcomeTextField(
                    hintText: "enter_new_password".tr(),
                    icon: Icons.lock,
                    obscureText: true,
                    controller: newPasswordController,
                  ),
                ],
                const SizedBox(height: 20),
                WelcomeButton(
                  text: isOtpSent ? "reset_password".tr() : "send_otp".tr(),
                  onPressed: () {
                    if (!isOtpSent) {
                      if (phoneController.text.isNotEmpty &&
                          (phoneController.text.length == 10 ||
                              phoneController.text.length == 11)) {
                        sendOtp(phoneController.text);
                      } else {
                        ErrorDisplay.showTopError(
                            context, "phone_length_error".tr());
                      }
                    } else {
                      if (otpController.text.isNotEmpty &&
                          newPasswordController.text.isNotEmpty) {
                        verifyOtpAndResetPassword(
                          otpController.text,
                          newPasswordController.text,
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
