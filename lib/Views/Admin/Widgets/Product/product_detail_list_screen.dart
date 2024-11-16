import 'package:app_supermarket/models/product.dart';
import 'package:flutter/material.dart';
import 'dart:io'; // Import để xử lý file
import 'package:app_supermarket/utils/app_localizations.dart';

class ProductDetailListScreen extends StatelessWidget {
  final Product product;

  const ProductDetailListScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8), // Bo góc cho hình ảnh
                child: _getImageWidget(product.imageUrl),
              ),
              const SizedBox(height: 16),
              Text(
                product.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context)!.get('description')}: ${product.description}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context)!.get('price')}: ${product.price.toStringAsFixed(2)} \VND',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context)!.get('quantity')}: ${product.quantity}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                '${AppLocalizations.of(context)!.get('category')}: ${product.categoryId}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm trả về widget phù hợp với URL của hình ảnh
  Widget _getImageWidget(String imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      // Nếu imageUrl rỗng hoặc null, sử dụng hình ảnh mặc định
      return const Icon(Icons.error, size: 200);
    }

    Uri? uri = Uri.tryParse(imageUrl);

    if (uri == null || !uri.isAbsolute) {
      // Nếu URL không hợp lệ hoặc không có host, hiển thị hình ảnh mặc định
      return const Icon(Icons.error, size: 200);
    }

    if (uri.scheme == 'http' || uri.scheme == 'https') {
      // Nếu URL là một URL web hợp lệ
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 400,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error, size: 200);
        },
      );
    } else if (uri.scheme == 'file') {
      // Nếu URL là đường dẫn file (file://)
      File file = File(uri.path);
      if (file.existsSync()) {
        // Nếu file tồn tại, sử dụng Image.file để tải ảnh từ file cục bộ
        return Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 400,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, size: 200);
          },
        );
      } else {
        // Nếu file không tồn tại, hiển thị icon lỗi
        return const Icon(Icons.error, size: 200);
      }
    } else if (uri.scheme == 'asset') {
      // Nếu URL là asset cục bộ
      return Image.asset(
        imageUrl, // Đường dẫn asset từ thư mục assets
        fit: BoxFit.cover,
        width: double.infinity,
        height: 400,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error, size: 200);
        },
      );
    } else {
      // Nếu không phải các URL hợp lệ khác, hiển thị hình ảnh mặc định
      return Image.network(
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT2HylmCer78tjnaO7GNoe1aXKdIB06HccobQ&s',
        fit: BoxFit.cover,
        width: double.infinity,
        height: 400,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error, size: 200);
        },
      );
    }
  }
}
