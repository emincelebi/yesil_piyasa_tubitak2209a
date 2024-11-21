import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String productID; // Ürün ID'si
  final String name; // Ürün ismi
  final String userID; // Ürünü ekleyen kullanıcının ID'si
  String? description; // Ürün açıklaması
  double price; // Ürün fiyatı
  String unit; // Fiyat birimi (ör. kg, adet)
  int stock; // Mevcut stok miktarı
  String? imageUrl; // Ürün resmi URL’si
  DateTime? createdAt; // Ürün eklenme tarihi
  DateTime? updatedAt; // Ürün güncellenme tarihi
  String category;

  Product({
    required this.productID,
    required this.name,
    required this.userID,
    required this.price,
    required this.unit,
    required this.stock,
    required this.category,
    this.description,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productID: json['productID'],
      name: json['name'],
      userID: json['userID'],
      description: json['description'],
      price: json['price'].toDouble(),
      unit: json['unit'],
      stock: json['stock'],
      category: json['category'],
      imageUrl: json['imageUrl'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productID': productID,
      'name': name,
      'userID': userID,
      'description': description,
      'price': price,
      'unit': unit,
      'stock': stock,
      'imageUrl': imageUrl,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'category': category,
    };
  }
}
