import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/model/product.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';

class MyProductsView extends StatefulWidget {
  const MyProductsView({super.key});

  @override
  State<MyProductsView> createState() => _MyProductsViewState();
}

class _MyProductsViewState extends State<MyProductsView> {
  late String userID;

  @override
  void initState() {
    super.initState();
    currentUser();
  }

  currentUser() {
    final userModel = Provider.of<UserModel>(context, listen: false);
    userID = userModel.user!.userID;
  }

  // Ürünü Firestore'dan silme ve kullanıcının ürün listesinde güncelleme işlemi
  Future<void> deleteProduct(Product product) async {
    try {
      // 1. Firestore'dan ürünü sil
      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.productID)
          .delete();

      // 2. Kullanıcının ürünler listesinde ürünü sil
      await FirebaseFirestore.instance.collection('users').doc(userID).update({
        'products': FieldValue.arrayRemove([product.productID]),
      });

      // Başarılı işlem sonrası bir mesaj gösterebiliriz
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('product_deleted_succesfully'.tr())),
      );
    } catch (e) {
      // Hata durumunda bir mesaj göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting product: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue,
              Colors.white,
            ],
          ),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance.collection('users').doc(userID).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.hasError) {
              return const Center(child: Text('Error loading user data.'));
            }

            return Column(
              children: [
                // Kullanıcının Satışa Sundugu Ürünleri Göster
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where('userID', isEqualTo: userID)
                        .snapshots(),
                    builder: (context, productSnapshot) {
                      if (productSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!productSnapshot.hasData ||
                          productSnapshot.hasError) {
                        return Center(
                            child: Text('error_loading_products'.tr()));
                      }

                      final products = productSnapshot.data!.docs.map((doc) {
                        return Product.fromJson(
                            doc.data() as Map<String, dynamic>);
                      }).toList();

                      return ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              title: Text(product.name,
                                  style: const TextStyle(fontSize: 18)),
                              subtitle: Text(
                                  '${tr('price')}: ${product.price} ${product.unit}'),
                              leading: product.imageUrl != null
                                  ? Image.network(product.imageUrl!,
                                      width: 50, height: 50, fit: BoxFit.cover)
                                  : const Icon(Icons.image, size: 50),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Silme işlemi
                                  deleteProduct(product);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
