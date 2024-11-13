import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:yesil_piyasa/services/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  Future<String> uploadFile(
      String userId, String fileType, File uploadFile) async {
    try {
      Reference storageReference = firebaseStorage
          .ref()
          .child(userId)
          .child(fileType)
          .child("profile_photo.png");
      // ignore: unused_local_variable
      UploadTask uploadTask = storageReference.putFile(uploadFile);
      String downloadUrl = await storageReference.getDownloadURL();
      if (kDebugMode) {
        print(downloadUrl);
      }

      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('File Upload Error: $e');
      }
      return '';
    }
  }
}
