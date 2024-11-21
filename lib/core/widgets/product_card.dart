import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:yesil_piyasa/core/widgets/product_detail_page.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: product['imageUrl'] != null
            ? Image.network(
                product['imageUrl'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.image, size: 60),
        title: Text(product['name'] ?? "Ürün Adı"),
        subtitle: Text(
          "${product['price']} ₺ / ${tr(product['unit'])}",
          style: const TextStyle(color: Colors.green),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            // Favorilere ekleme işlemi
          },
        ),
        onTap: () {
          // Detay sayfasına gitme
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: product),
            ),
          );
        },
      ),
    );
  }
}
