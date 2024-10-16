import 'package:app_supermarket/Views/Login/Widgets/custom_button.dart';
import 'package:app_supermarket/Views/Login/Widgets/custom_textfield.dart';
import 'package:app_supermarket/Views/Login/Widgets/social.login.dart';
import 'package:flutter/material.dart';
import 'package:app_supermarket/Services/auth_service.dart'; // Thêm đường dẫn đến AuthService

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameAccountController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameAccountController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final String name = nameAccountController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    final AuthService authService = AuthService();
    final bool success = await authService.register(name, email, password);

    if (success) {
      // Đăng ký thành công, có thể điều hướng đến trang khác
      Navigator.pop(context); // Quay lại trang trước
    } else {
      // Xử lý lỗi đăng ký
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký không thành công.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Đăng ký",
                  style: TextStyle(fontFamily: 'Jaldi', fontSize: 36),
                ),
                const Text(
                  'Hãy tạo tài khoản cho bạn!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 35),
                Form(
                  child: Column(
                    children: [
                      CustomTextfield(
                        controller: nameAccountController,
                        labelText: 'Tên tài khoản',
                        prefixIcon: const Icon(Icons.person_pin),
                      ),
                      const SizedBox(height: 15),
                      CustomTextfield(
                        controller: emailController,
                        labelText: 'E-Mail',
                        prefixIcon: const Icon(Icons.mail_outline),
                      ),
                      const SizedBox(height: 15),
                      CustomTextfield(
                        controller: passwordController,
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        isPassword: true,
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        onButtonPressed: _register,
                        text: "Đăng ký",
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
                          Text('Hoặc đăng ký với'),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
