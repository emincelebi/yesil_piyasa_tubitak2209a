import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:yesil_piyasa/model/my_user.dart';
import 'package:yesil_piyasa/model/product.dart';
import 'package:yesil_piyasa/services/db_base.dart';

class FireStoreDBService implements DbBase {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(MyUser myUser) async {
    await _firebaseDB
        .collection("users")
        .doc(myUser.userID)
        .set(myUser.toJson());
    return true;
  }

  @override
  Future<MyUser?> readUser(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> user =
        await _firebaseDB.collection('users').doc(userID).get();
    Map<String, dynamic> userInfo = user.data() ?? {};
    MyUser userObject = MyUser.fromJson(userInfo);
    if (kDebugMode) {
      print("okunan: $userObject");
    }
    return userObject;
  }

  @override
  Future<bool> updateUserData(
      String field, String userID, String newValue) async {
    var users = await _firebaseDB
        .collection('users')
        .where(field, isEqualTo: newValue)
        .get();
    if (users.docs.isNotEmpty) {
      return false;
    } else {
      await _firebaseDB
          .collection('users')
          .doc(userID)
          .update({field: newValue});
      return true;
    }
  }

  @override
  Future<bool> updateAboutMe(String userID, String newAbout) async {
    var users = await _firebaseDB
        .collection('users')
        .where('about', isEqualTo: newAbout)
        .get();
    if (users.docs.isNotEmpty) {
      return false;
    } else {
      await _firebaseDB
          .collection('users')
          .doc(userID)
          .update({'about': newAbout});
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto(String userId, String profilePhotoURL) async {
    await _firebaseDB
        .collection('users')
        .doc(userId)
        .update({'proifleImageUrl': profilePhotoURL});
    return true;
  }

  Future<void> addProduct(Product product) async {
    try {
      // Firestore'da ürün koleksiyonuna yeni bir belge referansı oluştur
      final productRef =
          FirebaseFirestore.instance.collection('products').doc();

      // Otomatik oluşturulan ID
      String productId = productRef.id;

      // Ürünü Firestore'a kaydet
      await productRef.set({
        'productID': productId, // Otomatik ID'yi productID olarak kaydet
        'name': product.name,
        'userID': product.userID,
        'description': product.description,
        'price': product.price,
        'unit': product.unit,
        'stock': product.stock,
        'imageUrl': product.imageUrl,
        'category': product.category,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Kullanıcıya ait ürünler listesine bu yeni ürünü ekle
      await FirebaseFirestore.instance
          .collection('users')
          .doc(product.userID)
          .update({
        'products': FieldValue.arrayUnion([productId]),
      });

      print('Product added with ID: $productId');
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  // Ürün güncelleme
  Future<void> updateProduct(Product product) async {
    await _firebaseDB
        .collection("products")
        .doc(product.productID) // Ürün ID'sine göre güncelleme yapıyoruz
        .update(product.toJson());
  }

  // Ürün silme
  Future<void> deleteProduct(String productID, String userID) async {
    try {
      // Kullanıcıyı getir
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firebaseDB.collection("users").doc(userID).get();

      if (userDoc.exists) {
        // Kullanıcının ürün listesinden ürünü kaldır
        List<String>? products =
            List<String>.from(userDoc.data()?['products'] ?? []);
        products.remove(productID);

        await _firebaseDB
            .collection("users")
            .doc(userID)
            .update({'products': products});
      }

      // Ürünü Firestore'dan sil
      await _firebaseDB.collection("products").doc(productID).delete();
    } catch (e) {
      if (kDebugMode) {
        print("Ürün silinirken hata oluştu: $e");
      }
      rethrow;
    }
  }

// Tüm ürünleri getir
  Future<List<Product>> fetchAllProducts() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firebaseDB.collection("products").get();

    List<Product> products = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      return Product.fromJson(data..['productID'] = doc.id);
    }).toList();

    return products;
  }

// Kullanıcıya ait ürünleri getir
  Future<List<Product>> fetchMyProducts(String userID) async {
    // Belirtilen kullanıcının ürünlerini getir
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseDB
        .collection("products")
        .where("userID", isEqualTo: userID)
        .get();

    // Ürün listesini döndür
    List<Product> products = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      return Product.fromJson(data..['productID'] = doc.id);
    }).toList();

    return products;
  }

  Future<void> addProductToFavorites(String userID, String productID) async {
    await _firebaseDB.collection('users').doc(userID).update({
      'myFavorites': FieldValue.arrayUnion([productID])
    });
  }

  Future<void> removeProductFromFavorites(
      String userID, String productID) async {
    await _firebaseDB.collection('users').doc(userID).update({
      'myFavorites': FieldValue.arrayRemove([productID])
    });
  }

  Future<List<String>> fetchUserFavorites(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _firebaseDB.collection('users').doc(userID).get();

    if (userDoc.exists) {
      return List<String>.from(userDoc.data()?['myFavorites'] ?? []);
    }
    return [];
  }

  Future<List<String>> fetchFavoriteProducts(String userId) async {
    try {
      final userDoc = await _firebaseDB.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;
        if (data['myFavorites'] != null && data['myFavorites'] is List) {
          return List<String>.from(data['myFavorites']);
        }
      }
      return [];
    } catch (e) {
      print("Error fetching favorite products: $e");
      return [];
    }
  }

  Future<bool> isFavorited(String productId, String userId) async {
    try {
      final userDoc = await _firebaseDB.collection('users').doc(userId).get();
      if (userDoc.exists && userDoc.data() != null) {
        final data = userDoc.data()!;
        if (data['myFavorites'] != null &&
            data['myFavorites'].contains(productId)) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Error fetching favorite products: $e");
      return false;
    }
  }

  // Beğeni sayısını artırma
  Future<void> incrementLike(String productId) async {
    final productRef = _firebaseDB.collection('products').doc(productId);

    // Firestore'da likes alanını artırma
    await productRef.update({
      'likes': FieldValue.increment(1),
    });
  }

  // Beğeni sayısını azaltma
  Future<void> decrementLike(String productId) async {
    final productRef = _firebaseDB.collection('products').doc(productId);

    // Firestore'da likes alanını azaltma
    await productRef.update({
      'likes': FieldValue.increment(-1),
    });
  }

  Future<MyUser> fetchUser(String userId) async {
    final fetchedUser = await _firebaseDB.collection('users').doc(userId).get();
    Map<String, dynamic> userInfo = fetchedUser.data() ?? {};
    MyUser userObject = MyUser.fromJson(userInfo);

    return userObject;
  }
}
