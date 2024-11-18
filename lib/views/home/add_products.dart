import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/model/product.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';

class AddProductsView extends StatefulWidget {
  const AddProductsView({super.key});

  @override
  _AddProductsViewState createState() => _AddProductsViewState();
}

class _AddProductsViewState extends State<AddProductsView> {
  String selectedUnit = 'kg'; // Varsayılan birim
  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserModel(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.white], // Turuncu'dan beyaza
              begin: Alignment.topCenter, // Başlangıç noktası
              end: Alignment.bottomCenter, // Bitiş noktası
            ),
          ),
          child: Consumer<UserModel>(
            builder: (context, viewModel, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  // Ekranın kaymasını engellemek için
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // Başlık ve inputları sola hizalama
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Add New Product',
                        style: TextStyle(
                          fontSize: 32, // Başlık boyutu
                          fontWeight: FontWeight.bold, // Kalın yazı
                          color: Colors.white, // Başlık rengi beyaz yapıldı
                          shadows: [
                            Shadow(
                              offset: const Offset(2, 2),
                              blurRadius: 8,
                              color: Colors.black
                                  .withOpacity(0.7), // Gölgelendirme efekti
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // TextField widgetları
                      _buildTextField(
                        label: "Product Name",
                        onChanged: (value) {
                          // update product name
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        label: "Description",
                        maxLines: 5, // Açıklama alanı daha büyük yapıldı
                        onChanged: (value) {
                          // update product description
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        label: "Price",
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          // update product price
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        label: "Stock",
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          // update stock quantity
                        },
                      ),
                      const SizedBox(height: 10),
                      // Quantity and Unit input section
                      _buildQuantityAndUnitSelector(),
                      const SizedBox(height: 30),
                      // Add Product Button
                      ElevatedButton(
                        onPressed: () async {
                          // Create new Product instance and pass to ViewModel for adding
                          final newProduct = Product(
                            productID: "product123",
                            name: "Sample Product",
                            description: "Sample description",
                            price: 100.0,
                            unit: selectedUnit,
                            stock: int.tryParse(quantityController.text) ??
                                0, // Quantity is stored
                          );
                          await viewModel.addProduct(newProduct);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.orange, // Buton rengi beyaz
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Add Product"),
                      ),
                      if (viewModel.state == ViewState.Busy)
                        const SizedBox(height: 20),
                      if (viewModel.state == ViewState.Busy)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return TextField(
      keyboardType: keyboardType ?? TextInputType.text,
      maxLines: maxLines ?? 1, // Açıklama alanı için satır sayısı ayarlanabilir
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white), // Etiket rengi beyaz
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: Colors.white), // Kenarlık beyaz yapıldı
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
              color: Colors.white, width: 2), // Focus kenarlığı beyaz yapıldı
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildQuantityAndUnitSelector() {
    return Row(
      children: [
        // Quantity (Amount) input field
        Expanded(
          flex: 2,
          child: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantity',
              labelStyle: const TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        // Unit Selector Dropdown
        Expanded(
          flex: 1,
          child: DropdownButtonFormField<String>(
            value: selectedUnit,
            onChanged: (String? newValue) {
              setState(() {
                selectedUnit = newValue!;
              });
            },
            items: <String>['kg', 'pcs', 'liters', 'm²', 'g']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Unit',
              labelStyle: const TextStyle(color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
