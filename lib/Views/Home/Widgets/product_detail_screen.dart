import 'package:app_supermarket/Views/Cart/Screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_supermarket/models/product.dart';
import 'package:app_supermarket/models/cart.dart'; // Import CartItem model
import 'package:app_supermarket/Views/Cart/Services/cart_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name ?? 'Product Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh sản phẩm
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _getValidImageUrl(product.imageUrl),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 400,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, size: 200);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.name ?? 'Unnamed Product',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                  'Mô tả: ${product.description ?? 'No description available'}'),
              const SizedBox(height: 8),
              Text(
                'Giá: ${product.price?.toStringAsFixed(2) ?? 'N/A'} VND',
                style: const TextStyle(color: Colors.red, fontSize: 20),
              ),
              const SizedBox(height: 8),

              // Nút thêm vào giỏ hàng
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0091E5),
                    minimumSize: const Size(400, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  _addToCart(context);
                },
                child: const Text(
                  'Thêm vào giỏ hàng',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Jaldi',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm kiểm tra và trả về URL hợp lệ cho hình ảnh
  String _getValidImageUrl(String imageUrl) {
    Uri? uri = Uri.tryParse(imageUrl);
    if (uri == null || !uri.isAbsolute || uri.scheme == 'file') {
      return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2HylmCer78tjnaO7GNoe1aXKdIB06HccobQ&s';
    }
    return imageUrl;
  }

  void _addToCart(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? token = prefs.getString('token');

    if (userId == null || token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Bạn cần đăng nhập trước khi thêm sản phẩm vào giỏ hàng'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Tạo một instance của CartService
    CartService cartService = CartService();

    // Gọi phương thức thêm sản phẩm vào giỏ hàng
    try {
      // Gọi phương thức addProductToCart với CartItem model
      await cartService.addProductToCart(
          product.id, 1); // 1 là số lượng sản phẩm thêm vào giỏ hàng
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã thêm sản phẩm vào giỏ hàng'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
