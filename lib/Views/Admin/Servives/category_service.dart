import 'dart:convert';
import 'package:app_supermarket/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryService {
  String baseUrl = 'http://192.168.1.23:5000';

  CategoryService();

  // Lấy token từ SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Lấy danh sách danh mục
  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/api/categories'));
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      print("Received JSON: $jsonList"); // In ra để kiểm tra dữ liệu nhận được
      return jsonList.map((json) {
        try {
          return Category.fromJson(json);
        } catch (e) {
          print("Error parsing JSON: $e"); // In ra lỗi nếu có
          rethrow; // Ném lại lỗi để xử lý ở nơi khác nếu cần
        }
      }).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Thêm danh mục
  Future<void> addCategory(
      String name, String description, String imageUrl) async {
    final token = await getToken(); // Lấy token từ SharedPreferences

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/categories'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Sử dụng token đã lấy
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'imageUrl': imageUrl, // Gửi imageUrl cùng với yêu cầu
        }),
      );

      if (response.statusCode == 201) {
        print('Category added successfully');
      } else {
        print('Error adding category: ${response.body}');
        throw Exception('Failed to add category: ${response.body}');
      }
    } catch (error) {
      print('Exception caught: $error');
    }
  }

  // Sửa danh mục
  Future<void> updateCategory(
      String id, String name, String description, String imageUrl) async {
    final token = await getToken(); // Lấy token từ SharedPreferences

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/categories/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'imageUrl': imageUrl, // Cập nhật imageUrl
        }),
      );

      if (response.statusCode == 200) {
        print('Category updated successfully');
      } else {
        print('Failed to update category: ${response.body}');
        throw Exception('Failed to update category');
      }
    } catch (error) {
      print('Error updating category: $error');
      throw Exception('Error updating category');
    }
  }

  // Xóa danh mục
  Future<void> deleteCategory(Category category) async {
    final token = await getToken(); // Lấy token từ SharedPreferences

    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/categories/${category.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Category deleted successfully');
      } else {
        print('Failed to delete category: ${response.body}');
        throw Exception('Failed to delete category');
      }
    } catch (error) {
      print('Error deleting category: $error');
      throw Exception('Error deleting category');
    }
  }
}
