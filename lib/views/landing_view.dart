import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';
import 'package:yesil_piyasa/views/auth/welcome_view.dart';
import 'package:yesil_piyasa/views/circular_view.dart';
import 'package:yesil_piyasa/views/home_view.dart';

class LandingView extends StatelessWidget {
  const LandingView({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

    return Stack(
      children: [
        if (userModel.state == ViewState.Idle)
          userModel.user == null
              ? const WelcomeView()
              : HomeView(user: userModel.user),
        if (userModel.state != ViewState.Idle) const CircularView(),
      ],
    );
  }
}
