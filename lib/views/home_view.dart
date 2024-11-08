import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/model/my_user.dart';
import 'package:yesil_piyasa/services/firestore_db_service.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';

// ignore: must_be_immutable
class HomeView extends StatelessWidget {
  HomeView({super.key, required this.user});

  final MyUser? user;

  MyUser? myUser;

  final FireStoreDBService fireStoreDBService = FireStoreDBService();

  Future<bool> _signOut(BuildContext context) async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    bool result = await userModel.signOut();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          IconButton(
              onPressed: () async {
                await _signOut(context);
              },
              icon: const Icon(Icons.logout))
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Text('Yeşil Piyasaya Hoşgeldiniz ${userModel.user!.email}'),
      ),
    );
  }
}
