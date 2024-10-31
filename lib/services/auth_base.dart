import 'package:yesil_piyasa/model/my_user.dart';

abstract class AuthBase {
  Future<MyUser?> currentUser();
  Future<MyUser?> signInAnonymously();
  Future<bool> signOut();
  Future<MyUser?> createUserWithEmailAndPassword(String email, String password);
  Future<MyUser?> signInWithEmailAndPassword(String email, String password);
}
