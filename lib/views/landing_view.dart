import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';
import 'package:yesil_piyasa/views/home_view.dart';
import 'package:yesil_piyasa/views/welcome_view.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

    if (userModel.state == ViewState.Idle) {
      if (userModel.user == null) {
        return const WelcomeView();
      } else {
        return HomeView(user: userModel.user);
      }
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
