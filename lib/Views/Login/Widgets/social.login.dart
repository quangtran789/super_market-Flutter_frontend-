import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

Future<void> _loginWithFacebook(BuildContext context) async {
    final result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      // Lấy thông tin người dùng
      final userData = await FacebookAuth.instance.getUserData();
      // Xử lý thông tin người dùng (lưu vào database, xác thực, ...)
      print('User Data: $userData');
    } else {
      // Xử lý lỗi
      print('Facebook login failed: ${result.status}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Căn giữa toàn bộ Row
          children: [
            Container(
              alignment: Alignment.center,
              height: 55,
              width: 55, // Giữ width cố định
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SvgPicture.asset(
                'assets/images/google.svg',
                height: 40,
              ),
            ),
            const SizedBox(
              width: 50, // Tạo khoảng cách giữa các icon
            ),
            GestureDetector(
              onTap: () => _loginWithFacebook(context), // Kết nối với hàm đăng nhập Facebook
              child: Container(
                alignment: Alignment.center,
                height: 55,
                width: 55, // Giữ width cố định
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  'assets/images/fb.svg',
                  height: 40,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}