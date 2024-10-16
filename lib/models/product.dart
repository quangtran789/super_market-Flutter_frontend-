import 'dart:convert';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String categoryId;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.categoryId,
    required this.imageUrl,
  });

  // Chuyển đổi Product thành Map để gửi đi
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'categoryId': categoryId, // Đảm bảo truyền categoryId đúng
      'imageUrl': imageUrl,
    };
  }

  // Tạo đối tượng Product từ JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '', // Cung cấp giá trị mặc định nếu không có _id
      name: json['name'] ?? '', // Cung cấp giá trị mặc định nếu không có name
      description: json['description'] ??
          '', // Cung cấp giá trị mặc định nếu không có description
      price: (json['price'] != null)
          ? json['price'].toDouble()
          : 0.0, // Đảm bảo giá trị price luôn là double
      quantity: json['quantity'] ??
          0, // Cung cấp giá trị mặc định nếu không có quantity
      categoryId: json['categoryId'] ?? '', // Đảm bảo categoryId không null
      imageUrl: json['imageUrl'] ??
          '', // Cung cấp giá trị mặc định nếu không có imageUrl
    );
  }

  // Chuyển đổi Product thành JSON để gửi đi
  String toJson() => json.encode(toMap());
}
