import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/core/widgets/my_alert_dialog.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();

  File? profilePhoto;
  late TextEditingController controllerAboutMe;
  late TextEditingController controllerUserName;
  late TextEditingController controllerEmail;
  late TextEditingController controllerPhoneNumber;
  late TextEditingController controllerLocation;

  @override
  void initState() {
    super.initState();
    final userModel = Provider.of<UserModel>(context, listen: false);

    controllerAboutMe =
        TextEditingController(text: userModel.user?.about ?? '');
    controllerUserName =
        TextEditingController(text: userModel.user?.name ?? '');
    controllerEmail = TextEditingController(text: userModel.user?.email ?? '');
    controllerPhoneNumber =
        TextEditingController(text: userModel.user?.phoneNumber ?? '');
    controllerLocation =
        TextEditingController(text: userModel.user?.location ?? '');
  }

  @override
  void dispose() {
    controllerAboutMe.dispose();
    controllerUserName.dispose();
    controllerEmail.dispose();
    controllerPhoneNumber.dispose();
    controllerLocation.dispose();
    super.dispose();
  }

  Future<void> _updateUserData(String field, String newValue) async {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    await userModel.updateUserData(field, userModel.user!.userID, newValue);
  }

  void _showEditDialog(BuildContext context, String title,
      TextEditingController controller, String field) {
    String previousValue = controller.text; // Mevcut değeri kaydediyoruz

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.green.shade50,
        title: Row(
          children: [
            Icon(Icons.agriculture, color: Colors.green.shade700, size: 28),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.green.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Form(
          key: _formKey,
          child: TextFormField(
            controller: controller,
            cursorColor: Colors.green.shade700,
            keyboardType: field == 'phoneNumber'
                ? TextInputType.phone // Telefon numarası için sayısal klavye
                : TextInputType.emailAddress, // E-posta için e-posta klavyesi
            decoration: InputDecoration(
              hintText: '${tr('enter')} $title',
              hintStyle: TextStyle(color: Colors.green.shade300),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.green.shade600, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.green.shade300),
              ),
            ),
            inputFormatters: field == 'phoneNumber'
                ? [
                    LengthLimitingTextInputFormatter(11),
                    FilteringTextInputFormatter.digitsOnly
                  ]
                : null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return tr('empty_field_error', args: [title]);
              }
              if (field == 'email' &&
                  !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return tr('invalid_email_error');
              }
              if (field == 'phoneNumber' &&
                  (value.length < 10 || value.length > 11)) {
                return tr('invalid_phone_error');
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.text = previousValue; // Önceki değeri geri yükle
              Navigator.pop(context);
            },
            child: Text(
              tr('cancel'),
              style: TextStyle(color: Colors.green.shade600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState?.validate() == true) {
                await _updateUserData(field, controller.text);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
            },
            child: Text(
              tr('save'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          tr('profile'),
          style: const TextStyle(
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
            child: Column(
              children: [
                const SizedBox(height: 20),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: NetworkImage(
                          Provider.of<UserModel>(context)
                                  .user
                                  ?.profileImageUrl ??
                              ''),
                    ),
                    Positioned(
                      bottom: -10,
                      right: -10,
                      child: FloatingActionButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera,
                                      color: Colors.green),
                                  title: Text(tr('take_photo')),
                                  onTap: () {
                                    takeAPhoto();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.image,
                                      color: Colors.green),
                                  title: Text(tr('select_from_gallery')),
                                  onTap: () {
                                    selectTheGallery();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        backgroundColor: Colors.green,
                        child:
                            const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 30.0),
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
                          _buildEditableField(
                            title: 'Kullanıcı Adı',
                            icon: Icons.person,
                            controller: controllerUserName,
                            field: 'name',
                          ),
                          _buildEditableField(
                            title: 'Açıklama',
                            icon: Icons.book,
                            controller: controllerAboutMe,
                            field: 'about',
                          ),
                          _buildEditableField(
                            title: 'E-posta',
                            icon: Icons.email,
                            controller: controllerEmail,
                            field: 'email',
                          ),
                          _buildEditableField(
                            title: 'Telefon Numarası',
                            icon: Icons.phone,
                            controller: controllerPhoneNumber,
                            field: 'phoneNumber',
                          ),
                          _buildEditableField(
                            title: 'Konum',
                            icon: Icons.location_on,
                            controller: controllerLocation,
                            field: 'location',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String title,
    required IconData icon,
    required TextEditingController controller,
    required String field,
  }) {
    return ListTile(
      title: Text(
        controller.text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      leading: Icon(icon, color: Colors.green),
      trailing: IconButton(
        onPressed: field == 'email'
            ? null
            : () {
                _showEditDialog(
                  context,
                  tr(field), // Örn. "phone_number"
                  controller,
                  field,
                );
              },
        icon: const Icon(Icons.edit, color: Colors.green),
      ),
    );
  }

  Future<void> takeAPhoto() async {
    final photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        profilePhoto = File(photo.path);
      });
      _updateProfilePhoto();
    }
  }

  Future<void> selectTheGallery() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        profilePhoto = File(image.path);
      });
      _updateProfilePhoto();
    }
  }

  Future<void> _updateProfilePhoto() async {
    final userModel = Provider.of<UserModel>(context, listen: false);

    if (profilePhoto != null) {
      try {
        var url = await userModel.uploadFile(
            userModel.user!.userID, "profile_photo", profilePhoto!);
        if (mounted) {
          if (url.isEmpty) {
            showDialog(
              context: context,
              builder: (context) {
                profilePhoto = null;
                return MyAlertDialog(
                  title: tr('photo_could_not_save'),
                  contentText: tr('try_again'),
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return MyAlertDialog(
                    title: tr('photo_saved'), contentText: tr('you_can_leave'));
              },
            );
          }
        }
        if (kDebugMode) {
          print('Received URL: $url');
        }
      } catch (e) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return MyAlertDialog(
                title: tr('error'),
                contentText: tr('an_error_occurred', args: [e.toString()]),
              );
            },
          );
        }
        if (kDebugMode) {
          print('Error: $e');
        }
      }
    }
  }
}
