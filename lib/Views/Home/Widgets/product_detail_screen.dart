import 'package:flutter/material.dart';
import 'package:app_supermarket/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name ??
            'Product Details'), // Kiểm tra nếu tên sản phẩm null
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Chức năng thêm vào giỏ hàng
              _addToCart(context);
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
                borderRadius: BorderRadius.circular(8), // Bo góc cho hình ảnh
                child: Image.network(
                  _getValidImageUrl(
                      product.imageUrl), // Sử dụng hàm kiểm tra URL hợp lệ
                  fit: BoxFit.cover,
                  width: double
                      .infinity, // Đảm bảo ảnh chiếm hết chiều rộng màn hình
                  height: 400, // Đặt chiều cao phù hợp cho hình ảnh
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error,
                        size: 200); // Hiển thị icon lỗi nếu không tải được ảnh
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product.name ??
                    'Unnamed Product', // Kiểm tra nếu tên sản phẩm null
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                  'Description: ${product.description ?? 'No description available'}'),
              const SizedBox(height: 8),
              Text('Price: ${product.price?.toStringAsFixed(2) ?? 'N/A'} \Vnd'),
              const SizedBox(height: 8),
              Text('Quantity: ${product.quantity ?? 'N/A'} còn hàng'),
              const SizedBox(height: 8),
              Text('Category ID: ${product.categoryId ?? 'N/A'}'),
              const SizedBox(height: 16),
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
                  'Add to Cart',
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
    // Kiểm tra URL hợp lệ, và không phải file cục bộ
    if (uri == null || !uri.isAbsolute || uri.scheme == 'file') {
      // Nếu URL không hợp lệ hoặc là file cục bộ, sử dụng URL mặc định
      return 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2HylmCer78tjnaO7GNoe1aXKdIB06HccobQ&s';
    }
    return imageUrl; // Nếu URL hợp lệ, trả về chính nó
  }

  void _addToCart(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã thêm sản phẩm vào giỏ hàng'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
