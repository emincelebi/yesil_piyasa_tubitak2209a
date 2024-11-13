import 'dart:io';

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
    state = ViewState.Busy;
    _user = await _userRepository.currentUser();
    state = ViewState.Idle;
    return _user;
  }

  @override
  Future<MyUser?> signInAnonymously() async {
    state = ViewState.Busy;
    _user = await _userRepository.signInAnonymously();
    state = ViewState.Idle;
    return _user;
  }

  @override
  Future<bool> signOut() async {
    state = ViewState.Busy;
    bool result = await _userRepository.signOut();
    _user = null;
    state = ViewState.Idle;
    return result;
  }

  @override
  Future<MyUser?> createUserWithEmailAndPassword(
      String email, String password, MyUser myUser) async {
    if (checkEmailAndPassword(email, password)) {
      try {
        state = ViewState.Busy;
        _user = await _userRepository.createUserWithEmailAndPassword(
            email, password, myUser);
        return _user;
      } finally {
        state = ViewState.Idle;
      }
    }
    return null;
  }

  @override
  Future<MyUser?> signInWithEmailAndPassword(
      String email, String password) async {
    if (checkEmailAndPassword(email, password)) {
      try {
        state = ViewState.Busy;
        _user =
            await _userRepository.signInWithEmailAndPassword(email, password);
        return _user;
      } finally {
        state = ViewState.Idle;
      }
    }
    return null;
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

  Future<bool> updateUserData(
      String field, String userID, String newValue) async {
    bool success =
        await _userRepository.updateUserData(field, userID, newValue);
    if (success) {
      user!.name = newValue;
      notifyListeners();
    }
    return success;
  }

  Future<String> uploadFile(
      String userId, String fileType, File uploadFile) async {
    String downloadLink =
        await _userRepository.uploadFile(userId, fileType, uploadFile);
    notifyListeners();
    return downloadLink;
  }
}
