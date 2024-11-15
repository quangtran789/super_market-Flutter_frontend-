import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_supermarket/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  final String baseUrl = 'http://192.168.1.21:5000/api/orders';

  // Fetch token from SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      print('Token not found');
    }
    return token;
  }

  // Create an order with discount and image URL
  Future<bool> createOrder(String token, List<OrderItem> items, String address,
      String? discountCode, double discountValue) async {
    final url = Uri.parse('$baseUrl/create');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    // Ensure discountCode and discountValue are properly handled
    final body = jsonEncode({
      'items': items.map((item) => item.toJson()).toList(),
      'address': address,
      'discountCode': discountCode ?? "", // Use empty string if null
      'discountValue': discountValue,
      'status': 'chưa giải quyết',
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        print('Order created successfully');
        return true;
      } else {
        print('Failed to create order: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error creating order: $e');
      return false;
    }
  }

  // Fetch all orders, including image URL of products
  Future<List<Order>> getAllOrders() async {
    final url = Uri.parse('$baseUrl/all');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> orderJson = jsonDecode(response.body);
        return orderJson.map((json) => Order.fromJson(json)).toList();
      } else {
        print('Failed to fetch orders: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  // Update the order status
  Future<bool> updateOrderStatus(String orderId, String status) async {
    const validStatuses = [
      'chưa giải quyết',
      'xác nhận',
      'đã vận chuyển',
      'đã giao hàng',
      'đã hủy bỏ'
    ];

    if (!validStatuses.contains(status)) {
      print('Trạng thái không hợp lệ');
      return false;
    }

    final token = await getToken();
    if (token == null) {
      print('Token không hợp lệ hoặc chưa đăng nhập');
      return false;
    }

    final url = Uri.parse('$baseUrl/update/$orderId');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final body = jsonEncode({
      'status': status,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Trạng thái đơn hàng đã được cập nhật');
        return true;
      } else {
        print('Failed to update order status: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error updating order status: $e');
      return false;
    }
  }
}
