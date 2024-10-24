import 'dart:convert';
import 'product.dart';

class CartItem {
  final String id; // ID của CartItem
  final String userId; // ID của người dùng
  final String productId; // ID của sản phẩm
  final Product product; // Tham chiếu đến sản phẩm
  final int quantity; // Số lượng sản phẩm trong giỏ hàng

  CartItem({
    required this.id,
    required this.userId,
    required this.productId, // Thêm productId
    required this.product,
    required this.quantity,
  });

  // Chuyển đổi CartItem thành Map để gửi đi
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'productId': productId, // Sử dụng productId
      'quantity': quantity,
    };
  }

  // Tạo đối tượng CartItem từ JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'] ?? '', // Cung cấp giá trị mặc định nếu không có _id
      userId: json['userId'] ?? '',
      productId: json['productId']['_id'] ?? '', // Lấy ID sản phẩm từ productId
      product: Product.fromJson(
          json['productId']), // Lấy thông tin sản phẩm từ trường productId
      quantity: json['quantity'] ?? 0,
    );
  }

  // Chuyển đổi CartItem thành JSON để gửi đi
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'CartItem(id: $id, userId: $userId, product: $product, quantity: $quantity)';
  }
}
