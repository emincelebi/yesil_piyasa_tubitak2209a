import 'package:flutter/material.dart';
import 'package:yesil_piyasa/core/components/validate_check.dart';
import 'package:yesil_piyasa/locator.dart';
import 'package:yesil_piyasa/model/my_user.dart';
import 'package:yesil_piyasa/repository/user_repository.dart';
import 'package:yesil_piyasa/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  final UserRepository _userRepository = locator<UserRepository>();
  MyUser? _user;

  MyUser? get user => _user;

  ViewState get state => _state;

  set state(ViewState state) {
    _state = state;
    notifyListeners();
  }

  UserModel() {
    currentUser();
  }

  @override
  Future<MyUser?> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      return _user;
    } catch (e) {
      debugPrint('Error in currentUser: $e');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<MyUser?> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInAnonymously();
      return _user;
    } catch (e) {
      debugPrint('Error in anonymous sign-in: $e');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool result = await _userRepository.signOut();
      _user = null;
      return result;
    } catch (e) {
      debugPrint('Error in sign-out: $e');
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<MyUser?> createUserWithEmailAndPassword(
      String email, String password, MyUser myUser) async {
    try {
      if (checkEmailAndPassword(email, password)) {
        state = ViewState.Busy;
        _user = await _userRepository.createUserWithEmailAndPassword(
            email, password, myUser);
        return _user;
      }
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      if (checkEmailAndPassword(email, password)) {
        state = ViewState.Busy;
        _user =
            await _userRepository.signInWithEmailAndPassword(email, password);
        return _user;
      }
      return null;
    } catch (e) {
      debugPrint('ViewModel signIn error $e');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  bool checkEmailAndPassword(String email, String password) {
    var result = true;
    if (!(ValidateCheck().validatePasswordBool(password))) {
      result = false;
    } else {
      result = true;
    }
    if (!(ValidateCheck().validateEmailBool(email))) {
      result = false;
    } else {
      result = true;
    }
    return result;
  }
}
