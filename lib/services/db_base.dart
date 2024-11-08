import 'package:yesil_piyasa/model/my_user.dart';

abstract class DbBase {
  Future<bool> saveUser(MyUser myUser);
  Future<MyUser?> readUser(String userID);
}
