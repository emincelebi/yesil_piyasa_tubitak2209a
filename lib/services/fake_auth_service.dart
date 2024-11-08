import 'package:yesil_piyasa/model/my_user.dart';
import 'package:yesil_piyasa/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  final MyUser myUser = MyUser(
      userID: "616161",
      email: "myuser@gmail.com",
      name: "user",
      surName: "myUser",
      location: "Trabzon");

  @override
  Future<MyUser> currentUser() async {
    return await Future.value(myUser);
  }

  @override
  Future<MyUser> signInAnonymously() async {
    return await Future.delayed(const Duration(seconds: 2), () => myUser);
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<MyUser?> createUserWithEmailAndPassword(
      String email, String password, MyUser myUser) async {
    return await Future.delayed(
      const Duration(seconds: 1),
      () => myUser,
    );
  }

  @override
  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    return await Future.delayed(
      const Duration(seconds: 1),
      () => myUser,
    );
  }
}
