// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String userID; // Kullanıcının eşşiz id'si
  final String email; // Kullanıcının emaili
  String name; // Kullanıcının adı
  String surName; // Kullanıcının soyadı
  String phoneNumber; // Kullanıcının telefon numarası
  String location; // Kullanıcının bulunduğu konum (şehir/ilçe bilgisi)
  List<String>? products; // Kullanıcının sattığı ürünlerin listesi, opsiyonel
  String? about; // Kullanıcı hakkında kısa bilgi veya açıklama
  String? profileImageUrl; // Profil resmi URL’si
  DateTime? createdAt; // Kullanıcının oluşturulma tarihi
  DateTime? updatedAt; // Kullanıcının güncellenme tarihi

  MyUser({
    required this.userID,
    required this.email,
    this.name = "",
    this.surName = "",
    this.location = "",
    this.phoneNumber = "",
    this.products,
    this.about,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
  });

  // JSON’dan `MyUser` nesnesi oluşturma
  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      userID: json['userID'],
      email: json['email'],
      name: json['name'] ?? "",
      surName: json['surName'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      location: json['location'] ?? "",
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      about: json['about'],
      profileImageUrl: json['profileImageUrl'],
      createdAt: (json['createdAt']).toDate(),
      updatedAt: (json['updatedAt']).toDate(),
    );
  }

  // `MyUser` nesnesini JSON’a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'email': email,
      'name': name,
      'surName': surName,
      'phoneNumber': phoneNumber,
      'location': location,
      'products': products ?? [],
      'about': about ?? 'Çiftçiyim',
      'profileImageUrl': profileImageUrl ??
          'https://static.vecteezy.com/system/resources/previews/020/911/740/non_2x/user-profile-icon-profile-avatar-user-icon-male-icon-face-icon-profile-icon-free-png.png',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
    };
  }

  @override
  String toString() {
    return 'MyUser(userID: $userID, email: $email, name: $name, surName: $surName, phoneNumber: $phoneNumber, location: $location, products: $products, about: $about, profileImageUrl: $profileImageUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
