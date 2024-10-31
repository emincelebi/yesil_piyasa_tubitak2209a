import 'package:flutter/material.dart';
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
      debugPrint('ViewModel current error $e');
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
      debugPrint('ViewModel signInAnonymous error $e');
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
      debugPrint('ViewModel SignOut error $e');
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }
}
