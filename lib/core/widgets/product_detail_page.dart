import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name'] ?? "Ürün Detayı"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product['imageUrl'] != null
                ? Image.network(product['imageUrl'])
                : const Placeholder(fallbackHeight: 200),
            const SizedBox(height: 16),
            Text(
              product['name'] ?? "Ürün Adı",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "${product['price']} ₺ / ${product['unit']}",
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              product['description'] ?? "Açıklama mevcut değil.",
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Sipariş verme işlemi
              },
              child: const Text("Satın Al"),
            ),
          ],
        ),
      ),
    );
  }
}
