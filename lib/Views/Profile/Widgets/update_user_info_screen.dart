import 'package:app_supermarket/Services/auth_service.dart';
import 'package:app_supermarket/utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUserInfoScreen extends StatefulWidget {
  @override
  _UpdateUserInfoScreenState createState() => _UpdateUserInfoScreenState();
}

class _UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  final AuthService authService = AuthService();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  String? currentName;
  String? currentEmail;
  String? currentAddress;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  // Lấy dữ liệu người dùng hiện tại từ SharedPreferences
  Future<void> _loadCurrentUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentName = prefs.getString('name');
      currentEmail = prefs.getString('email');
      currentAddress = prefs.getString('address');
      nameController.text = currentName ?? '';
      emailController.text = currentEmail ?? '';
      addressController.text = currentAddress ?? '';
    });
  }

  // Cập nhật thông tin người dùng
  Future<void> _updateUserInfo() async {
    String name = nameController.text;
    String email = emailController.text;
    String address = addressController.text;

    // Cập nhật tên, email, và địa chỉ qua AuthService
    final response =
        await authService.updateAddress(address); // Cập nhật địa chỉ
    if (response['success']) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', name);
      await prefs.setString('email', email);

      // Hiển thị thông báo thành công và quay lại ProfileScreen
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          AppLocalizations.of(context)?.get('updateSuccess') ??
              'Cập nhật thành công',
        ),
        backgroundColor: Colors.green,
      ));

      // Quay lại trang ProfileScreen
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)?.get('updateFailed') ??
            'Cập nhật không thành công'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.get('updateInfo') ??
            'Cập nhật Hồ sơ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)?.get('name') ?? 'Tên',
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 3.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)?.get('email') ?? 'Email',
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 3.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)?.get('address') ?? 'Địa chỉ',
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 3.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide:
                        const BorderSide(color: Colors.blue, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0091E5),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _updateUserInfo,
                child: Text(
                  AppLocalizations.of(context)?.get('update') ?? 'Cập nhật',
                  style: const TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
              const SizedBox(height: 50),
              Image.asset(
                'assets/images/content-creator.png', // Hình ảnh bạn muốn thêm
                width: 180, // Chiếm hết chiều rộng màn hình
                height: 200, // Điều chỉnh chiều cao tùy ý
                fit: BoxFit.cover, // Giúp hình ảnh không bị biến dạng
              ),
            ],
          ),
        ),
      ),
    );
  }
}
