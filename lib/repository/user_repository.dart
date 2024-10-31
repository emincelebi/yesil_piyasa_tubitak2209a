import 'package:yesil_piyasa/locator.dart';
import 'package:yesil_piyasa/model/my_user.dart';
import 'package:yesil_piyasa/services/auth_base.dart';
import 'package:yesil_piyasa/services/fake_auth_service.dart';
import 'package:yesil_piyasa/services/firebase_auth_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FakeAuthService _fakeAuthService = locator<FakeAuthService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<MyUser?> currentUser() async {
    return appMode == AppMode.DEBUG
        ? await _fakeAuthService.currentUser()
        : await _firebaseAuthService.currentUser();
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
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createUserWithEmailAndPassword(
          email, password);
    } else {
      MyUser? user = await _firebaseAuthService.createUserWithEmailAndPassword(
          email, password);
      return user;
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
      if (myUser != null) return myUser;
    }
    return null;
  }
}
