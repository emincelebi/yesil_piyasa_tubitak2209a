import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yesil_piyasa/views/home_view.dart';
import 'package:yesil_piyasa/views/welcome_view.dart';

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  late User? _user;

  Future<void> _checkUser() async {
    _user = FirebaseAuth.instance.currentUser;
  }

  void _updateUser(User? user) {
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return WelcomeView(
        onSignIn: (user) {
          _updateUser(user);
        },
      );
    } else {
      return HomeView(
        user: _user,
        onSignOut: () {
          _updateUser(null);
        },
      );
    }
  }
}
