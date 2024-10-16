import 'package:app_supermarket/Views/Login/Screens/login_screens.dart';
import 'package:app_supermarket/Views/Login/Widgets/custom_button.dart';
import 'package:flutter/material.dart';

class EmailSent extends StatelessWidget {
  const EmailSent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back), // Icon mũi tên quay lại
            onPressed: () {
              Navigator.pop(context); // Quay lại trang trước
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/images/ehs.jpg'),
              ),
              const Text(
                "Email đã được gửi!",
                style: TextStyle(
                  fontFamily: 'Jaldi',
                  fontSize: 36,
                ),
              ),
              const Text(
                "quangvutran61@gmail.com",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Bảo mật tài khoản của bạn là ưu tiên của chúng tôi! Chúng tôi đã gửi cho bạn một liên kết an toàn để thay đổi mật khẩu một cách an toàn và bảo vệ tài khoản của bạn.',
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 17,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomButton(
                onButtonPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreens()));
                },
                text: "Về trang đăng nhập",
              ),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  "Gửi lại email",
                  style: TextStyle(
                    fontFamily: "Inter",
                    color: Color(0xff0091E5),
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
