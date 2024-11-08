import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:yesil_piyasa/model/my_user.dart';
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
}
