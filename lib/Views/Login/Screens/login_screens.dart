import 'package:app_supermarket/Views/ForgetPassword/Screens/forget_password_screen.dart';
import 'package:app_supermarket/Views/Home/Screens/home.dart';
import 'package:app_supermarket/Views/Login/Widgets/custom_button.dart';
import 'package:app_supermarket/Views/Login/Widgets/custom_signup.dart';
import 'package:app_supermarket/Views/Login/Widgets/custom_textfield.dart';
import 'package:app_supermarket/Views/Login/Widgets/social.login.dart';
import 'package:app_supermarket/Views/Register/Screens/register_screen.dart';
import 'package:app_supermarket/Views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:app_supermarket/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Thêm import AuthService

class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key});

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService(); // Khởi tạo AuthService

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();

  bool success = await authService.login(email, password);
  if (success) {
    // Lưu thông tin đăng nhập
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email); // Lưu email hoặc token nếu có

    // Chuyển đến trang Home
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
    );
  } else {
    // Nếu thất bại, hiển thị thông báo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đăng nhập không thành công, vui lòng kiểm tra lại')),
    );
  }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Image(
                  image: AssetImage('assets/images/pngaaa.com-15843.png'),
                  width: 180,
                  height: 180,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back,',
                      style: TextStyle(fontSize: 36, fontFamily: 'Jaldi'),
                    ),
                    const Text(
                      'Khám phá những lựa chọn vô hạn và sự tiện lợi chưa từng có.',
                      style: TextStyle(fontSize: 17, fontFamily: "Inter"),
                    ),
                    const SizedBox(height: 15),
                    Form(
                      child: Column(
                        children: [
                          CustomTextfield(
                            controller: emailController,
                            labelText: 'E-Mail',
                            prefixIcon: const Icon(Icons.mail_outline),
                          ),
                          const SizedBox(height: 17),
                          CustomTextfield(
                            controller: passwordController,
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            isPassword: true,
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgetPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Quên mật khẩu?',
                              style: TextStyle(
                                color: Color(0xff0094E3),
                                fontFamily: 'Jaldi',
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            onButtonPressed: login, // Gọi hàm login
                            text: "Đăng nhập",
                          ),
                          const SizedBox(height: 10),
                          CustomCreateaccount(
                            onSignUpPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            signUpText: "Tạo tài khoản",
                          ),
                          const SizedBox(height: 20),
                          const Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                  endIndent: 10,
                                ),
                              ),
                              Text('Hoặc đăng nhập với'),
                              Expanded(
                                child: Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                  indent: 10,
                                ),
                              ),
                            ],
                          ),
                          const SocialLogin(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}