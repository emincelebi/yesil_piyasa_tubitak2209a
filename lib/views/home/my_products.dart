import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:yesil_piyasa/model/my_user.dart'; // MyUser modelini import edin
import 'package:yesil_piyasa/model/product.dart'; // Product modelini import edin

class MyProductsView extends StatefulWidget {
  const MyProductsView({super.key});

  @override
  State<MyProductsView> createState() => _MyProductsViewState();
}

class _MyProductsViewState extends State<MyProductsView> {
  // Kullanıcıyı Firestore'dan alacağız
  late MyUser currentUser;
  List<Product> products = [];
  bool isLoading = true; // Veri çekme durumu

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Kullanıcı verisini çekmeye başla
  }

  // Kullanıcıyı Firestore'dan çekme
  Future<void> _fetchUserData() async {
    try {
      // Kullanıcı verisini Firestore'dan alıyoruz
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(
              'userID') // Burada 'userID' dinamik olarak kullanıcı ID'si olacak
          .get();

      if (userDoc.exists) {
        // Kullanıcı verisini aldıktan sonra `currentUser`'ı oluşturuyoruz
        currentUser = MyUser.fromJson(userDoc.data()!);

        // Kullanıcının ürünlerini Firestore'dan alıyoruz
        if (currentUser.products != null && currentUser.products!.isNotEmpty) {
          _fetchProducts();
        } else {
          setState(() {
            isLoading = false; // Ürün yoksa, loading durumu false olacak
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false; // Hata durumunda loading durumu false olacak
      });
    }
  }

  // Kullanıcının ürünlerini Firestore'dan çekme
  Future<void> _fetchProducts() async {
    try {
      var productDocs = await FirebaseFirestore.instance
          .collection('products')
          .where('productID', whereIn: currentUser.products!)
          .get();

      setState(() {
        products = productDocs.docs.map((doc) {
          return Product.fromJson(doc.data());
        }).toList();
        isLoading =
            false; // Veri çekme tamamlandığında loading durumu false olacak
      });
    } catch (e) {
      print("Error fetching products: $e");
      setState(() {
        isLoading = false; // Hata durumunda loading durumu false olacak
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Veri yükleniyor mu kontrolü
              isLoading
                  ? const CircularProgressIndicator() // Yükleniyor göstergesi
                  : products.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                                child: ListTile(
                                  title: Text(product.name),
                                  subtitle: Text(
                                      product.description ?? 'No description'),
                                  trailing: Text(
                                      "\$${product.price.toStringAsFixed(2)} ${product.unit}"),
                                  leading: product.imageUrl != null
                                      ? Image.network(product.imageUrl!,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover)
                                      : const Icon(Icons.image, size: 50),
                                ),
                              );
                            },
                          ),
                        )
                      : Text(
                          "no_product".tr(),
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black54),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
