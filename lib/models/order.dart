class OrderItem {
  final String productId;
  final int quantity;
  final double price;
  final String imageUrl;
  final String name;  // Đổi từ productName thành name

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.name,  // Sử dụng name thay vì productName
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId']?.toString() ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      name: json['name'] ?? '',  // Đảm bảo lấy tên sản phẩm từ JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
      'name': name,  // Bao gồm name trong JSON
    };
  }
}



class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final String? discountCode;
  final double discountValue;
  final String? address;
  final String status;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    this.discountCode,
    this.discountValue = 0.0,
    this.address,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      discountCode: json['discountCode'] as String?,
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0.0,
      address: json['address'] as String?,
      status: json['status']?.toString() ?? 'chưa giải quyết',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'discountCode': discountCode,
      'discountValue': discountValue,
      'address': address,
      'status': status,
    };
  }
}
