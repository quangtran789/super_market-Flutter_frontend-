import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_supermarket/models/cart.dart';
import 'package:app_supermarket/models/product.dart';

class OrderService {
  final String baseUrl = 'http://192.168.1.20:5000';

  // Hàm tạo đơn hàng từ giỏ hàng
  Future<void> createOrder(String userId, List<CartItem> cartItems) async {
    try {
      List<Map<String, dynamic>> products = cartItems.map((item) {
        return {
          'productId': item.productId,
          'quantity': item.quantity,
        };
      }).toList();

      // Dữ liệu yêu cầu
      Map<String, dynamic> orderData = {
        'userId': userId,
        'products': products,
      };

      // Gửi yêu cầu POST đến backend
      final response = await http.post(
        Uri.parse('$baseUrl/api/orders/create'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(orderData),
      );

      // Kiểm tra phản hồi từ backend
      if(response.statusCode == 201){
        print('Đơn hàng đã được tạo thành công!');
      }else{
        print('Lỗi khi tạo đơn hàng: ${response.body}');
      }
    } catch (e) {
      print('Lỗi kết nối: $e');
    }
  }
}
