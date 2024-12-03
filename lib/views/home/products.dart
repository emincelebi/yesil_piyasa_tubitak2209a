import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/core/widgets/product_detail_page.dart';
import 'package:yesil_piyasa/model/product.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  List<String> favoriteProductIds = [];
  bool isLoadingFavorites = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    final favorites = await userModel.fetchUserFavorites();
    setState(() {
      favoriteProductIds =
          List.from(favorites); // Favori ürünleri liste olarak alıyoruz
      isLoadingFavorites = false;
    });
  }

  Future<void> toggleFavorite(String productId) async {
    final userModel = Provider.of<UserModel>(context, listen: false);

    if (favoriteProductIds.contains(productId)) {
      await userModel.removeProductFromFavorites(productId);
      await userModel.removeLikeFromProduct(productId);

      setState(() {
        favoriteProductIds.remove(productId); // Favorilerden çıkar
      });
    } else {
      await userModel.addProductToFavorites(productId);
      await userModel.addLikeToProduct(productId);
      setState(() {
        favoriteProductIds.add(productId); // Favoriye ekle, listenin sonuna
      });
    }
  }

  String getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case '0':
        return 'assets/images/meyve.jpg'; // Meyve için resim
      case '1':
        return 'assets/images/sebze.jpg'; // Sebze için resim
      case '2':
        return 'assets/images/tahil.jpg'; // Tahıl için resim
      default:
        return 'assets/images/diger.jpg'; // Diğer kategoriler için resim
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isLoadingFavorites
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            FontAwesomeIcons.shop,
                            size: 40,
                            color: Colors.white,
                          ),
                          Text(
                            "${"no_product".tr()}...",
                            style: const TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final products = snapshot.data!.docs;

                  return GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Her satırda 2 ürün
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3 / 4, // Kart oranı
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final productData = products[index].data();
                      final productId = products[index].id;

                      final isFavorite = favoriteProductIds.contains(productId);

                      // Ürün kategorisini alıyoruz
                      final category = productData['category'] ?? 'other';

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            // Arka plan bulanıklaştırma
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Firestore'dan gelen verileri Product modeline dönüştür
                                final product = Product(
                                  productID: productId,
                                  name: productData['name'] ?? "Ürün Adı",
                                  userID:
                                      productData['userID'] ?? "unknown_user",
                                  price: double.tryParse(
                                          productData['price'].toString()) ??
                                      0.0,
                                  unit: productData['unit'] ?? "adet",
                                  stock: int.tryParse(
                                          productData['stock'].toString()) ??
                                      0,
                                  category: productData['category'] ?? "other",
                                  description: productData['description'] ??
                                      "Açıklama mevcut değil.",
                                  imageUrl: productData['imageUrl'],
                                  createdAt:
                                      (productData['createdAt'] as Timestamp?)
                                          ?.toDate(),
                                  updatedAt:
                                      (productData['updatedAt'] as Timestamp?)
                                          ?.toDate(),
                                );

                                // ProductDetailPage'e yönlendir ve Product nesnesini aktar
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailPage(product: product)),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(12)),
                                      child: productData['imageUrl'] != null
                                          ? Image.network(
                                              productData['imageUrl'],
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              getCategoryImage(category),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          productData['name'] ?? "Ürün Adı",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "${productData['price']} ₺ / ${tr(productData['unit'])}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: IconButton(
                                            icon: Icon(
                                              isFavorite
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: isFavorite
                                                  ? Colors.red
                                                  : null,
                                            ),
                                            onPressed: () =>
                                                toggleFavorite(productId),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
