import 'package:app_supermarket/Views/Admin/Servives/product_service.dart';
import 'package:app_supermarket/Views/Home/Widgets/product_detail_screen.dart';
import 'package:app_supermarket/models/product.dart';
import 'package:flutter/material.dart';

class ProductbycategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const ProductbycategoryScreen(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  State<ProductbycategoryScreen> createState() =>
      _ProductbycategoryScreenState();
}

class _ProductbycategoryScreenState extends State<ProductbycategoryScreen> {
  List<Product> productList = [];
  bool isLoading = true;
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProductsByCategory(widget.categoryId);
  }

  Future<void> fetchProductsByCategory(String categoryId) async {
    try {
      final productService = ProductService();
      List<Product> allProducts =
          await productService.getProducts(); // Lấy tất cả sản phẩm

      // Lọc các sản phẩm theo categoryId
      productList = allProducts
          .where((product) => product.categoryId == categoryId)
          .toList();

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Error fetching products for category: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sản phẩm: ${widget.categoryName}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : productList.isNotEmpty
              ? ListView.builder(
                  shrinkWrap:
                      true, // Thêm shrinkWrap để danh sách có thể cuộn bên trong SingleChildScrollView
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    final product = productList[index];
                    return ListTile(
                      leading: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8), // Bo góc
                          border: Border.all(
                            color: Colors.black26, // Màu viền đen
                            width: 2, // Độ dày của viền
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(8), // Bo góc cho hình ảnh
                          child: Image.network(
                            product.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 50);
                            },
                          ),
                        ),
                      ),
                      title: Text(
                        product.name,
                        style:
                            const TextStyle(fontFamily: 'Jaldi', fontSize: 20),
                      ),
                      subtitle: Text('Giá: ${product.price} \VND'),
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        child: const Text('Xem Thông Tin'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue, // Text color
                        ),
                      ),
                    );
                  },
                )
              : const Center(child: Text('Không có sản phẩm nào')),
    );
  }
}
