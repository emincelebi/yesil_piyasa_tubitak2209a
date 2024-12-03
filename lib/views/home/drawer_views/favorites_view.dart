import 'dart:ui'; // For BackdropFilter

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/core/widgets/product_detail_page.dart';
import 'package:yesil_piyasa/model/product.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
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
      favoriteProductIds = List.from(favorites);
      isLoadingFavorites = false;
    });
  }

  Future<void> toggleFavorite(String productId) async {
    final userModel = Provider.of<UserModel>(context, listen: false);

    if (favoriteProductIds.contains(productId)) {
      await userModel.removeProductFromFavorites(productId);
      await userModel.removeLikeFromProduct(productId);

      setState(() {
        favoriteProductIds.remove(productId);
      });
    } else {
      await userModel.addProductToFavorites(productId);
      await userModel.addLikeToProduct(productId);
      setState(() {
        favoriteProductIds.add(productId);
      });
    }
  }

  String getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case '0':
        return 'assets/images/meyve.jpg';
      case '1':
        return 'assets/images/sebze.jpg';
      case '2':
        return 'assets/images/tahil.jpg';
      default:
        return 'assets/images/diger.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Favorilerim',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Arka plan rengi
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // İçerik
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 50),
            child: isLoadingFavorites
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('products')
                        .where('productID', whereIn: favoriteProductIds)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                FontAwesomeIcons.heart,
                                size: 70,
                                color: Colors.purpleAccent,
                              ),
                              Text(
                                'Henüz Favori Ürün Yok.',
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final products = snapshot.data!.docs;

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final productData = products[index].data();
                          final productId = products[index].id;
                          final isFavorite =
                              favoriteProductIds.contains(productId);
                          final category = productData['category'] ?? 'other';

                          return GestureDetector(
                            onTap: () {
                              // Firestore'dan gelen productData ile bir Product nesnesi oluştur
                              final product = Product(
                                productID: productId,
                                name: productData['name'] ?? "Ürün Adı",
                                userID: productData['userID'] ?? "unknown_user",
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

                              // ProductDetailPage'e yönlendirme ve Product nesnesini iletme
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailPage(product: product),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10,
                                  sigmaY: 10,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(16)),
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
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              productData['name'] ?? 'Ürün Adı',
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
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
