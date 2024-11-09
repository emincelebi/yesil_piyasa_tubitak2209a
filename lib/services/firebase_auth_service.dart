import 'package:firebase_auth/firebase_auth.dart';
import 'package:yesil_piyasa/model/my_user.dart';
import 'package:yesil_piyasa/services/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<MyUser?> currentUser() async {
    User? user = _firebaseAuth.currentUser;
    return _myUserFromFirebase(user);
  }

  MyUser? _myUserFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return MyUser(userID: user.uid, email: user.email!);
  }

  @override
  Future<MyUser?> signInAnonymously() async {
    UserCredential result = await _firebaseAuth.signInAnonymously();
    return _myUserFromFirebase(result.user);
  }

  @override
  Future<bool> signOut() async {
    await _firebaseAuth.signOut();
    return true;
  }

  @override
  Future<MyUser?> createUserWithEmailAndPassword(
      String email, String password, MyUser myUser) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _myUserFromFirebase(result.user);
  }

  @override
  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _myUserFromFirebase(result.user);
  }
}
