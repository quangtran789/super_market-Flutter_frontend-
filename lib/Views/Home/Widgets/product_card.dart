import 'package:app_supermarket/Views/Home/Widgets/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_supermarket/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: product.imageUrl.isNotEmpty
            ? Image.network(product.imageUrl,
                width: 75, height: 75, fit: BoxFit.cover)
            : Icon(Icons.image, size: 50), // Placeholder nếu không có ảnh
        title:
            Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.description,
                maxLines: 2, overflow: TextOverflow.ellipsis),
            SizedBox(height: 8),
            Text(
              '${product.price.toStringAsFixed(2)} \VND', // Hiển thị giá
              style:
                  TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        onTap: () {
          // Bạn có thể thêm hành động khi nhấn vào sản phẩm, ví dụ: mở trang chi tiết sản phẩm
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product)));
        },
      ),
    );
  }
}
