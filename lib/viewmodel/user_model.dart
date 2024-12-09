import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yesil_piyasa/core/components/validate_check.dart';
import 'package:yesil_piyasa/locator.dart';
import 'package:yesil_piyasa/model/my_user.dart';
import 'package:yesil_piyasa/model/product.dart';
import 'package:yesil_piyasa/repository/user_repository.dart';
import 'package:yesil_piyasa/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  final UserRepository _userRepository = locator<UserRepository>();
  MyUser? _user;
  String _verificationId = "";

  String get verificationId => _verificationId;

  set verificationId(String id) {
    _verificationId = id;
    notifyListeners();
  }

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

  Future<MyUser> fetchUser(String userId) async {
    _state = ViewState.Busy;
    MyUser returnUser = await _userRepository.fetchUser(userId);
    _state = ViewState.Idle;
    return returnUser;
  }

  Future<void> addProduct(Product product) async {
    _state = ViewState.Busy;
    notifyListeners();

    try {
      await _userRepository.addProduct(product);
    } finally {
      _state = ViewState.Idle;
    }
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    _state = ViewState.Busy;
    notifyListeners();

    try {
      await _userRepository.updateProduct(product);
    } finally {
      _state = ViewState.Idle;
    }
    notifyListeners();
  }

  /// Ürün silme işlemi
  Future<void> deleteProduct(String productID, String userID) async {
    _state = ViewState.Busy;
    notifyListeners();

    try {
      await _userRepository.deleteProduct(productID, userID);
    } finally {
      _state = ViewState.Idle;
    }
    notifyListeners();
  }

  /// Tüm ürünleri getir
  Future<List<Product>> fetchAllProducts() async {
    _state = ViewState.Busy;
    notifyListeners();

    List<Product> products = [];
    try {
      products = await _userRepository.fetchAllProducts();
    } finally {
      _state = ViewState.Idle;
    }
    notifyListeners();
    return products;
  }

  /// Kullanıcının ürünlerini getir
  Future<List<Product>> fetchMyProducts() async {
    if (_user == null) return [];
    _state = ViewState.Busy;
    notifyListeners();

    List<Product> products = [];
    try {
      products = await _userRepository.fetchMyProducts(_user!.userID);
    } finally {
      _state = ViewState.Idle;
    }
    notifyListeners();
    return products;
  }

  Future<void> addProductToFavorites(String productID) async {
    _state = ViewState.Busy;

    if (_user != null) {
      await _userRepository.addProductToFavorites(_user!.userID, productID);
      notifyListeners();
    }
    _state = ViewState.Idle;
  }

  Future<void> removeProductFromFavorites(String productID) async {
    try {
      _state = ViewState.Busy;
      if (_user != null) {
        await _userRepository.removeProductFromFavorites(
            _user!.userID, productID);
        notifyListeners();
      }
    } finally {
      _state = ViewState.Idle;
    }
  }

  Future<List<String>> fetchUserFavorites() async {
    _state = ViewState.Busy;
    try {
      if (_user != null) {
        return await _userRepository.fetchUserFavorites(_user!.userID);
      }
    } finally {
      _state = ViewState.Idle;
    }

    return [];
  }

  Future<bool> isFavorited(String productId, String userId) async {
    try {
      _state = ViewState.Busy;
      if (_user != null) {
        return await _userRepository.isFavorited(productId, userId);
      }
    } finally {
      _state = ViewState.Idle;
    }

    return false;
  }
}
