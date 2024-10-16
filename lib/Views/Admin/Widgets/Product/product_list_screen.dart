import 'package:app_supermarket/Views/Admin/Servives/product_service.dart';
import 'package:app_supermarket/Views/Admin/Widgets/Product/add_product_screen.dart';
import 'package:app_supermarket/Views/Admin/Widgets/Product/edit_product_screen.dart';
import 'package:app_supermarket/Views/Admin/Widgets/Product/product_detail_list_screen.dart';
import 'package:app_supermarket/Views/Home/Screens/home.dart';
import 'package:app_supermarket/Views/homepage.dart';
import 'package:app_supermarket/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = []; // Sử dụng List<Product> thay vì dynamic
  final ProductService productService = ProductService();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // Hàm fetch dữ liệu sản phẩm từ ProductService
  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await productService
          .getProducts(); // Giả sử getProducts trả về danh sách Product
      setState(() {
        products = fetchedProducts; // Cập nhật danh sách sản phẩm vào state
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  // Hàm xóa sản phẩm
  // Hàm xóa sản phẩm
  Future<void> deleteProduct(String productId) async {
    try {
      await productService.deleteProduct(productId);
      setState(() {
        products.removeWhere((product) => product.id == productId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sản phẩm đã được xóa thành công')),
      );
    } catch (e) {
      print('Error deleting product: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể xóa sản phẩm')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product List'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Homepage()),
                (route) => false,
              );
            },
          ),
        ),
        body: products.isEmpty
            ? const Center(child: Text('Không có sản phẩm nào.'))
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProductScreen(product: product),
                              ),
                            );
                          },
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          icon: Icons.edit,
                          label: 'Sửa',
                        ),
                        SlidableAction(
                          onPressed: (context) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Xác nhận xóa'),
                                content: const Text(
                                    'Bạn có chắc chắn muốn xóa sản phẩm này?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Đóng hộp thoại
                                    },
                                    child: const Text('Hủy'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Đóng hộp thoại
                                      deleteProduct(product.id);
                                    },
                                    child: const Text('Xóa'),
                                  ),
                                ],
                              ),
                            );
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Xóa',
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl.isNotEmpty &&
                                    Uri.tryParse(product.imageUrl)
                                            ?.isAbsolute ==
                                        true
                                ? product.imageUrl
                                : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2HylmCer78tjnaO7GNoe1aXKdIB06HccobQ&s',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons
                                  .error); // Hiển thị icon lỗi nếu hình ảnh không tải được
                            },
                          ),
                        ),
                      ),
                      title: Text(product
                          .name), // Đúng cú pháp truy cập thuộc tính của Product
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product
                                .description, // Truy cập thuộc tính đúng của Product
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                              '\$${product.price.toStringAsFixed(2)}'), // Truy cập thuộc tính đúng của Product
                          Text(
                              'Category ID: ${product.categoryId}'), // Truy cập thuộc tính đúng của Product
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailListScreen(product: product),
                          ),
                        );
                      },
                    ),
                  );
                }));
  }
}
