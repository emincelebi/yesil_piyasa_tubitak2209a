import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/model/product.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';

class EditProductView extends StatefulWidget {
  final Product product;

  const EditProductView({super.key, required this.product});

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late String _selectedUnit;
  late String _selectedCategory;

  final List<String> _categoryOptions = [
    'fruit',
    'vegetable',
    'grain',
    'others'
  ];
  final List<String> _unitOptions = ['kg', 'piece', 'liter'];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.product.name);
    _descriptionController =
        TextEditingController(text: widget.product.description);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _stockController =
        TextEditingController(text: widget.product.stock.toString());

    _selectedUnit = _unitOptions.contains(widget.product.unit)
        ? widget.product.unit
        : _unitOptions.first;
    _selectedCategory = _categoryOptions.contains(widget.product.category)
        ? widget.product.category
        : _categoryOptions.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar:
          true, // İçeriğin AppBar'ın arkasına kadar uzanmasını sağlar.
      appBar: AppBar(
        title: Text(
          'edit_product'.tr(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true, // Başlığı merkeze hizalar.
        backgroundColor: Colors.transparent, // Şeffaf arka plan.
        elevation: 0, // Gölgeyi kaldırır.
        iconTheme: const IconThemeData(
            color: Colors.white), // Geri butonunun rengini beyaz yapar.
      ),
      body: Stack(
        children: [
          // Degrade arka plan
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.green, Colors.orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Arka plan efektleri (daireler)
          Positioned(
            top: -50,
            left: -50,
            child: _buildBackgroundCircle(Colors.blue.shade300),
          ),
          Positioned(
            bottom: -70,
            right: -70,
            child: _buildBackgroundCircle(Colors.orange.shade300),
          ),
          Positioned(
            top: 150,
            right: -30,
            child: _buildBackgroundCircle(Colors.green.shade300, size: 150),
          ),
          // Form içerikleri
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                      height:
                          100), // AppBar'ın şeffaf olması sebebiyle boşluk bırakılır.
                  _buildTextField(
                    label: 'product_name'.tr(),
                    controller: _nameController,
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
                  _buildDropdown(
                    label: 'category'.tr(),
                    value: _selectedCategory,
                    items: _categoryOptions,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    label: 'unit'.tr(),
                    value: _selectedUnit,
                    items: _unitOptions,
                    onChanged: (value) {
                      setState(() {
                        _selectedUnit = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                final updatedProduct = widget.product.copyWith(
                                  name: _nameController.text.trim(),
                                  description:
                                      _descriptionController.text.trim(),
                                  price: double.parse(_priceController.text),
                                  stock: int.parse(_stockController.text),
                                  unit: _selectedUnit,
                                  category: _selectedCategory,
                                );

                                await userModel.updateProduct(updatedProduct);

                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  Navigator.of(context).pop();
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
                      backgroundColor: Colors.orange.shade600,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 14),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'save_changes'.tr(),
                            style: const TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: items.contains(value) ? value : items.first,
      onChanged: onChanged,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item.tr()),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
      ),
    );
  }

  Widget _buildBackgroundCircle(Color color, {double size = 200}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.5),
        shape: BoxShape.circle,
      ),
    );
  }
}
