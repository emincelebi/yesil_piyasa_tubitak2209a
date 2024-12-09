import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yesil_piyasa/core/components/launch.dart';
import 'package:yesil_piyasa/model/my_user.dart';
import 'package:yesil_piyasa/model/product.dart';
import 'package:yesil_piyasa/viewmodel/user_model.dart';
import 'package:yesil_piyasa/views/home/drawer_views/report_view.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool isFavorite = false;
  bool isProcessing = false;
  late MyUser? ownerProduct;
  final launcher = MyLaunch();

  @override
  void initState() {
    super.initState();
    isFavorited();
    fetchUser();
  }

  fetchUser() async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    ownerProduct = await userModel.fetchUser(widget.product.userID);
  }

  Future<void> isFavorited() async {
    final userModel = Provider.of<UserModel>(context, listen: false);
    bool favorited = await userModel.isFavorited(
        widget.product.productID, userModel.user!.userID);
    setState(() {
      isFavorite = favorited;
    });
  }

  Future<void> toggleFavorite(String productId) async {
    if (isProcessing) return;

    setState(() {
      isProcessing = true;
    });

    final userModel = Provider.of<UserModel>(context, listen: false);

    try {
      if (isFavorite) {
        await userModel.removeProductFromFavorites(productId);
        setState(() {
          isFavorite = false;
        });
      } else {
        await userModel.addProductToFavorites(productId);
        setState(() {
          isFavorite = true;
        });
      }
    } catch (e) {
      print("Hata: $e");
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  String getCategoryNames(String category) {
    switch (category.toLowerCase()) {
      case '0':
        return 'fruit'.tr();
      case '1':
        return 'vegetable'.tr();
      case '2':
        return 'grain'.tr();
      default:
        return 'others'.tr();
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

  String formatDate(DateTime date) {
    // Aktif olan yerelleştirmeyi kullanarak tarih formatını döndür
    return DateFormat('d MMMM y', context.locale.toString()).format(date);
  }

  void _showContactBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık
              Row(
                children: [
                  const Icon(Icons.contact_page,
                      color: Colors.blueAccent, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    "contact_info".tr(),
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Kullanıcı Adı ve Soyadı
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.black54, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    "${ownerProduct?.name ?? 'Ad belirtilmemiş'} ${ownerProduct?.surName ?? ''}",
                    style: const TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Telefon Bilgisi
              if (ownerProduct?.phoneNumber != null)
                GestureDetector(
                  onTap: () => launcher
                      .launchPhoneNumber('tel:+90${ownerProduct!.phoneNumber}'),
                  child: Row(
                    children: [
                      const Icon(Icons.phone, color: Colors.green, size: 24),
                      const SizedBox(width: 10),
                      Text(
                        "+90 ${ownerProduct!.phoneNumber}",
                        style: const TextStyle(
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              // E-posta Bilgisi
              if (ownerProduct?.email != null)
                GestureDetector(
                  onTap: () => launcher.launchEmail(ownerProduct!.email),
                  child: Row(
                    children: [
                      const Icon(Icons.email, color: Colors.orange, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          ownerProduct!.email,
                          style: const TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              // Konum Bilgisi
              if (ownerProduct?.location != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, color: Colors.red, size: 24),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        ownerProduct!.location,
                        style: const TextStyle(
                            fontSize: 18, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment:
                  Alignment.topCenter, // Görüntüyü ekranın üst kısmına hizalar.
              child: SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.4, // Görüntü alanını ekran yüksekliğinin %40'ı ile sınırla.
                width: double.infinity,
                child: widget.product.imageUrl != null
                    ? Image.network(
                        widget.product.imageUrl!,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        getCategoryImage(widget.product.category),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          Positioned(
            top: 40, // Ekranın üstünden boşluk
            left: 16, // Sol taraftan boşluk
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white, // Arka plan rengi
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40, // Ekranın üstünden boşluk
            right: 16, // Sol taraftan boşluk
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ReportView(
                  phoneNumber: ownerProduct!.phoneNumber,
                ),
              )),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red, // Arka plan rengi
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.report,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ),
          ),
          Positioned(
            top: 300,
            bottom: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ürün Başlığı
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 12.0),
                      color: Colors.orange.shade50,
                      child: Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Fiyat ve Kategori Etiketli
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${"price".tr()}:",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${widget.product.price.toStringAsFixed(2)} ₺ / ${tr(widget.product.unit)}",
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${"category".tr()}:",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                getCategoryNames(widget.product.category),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Açıklama Etiketli
                    if (widget.product.description != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${"description".tr()}:",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.product.description!,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    // Stok Bilgisi Etiketli
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${"stock_info".tr()}:",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${"stock".tr()}: ${widget.product.stock}",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Tarih Bilgisi Etiketli
                    if (widget.product.createdAt != null ||
                        widget.product.updatedAt != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${"date_info".tr()}:",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.product.createdAt != null)
                            Text(
                              "${"add_date".tr()}: ${formatDate(widget.product.createdAt!)}",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black45),
                            ),
                          if (widget.product.updatedAt != null)
                            Text(
                              "${"last_update".tr()}: ${formatDate(widget.product.updatedAt!)}",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black45),
                            ),
                        ],
                      ),
                    const SizedBox(height: 40),
                    // İletişim ve Favori
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _showContactBottomSheet(context),
                          icon: const Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          label: Text("contact".tr()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                        ),
                        IconButton(
                          onPressed: isProcessing
                              ? null
                              : () {
                                  toggleFavorite(widget.product.productID);
                                },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
