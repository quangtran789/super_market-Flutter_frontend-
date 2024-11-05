import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_supermarket/models/order.dart';

class OrderService {
  final String baseUrl = 'http://192.168.1.20:5000/api/orders';

  // Cập nhật hàm tạo đơn hàng để bao gồm discountCode và discountValue
  Future<bool> createOrder(
      String token, List<OrderItem> items, String address, String? discountCode, double discountValue) async {
    final url = Uri.parse('$baseUrl/create');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'items': items.map((item) => item.toJson()).toList(),
      'address': address,
      'discountCode': discountCode, // Thêm mã giảm giá
      'discountValue': discountValue, // Thêm giá trị giảm giá
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 201) {
      return true;
    } else {
      print('Failed to create order: ${response.body}');
      return false;
    }
  }

  Future<List<Order>> getUserOrders(String token) async {
    final url = Uri.parse('$baseUrl/my-orders');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final List<dynamic> orderJson = jsonDecode(response.body);
      return orderJson.map((json) => Order.fromJson(json)).toList();
    } else {
      print('Failed to fetch orders: ${response.body}');
      throw Exception('Failed to load orders');
    }
  }
}
