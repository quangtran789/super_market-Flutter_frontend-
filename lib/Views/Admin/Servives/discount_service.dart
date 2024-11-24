import 'dart:convert';
import 'package:app_supermarket/models/discount_code.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DiscountService {
  final String baseUrl = 'http://192.168.1.23:5000/api'; // Địa chỉ server

  // Hàm lấy danh sách các mã giảm giá
  Future<List<DiscountCode>> getDiscountCodes() async {
    final response = await http
        .get(Uri.parse('$baseUrl/discount-codes/')); // Sửa đường dẫn ở đây

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((discountCode) => DiscountCode.fromJson(discountCode))
          .toList();
    } else {
      throw Exception('Failed to load discount codes');
    }
  }

  // Áp dụng mã giảm giá
  Future<Map<String, dynamic>> applyDiscountCode(String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/discount-codes/apply'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      // In ra status code và body của phản hồi
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        // Chuyển đổi discountValue thành double
        double discountValue = (data['discountValue'] is int)
            ? (data['discountValue'] as int).toDouble()
            : data['discountValue'];
        return {
          'discountValue': discountValue,
        };
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error applying discount code: $error');
    }
  }

  // Tạo mã giảm giá mới (Admin)
  Future<void> createDiscountCode(DiscountCode discountCode) async {
    print(
        'Creating discount code: ${discountCode.toJson()}'); // In ra dữ liệu mã giảm giá
    final response = await http.post(
      Uri.parse('$baseUrl/discount-codes/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(discountCode.toJson()),
    );

    if (response.statusCode != 201) {
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to create discount code');
    }
  }

  // Xóa mã giảm giá theo ID
  Future<void> deleteDiscountCode(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/discount-codes/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Discount code deleted successfully');
      } else if (response.statusCode == 404) {
        throw Exception('Discount code not found');
      } else {
        throw Exception('Failed to delete discount code');
      }
    } catch (error) {
      throw Exception('Error deleting discount code: $error');
    }
  }
}
