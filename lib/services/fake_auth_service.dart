import 'package:yesil_piyasa/model/my_user.dart';
import 'package:yesil_piyasa/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  final String userID = "123616161123";

  @override
  Future<MyUser> currentUser() async {
    return await Future.value(MyUser(userID: userID, email: "user@gmail.com"));
  }

  @override
  Future<MyUser> signInAnonymously() async {
    return await Future.delayed(const Duration(seconds: 2),
        () => MyUser(userID: userID, email: "user@gmail.com"));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<MyUser?> createUserWithEmailAndPassword(
      String email, String password) async {
    return await null;
  }

  @override
  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    return await null;
  }
}
