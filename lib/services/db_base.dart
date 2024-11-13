import 'package:yesil_piyasa/model/my_user.dart';

abstract class DbBase {
  Future<bool> saveUser(MyUser myUser);
  Future<MyUser?> readUser(String userID);
  Future<bool> updateUserData(String field, String userID, String newValue);
  Future<bool> updateAboutMe(String userId, String newAbout);
  Future<bool> updateProfilePhoto(String userId, String profilePhotoURL);
}
