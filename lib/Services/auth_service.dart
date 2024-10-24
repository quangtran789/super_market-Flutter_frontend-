import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String baseUrl = 'http://192.168.1.20:5000';
  AuthService();

  Future<bool> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == 201) {
      // Lưu tên người dùng vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', name); // Lưu tên người dùng
      return true; // Đăng ký thành công
    } else {
      return false; // Đăng ký không thành công
    }
  }

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Nếu đăng nhập thành công, lưu thông tin vào SharedPreferences
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      await prefs.setString('userId', data['_id']); // Lưu userId
      await prefs.setString('email', data['email']);
      await prefs.setString('name', data['name']); // Lưu tên người dùng
      await prefs.setString('role', data['role']); // Lưu vai trò
      await prefs.setString('token', data['token']); // Lưu token nếu cần

      return true; // Đăng nhập thành công
    } else {
      final errorData = jsonDecode(response.body);
      print('Login failed: ${errorData['message']}'); // In ra thông báo lỗi
      return false; // Đăng nhập không thành công
    }
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Trả về userId từ SharedPreferences
  }

  // Lấy tên người dùng
  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name'); // Trả về tên người dùng từ SharedPreferences
  }

  // Kiểm tra trạng thái đăng nhập
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null; // Trả về true nếu có token
  }
}