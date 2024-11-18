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
      print(userId + fileType + uploadFile.toString());

      // Dosya yolunu doğru bir şekilde belirtmek
      Reference storageReference = firebaseStorage
          .ref()
          .child(userId) // Kullanıcı ID'si
          .child(fileType) // Dosya türü (profile_photo, vb.)
          .child("profile_photo.png"); // Dosya adı (dinamik yapabilirsiniz)

      // Dosya yükleme işlemi
      UploadTask uploadTask = storageReference.putFile(uploadFile);

      // Yükleme tamamlandığında URL'yi almak için await kullanmalısınız
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

      // Yükleme tamamlandığında dosya URL'sini alın
      String downloadUrl = await snapshot.ref.getDownloadURL();

      if (kDebugMode) {
        print("Dosya URL'si: $downloadUrl");
      }

      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Dosya Yükleme Hatası: $e');
      }
      return ''; // Hata durumunda boş döndür
    }
  }
}
