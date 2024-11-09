import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  File? profilePhoto;
  late TextEditingController controllerAboutMe;
  late TextEditingController controllerUserName;

  @override
  void initState() {
    super.initState();
    controllerAboutMe = TextEditingController();
    controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    controllerAboutMe.dispose();
    controllerUserName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    print(userModel.user.toString());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Profil',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Consumer<UserModel>(
              builder: (context, userModel, child) {
                controllerAboutMe.text = userModel.user?.about ?? '';
                controllerUserName.text = userModel.user?.name ?? '';

                return Column(
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: NetworkImage(
                                    userModel.user?.profileImageUrl ?? '')
                                as ImageProvider),
                        Positioned(
                          bottom: -10,
                          right: -10,
                          child: FloatingActionButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return SizedBox(
                                    height: 170,
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.camera,
                                              color: Colors.green),
                                          title: const Text('Fotoğraf Çek'),
                                          onTap: () {},
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.image,
                                              color: Colors.green),
                                          title: const Text('Galeriden Seç'),
                                          onTap: () {},
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            backgroundColor: Colors.green,
                            child: const Icon(Icons.camera_alt,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 30.0),
                      child: Card(
                        color: Colors.white60,
                        shadowColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                  userModel.user?.name ?? '',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                leading: const Icon(Icons.person,
                                    color: Colors.green),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit,
                                      color: Colors.green),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ListTile(
                                title: Text(
                                  userModel.user?.about ??
                                      'Kendiniz hakkında bir şeyler yazın...',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                leading:
                                    const Icon(Icons.book, color: Colors.green),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.edit,
                                      color: Colors.green),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ListTile(
                                title: Text(
                                  userModel.user?.email ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                leading: const Icon(Icons.email,
                                    color: Colors.green),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
