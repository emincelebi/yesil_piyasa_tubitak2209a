import 'package:get_it/get_it.dart';
import 'package:yesil_piyasa/repository/user_repository.dart';
import 'package:yesil_piyasa/services/fake_auth_service.dart';
import 'package:yesil_piyasa/services/firebase_auth_service.dart';
import 'package:yesil_piyasa/services/firestore_db_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FireStoreDBService());
}
