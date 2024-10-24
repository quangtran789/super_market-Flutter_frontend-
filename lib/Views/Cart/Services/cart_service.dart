import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_supermarket/models/cart.dart'; // Import CartItem model

class CartService {
  final String baseUrl = 'http://192.168.1.20:5000/api/cart';

  // Thêm sản phẩm vào giỏ hàng
  Future<void> addProductToCart(String productId, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userId = prefs.getString('userId');

    if (token == null || userId == null) {
      throw Exception('User is not logged in');
    }

    final url = Uri.parse('$baseUrl/add');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'userId': userId,
          'productId': productId,
          'quantity': quantity,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add product to cart');
      }
    } catch (error) {
      throw error;
    }
  }

  // Lấy danh sách sản phẩm trong giỏ hàng
  Future<List<CartItem>> getCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? token = prefs.getString('token');

    if (userId == null || token == null) {
      throw Exception('User is not logged in');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/$userId'),
      headers: {
        'Authorization': 'Bearer $token', // Thêm token vào header
        'Content-Type': 'application/json', // Thêm header cho loại nội dung
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => CartItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch cart items: ${response.body}');
    }
  }

  // Cập nhật số lượng sản phẩm trong giỏ hàng
  Future<void> updateCartItemQuantity(String cartItemId, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('User is not logged in');
    }

    final url =
        Uri.parse('$baseUrl/update/$cartItemId'); // URL cập nhật số lượng

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'quantity': quantity}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update cart item quantity');
      }
    } catch (error) {
      throw error;
    }
  }

  // Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeProductFromCart(String cartItemId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('User is not logged in');
    }

    final url = Uri.parse('$baseUrl/remove/$cartItemId'); // URL xóa sản phẩm

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove product from cart');
      }
    } catch (error) {
      throw error;
    }
  }
}
