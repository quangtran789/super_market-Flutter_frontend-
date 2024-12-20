import 'package:app_supermarket/Services/auth_service.dart';
import 'package:app_supermarket/utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressUpdateScreen extends StatefulWidget {
  @override
  _AddressUpdateScreenState createState() => _AddressUpdateScreenState();
}

class _AddressUpdateScreenState extends State<AddressUpdateScreen> {
  final TextEditingController _addressController = TextEditingController();
  String? currentAddress;

  @override
  void initState() {
    super.initState();
    _loadCurrentAddress();
  }

  // Hàm tải địa chỉ hiện tại (nếu có)
  Future<void> _loadCurrentAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? address = prefs.getString('address');

    if (address == null || address.isEmpty) {
      // Nếu không có địa chỉ trong SharedPreferences, lấy từ API
      AuthService authService = AuthService();
      address = await authService.getCurrentAddress();
    }

    setState(() {
      currentAddress = address; // Cập nhật địa chỉ hiện tại vào biến
      if (address != null && address.isNotEmpty) {
        _addressController.text = address; // Hiển thị địa chỉ hiện tại nếu có
      }
    });
  }

  // Hàm cập nhật địa chỉ
  Future<void> _updateAddress() async {
    String newAddress = _addressController.text.trim();
    if (newAddress.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)?.get('pleaseEnterNewAddress') ??
                    'Vui lòng nhập địa chỉ mới')),
      );
      return;
    }

    AuthService authService = AuthService();
    final result = await authService.updateAddress(newAddress);

    if (result['success']) {
      // Nếu cập nhật thành công, lưu lại địa chỉ mới và quay lại màn hình trước
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('address', newAddress);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context)?.get('addressUpdatedSuccessfully') ??
                  'Cập nhật địa chỉ thành công'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Hiển thị thông báo nếu có lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.get('updateAddress') ??
            'Cập nhật địa chỉ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (currentAddress != null && currentAddress!.isNotEmpty) ...[
                Text(
                  '${AppLocalizations.of(context)?.get('currentAddress')}: $currentAddress',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
              ],
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)?.get('newAddress') ??
                      'Địa chỉ mới',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(400, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _updateAddress,
                child: Text(
                  AppLocalizations.of(context)?.get('updateAddress') ??
                      'Cập nhật địa chỉ',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'Jaldi',
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Image.asset(
                'assets/images/home.png',
                width: 300, // Chiều rộng toàn màn hình
                height: 300, // Chiều cao hình ảnh
                fit: BoxFit.cover, // Đảm bảo hình ảnh không bị méo
              ),
            ],
          ),
        ),
      ),
    );
  }
}
