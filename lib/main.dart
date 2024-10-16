import 'package:app_supermarket/Views/Home/Screens/home.dart';
import 'package:app_supermarket/Views/Admin/Screens/admin_screen.dart';
import 'package:app_supermarket/Views/Login/Screens/login_screens.dart';
import 'package:app_supermarket/Views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo khởi tạo Flutter
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString('email'); // Lấy email từ SharedPreferences
  String? role = prefs.getString('role'); // Lấy vai trò từ SharedPreferences
  runApp(MainApp(isLoggedIn: email != null, role: role));
}

class MainApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? role; // Thêm biến role

  const MainApp({super.key, required this.isLoggedIn, this.role});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? (role == 'admin'
              ? const AdminScreen()
              : const Homepage()) // Chọn trang dựa trên vai trò
          : const LoginScreens(),
    );
  }
}
