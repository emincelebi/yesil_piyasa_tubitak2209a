import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:yesil_piyasa/model/my_user.dart';
import 'package:yesil_piyasa/model/product.dart';
import 'package:yesil_piyasa/services/db_base.dart';

class FireStoreDBService implements DbBase {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(MyUser myUser) async {
    await _firebaseDB
        .collection("users")
        .doc(myUser.userID)
        .set(myUser.toJson());
    return true;
  }

  @override
  Future<MyUser?> readUser(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> user =
        await _firebaseDB.collection('users').doc(userID).get();
    Map<String, dynamic> userInfo = user.data() ?? {};
    MyUser userObject = MyUser.fromJson(userInfo);
    if (kDebugMode) {
      print("okunan: $userObject");
    }
    return userObject;
  }

  @override
  Future<bool> updateUserData(
      String field, String userID, String newValue) async {
    var users = await _firebaseDB
        .collection('users')
        .where(field, isEqualTo: newValue)
        .get();
    if (users.docs.isNotEmpty) {
      return false;
    } else {
      await _firebaseDB
          .collection('users')
          .doc(userID)
          .update({field: newValue});
      return true;
    }
  }

  @override
  Future<bool> updateAboutMe(String userID, String newAbout) async {
    var users = await _firebaseDB
        .collection('users')
        .where('about', isEqualTo: newAbout)
        .get();
    if (users.docs.isNotEmpty) {
      return false;
    } else {
      await _firebaseDB
          .collection('users')
          .doc(userID)
          .update({'about': newAbout});
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto(String userId, String profilePhotoURL) async {
    await _firebaseDB
        .collection('users')
        .doc(userId)
        .update({'proifleImageUrl': profilePhotoURL});
    return true;
  }

  Future<void> saveProduct(Product product) async {
    await _firebaseDB.collection("products").add(product.toJson());
  }

  // Ürün güncelleme
  Future<void> updateProduct(Product product) async {
    await _firebaseDB
        .collection("products")
        .doc(product.productID) // Ürün ID'sine göre güncelleme yapıyoruz
        .update(product.toJson());
  }
}
