import 'dart:io';

import 'package:yesil_piyasa/locator.dart';
import 'package:yesil_piyasa/model/my_user.dart';
import 'package:yesil_piyasa/model/product.dart';
import 'package:yesil_piyasa/services/auth_base.dart';
import 'package:yesil_piyasa/services/fake_auth_service.dart';
import 'package:yesil_piyasa/services/firebase_auth_service.dart';
import 'package:yesil_piyasa/services/firebase_storage_service.dart';
import 'package:yesil_piyasa/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  final FireStoreDBService _fireStoreDbService = locator<FireStoreDBService>();
  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<MyUser?> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      MyUser? user = await _firebaseAuthService.currentUser();
      if (user != null) {
        return await _fireStoreDbService.readUser(user.userID);
      }
    }
    return null;
  }

  @override
  Future<MyUser?> signInAnonymously() async {
    return appMode == AppMode.DEBUG
        ? await _fakeAuthService.signInAnonymously()
        : await _firebaseAuthService.signInAnonymously();
  }

  @override
  Future<bool> signOut() async {
    return appMode == AppMode.DEBUG
        ? await _fakeAuthService.signOut()
        : await _firebaseAuthService.signOut();
  }

  @override
  Future<MyUser?> createUserWithEmailAndPassword(
      String email, String password, MyUser myUser) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createUserWithEmailAndPassword(
          email, password, myUser);
    } else {
      bool result = false;
      MyUser? user = await _firebaseAuthService.createUserWithEmailAndPassword(
          email, password, myUser);
      if (user != null) {
        MyUser saveUser = MyUser(
          userID: user.userID,
          email: email,
          name: myUser.name,
          surName: myUser.surName,
          location: myUser.location,
          phoneNumber: myUser.phoneNumber,
        );
        result = await _fireStoreDbService.saveUser(saveUser);
      }
      if (result) {
        return await _fireStoreDbService.readUser(user!.userID);
      }
      return null;
    }
  }

  @override
  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmailAndPassword(email, password);
    } else {
      MyUser? myUser = await _firebaseAuthService.signInWithEmailAndPassword(
          email, password);
      return await _fireStoreDbService.readUser(myUser!.userID);
    }
  }

  Future<bool> updateUserData(
      String field, String userID, String newValue) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _fireStoreDbService.updateUserData(field, userID, newValue);
    }
  }

  Future<String> uploadFile(
      String userId, String fileType, File uploadFile) async {
    if (appMode == AppMode.DEBUG) {
      return 'dosya_indirme_linki';
    } else {
      var profilePhotoURL = await _firebaseStorageService.uploadFile(
          userId, fileType, uploadFile);
      await _fireStoreDbService.updateProfilePhoto(userId, profilePhotoURL);
      return profilePhotoURL;
    }
  }

  Future<bool> addProduct(Product product) async {
    try {
      await _fireStoreDbService.saveProduct(product);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Ürün güncelleme
  Future<bool> updateProduct(Product product) async {
    try {
      await _fireStoreDbService.updateProduct(product);
      return true;
    } catch (e) {
      return false;
    }
  }
}
