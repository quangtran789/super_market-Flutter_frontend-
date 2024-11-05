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
    return prefs
        .getString('name'); // Trả về tên người dùng từ SharedPreferences
  }

  // Kiểm tra trạng thái đăng nhập
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null; // Trả về true nếu có token
  }

  // Cập nhật địa chỉ người dùng
  // Cập nhật địa chỉ người dùng
Future<Map<String, dynamic>> updateAddress(String address) async {
  final token = await _getToken();

  final response = await http.put(
    Uri.parse('$baseUrl/api/users/update-address'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({'address': address}),
  );

  if (response.statusCode == 200) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Lưu địa chỉ mới vào SharedPreferences
    await prefs.setString('address', address);
    
    // Giả sử phản hồi từ server có dạng: 
    // { "message": "...", "currentAddress": "..." }
    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    return {
      'success': true,
      'message': responseBody['message'],
      'currentAddress': responseBody.containsKey('currentAddress') 
                          ? responseBody['currentAddress'] 
                          : null,
    };
  } else {
    return {
      'success': false,
      'message': 'Cập nhật địa chỉ không thành công',
    };
  }
}
// Lấy địa chỉ hiện tại của người dùng
Future<String?> getCurrentAddress() async {
  final token = await _getToken();
  final response = await http.get(
    Uri.parse('$baseUrl/api/users/current-address'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['address']; // Trả về địa chỉ
  } else {
    return null; // Không có địa chỉ hoặc xảy ra lỗi
  }
}



  // Phương thức xóa tài khoản
  Future<bool> deleteAccount() async {
    final token = await _getToken(); // Lấy token từ SharedPreferences

    if (token == null) {
      return false; // Nếu không có token, trả về false
    }

    final response = await http.delete(
      Uri.parse(
          '$baseUrl/api/users/delete-account'), // Đường dẫn API xóa tài khoản
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Xóa thông tin người dùng trong SharedPreferences
      return true;
    } else {
      print('Failed to delete account: ${response.body}');
      return false;
    }
  }

  // Hàm lấy token từ SharedPreferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
