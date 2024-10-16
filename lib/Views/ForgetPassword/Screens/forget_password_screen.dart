import 'package:app_supermarket/Views/ForgetPassword/Screens/email_sent.dart';
import 'package:app_supermarket/Views/Login/Widgets/custom_button.dart';
import 'package:app_supermarket/Views/Login/Widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Quên mật khẩu",
                style: TextStyle(
                  fontFamily: 'Jaldi',
                  fontSize: 36,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Đừng lo lắng, đôi khi chúng ta có thể sẽ quên mật khẩu, nhập e-mail và chúng tôi sẽ gửi link khởi tạo lại mật khẩu.',
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 17,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Form(
                child: Column(
                  children: [
                    CustomTextfield(
                      controller: emailController,
                      labelText: 'E-Mail',
                      prefixIcon: const Icon(Icons.mail_outline),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    CustomButton(
                      onButtonPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EmailSent()));
                      },
                      text: "Gửi",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
