import 'package:yesil_piyasa/model/my_user.dart';

abstract class AuthBase {
  Future<MyUser?> currentUser();
  Future<MyUser?> signInAnonymously();
  Future<bool> signOut();
}
