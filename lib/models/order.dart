class OrderItem {
  final String productId;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}


class Order {
  final String id; // ID của đơn hàng
  final String userId; // ID của người dùng
  final List<OrderItem> items; // Danh sách các mặt hàng trong đơn hàng
  final double totalAmount; // Tổng số tiền
  final String? discountCode; // Mã giảm giá (nếu có)
  final double discountValue; // Giá trị giảm giá (nếu có)

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    this.discountCode,
    this.discountValue = 0.0,
  });

  // Phương thức tạo Order từ JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      totalAmount: json['totalAmount'].toDouble(),
      discountCode: json['discountCode'],
      discountValue: (json['discountValue'] is int)
          ? (json['discountValue'] as int).toDouble()
          : json['discountValue'],
    );
  }

  // Phương thức chuyển Order thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'discountCode': discountCode,
      'discountValue': discountValue,
    };
  }
}

