import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/model/product.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';

class AddProductsView extends StatefulWidget {
  const AddProductsView({super.key});

  @override
  State<AddProductsView> createState() => _AddProductsViewState();
}

class _AddProductsViewState extends State<AddProductsView> {
  bool _isFormVisible = false;
  String _selectedCategory = '';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  String _selectedUnit = 'kg'; // Default unit

  bool _isLoading = false;

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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child:
            _isFormVisible ? _buildForm(userModel) : _buildCategorySelector(),
      ),
    );
  }

  // Category Selector
  Widget _buildCategorySelector() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'new_add_product'.tr(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildCategoryCard(
                  'fruit'.tr(), FontAwesomeIcons.appleWhole, Colors.red),
              _buildCategoryCard(
                  'vegetable'.tr(), FontAwesomeIcons.carrot, Colors.green),
              _buildCategoryCard(
                  'grain'.tr(), FontAwesomeIcons.wheatAwn, Colors.brown),
              _buildCategoryCard('others'.tr(), Icons.more_horiz, Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  // Category Cards
  Widget _buildCategoryCard(String category, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
          _isFormVisible = true;
        });
      },
      child: Container(
        width: 120,
        height: 150,
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              category,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Product Form
  Widget _buildForm(UserModel userModel) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.withOpacity(0.2), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$_selectedCategory ${'product'.tr()}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _isFormVisible = false;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'product_name'.tr(),
                    controller: _productNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_product_name'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    label: 'description'.tr(),
                    controller: _descriptionController,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please_enter_description'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    label: 'price'.tr(),
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final price = double.tryParse(value ?? '');
                      if (price == null || price <= 0) {
                        return 'please_enter_valid_price'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    label: 'stock'.tr(),
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final stock = int.tryParse(value ?? '');
                      if (stock == null || stock <= 0) {
                        return 'please_enter_valid_stock'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildUnitSelector(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              // Gather form data
                              String productName =
                                  _productNameController.text.trim();
                              String description =
                                  _descriptionController.text.trim();
                              final price =
                                  double.tryParse(_priceController.text) ?? 0.0;
                              final stock =
                                  int.tryParse(_stockController.text) ?? 0;

                              try {
                                final newProduct = Product(
                                  productID: '',
                                  userID: userModel.user!.userID,
                                  name: productName,
                                  description: description,
                                  price: price,
                                  unit: _selectedUnit,
                                  stock: stock,
                                  category: _selectedCategory,
                                );

                                await userModel.addProduct(newProduct);
                                _clearForm();

                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              } catch (e) {
                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'add_product'.tr(),
                            style: const TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TextField builder
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    int? maxLines,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  // Unit Selector
  Widget _buildUnitSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedUnit,
      onChanged: (value) {
        setState(() {
          _selectedUnit = value!;
        });
      },
      items: const [
        DropdownMenuItem(value: 'kg', child: Text('kg')),
        DropdownMenuItem(value: 'piece', child: Text('piece')),
        DropdownMenuItem(value: 'liter', child: Text('liter')),
      ],
      decoration: InputDecoration(
        labelText: 'unit'.tr(),
        border: const OutlineInputBorder(),
      ),
    );
  }

  // Clear form fields
  void _clearForm() {
    _productNameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _stockController.clear();
  }
}
