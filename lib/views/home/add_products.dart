import 'package:easy_localization/easy_localization.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  String _selectedUnit = 'kg'; // Varsayılan birim
  bool _isLoading = false; // Yükleme durumunu kontrol eder

  @override
  void dispose() {
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.white], // Turuncu'dan beyaza
            begin: Alignment.topCenter, // Başlangıç noktası
            end: Alignment.bottomCenter, // Bitiş noktası
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey, // Form anahtarı
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'new_add_product'.tr(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: const Offset(2, 2),
                            blurRadius: 8,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Product Name
                    _buildTextField(
                      label: "product_name".tr(),
                      controller: _productNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please_enter_product_name'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Description
                    _buildTextField(
                      label: "description".tr(),
                      controller: _descriptionController,
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please_enter_description'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Price
                    _buildTextField(
                      label: "price".tr(),
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please_enter_price'.tr();
                        }
                        final price = double.tryParse(value);
                        if (price == null || price <= 0) {
                          return 'please_enter_valid_price'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Stock
                    _buildTextField(
                      label: "stock".tr(),
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please_enter_stock'.tr();
                        }
                        final stock = int.tryParse(value);
                        if (stock == null || stock <= 0) {
                          return 'please_enter_valid_stock'.tr();
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    // Unit Selector
                    _buildUnitSelector(),
                    const SizedBox(height: 30),
                    // Add Product Button
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                // Formdan değerleri al
                                String productName =
                                    _productNameController.text.trim();
                                String description =
                                    _descriptionController.text.trim();
                                final price =
                                    double.tryParse(_priceController.text) ??
                                        0.0;
                                final stock =
                                    int.tryParse(_stockController.text) ?? 0;

                                try {
                                  final newProduct = Product(
                                    productID:
                                        '', // Firestore tarafından atanacak
                                    userID: userModel
                                        .user!.userID, // Mevcut kullanıcı ID'si
                                    name: productName,
                                    description: description,
                                    price: price,
                                    unit: _selectedUnit,
                                    stock: stock,
                                  );

                                  await userModel.addProduct(newProduct);

                                  // Success message or UI update
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }

                                  _clearForm();
                                } catch (e) {
                                  // Handle error message
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                } finally {
                                  // Finally block to ensure that loading is stopped
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 14),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orange,
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text("add_product".tr()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int? maxLines,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: label,
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
      validator: validator,
    );
  }

  Widget _buildUnitSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedUnit,
      onChanged: (String? newValue) {
        setState(() {
          _selectedUnit = newValue!;
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
        labelText: 'unit'.tr(),
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
    );
  }

  void _clearForm() {
    _productNameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _stockController.clear();
    _selectedUnit = 'kg';
  }
}
