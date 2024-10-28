import 'package:app_supermarket/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Nhập AuthService nếu cần

class AddressUpdateScreen extends StatefulWidget {
  @override
  _AddressUpdateScreenState createState() => _AddressUpdateScreenState();
}

class _AddressUpdateScreenState extends State<AddressUpdateScreen> {
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Có thể lấy địa chỉ hiện tại để hiển thị
    _loadCurrentAddress();
  }

  // Hàm tải địa chỉ hiện tại (nếu có)
  void _loadCurrentAddress() async {
    // Bạn có thể sử dụng SharedPreferences để lấy địa chỉ hiện tại
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentAddress = prefs.getString('address');
    if (currentAddress != null) {
      _addressController.text = currentAddress;
    }
  }

  // Hàm cập nhật địa chỉ
  Future<void> _updateAddress() async {
    String newAddress = _addressController.text.trim();
    if (newAddress.isEmpty) {
      // Hiển thị thông báo nếu địa chỉ rỗng
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập địa chỉ mới')),
      );
      return;
    }

    AuthService authService = AuthService();
    bool success =
        await authService.updateAddress(newAddress); // Gọi service để cập nhật

    if (success) {
      // Nếu cập nhật thành công, có thể quay lại màn hình giỏ hàng hoặc hiển thị thông báo
      Navigator.pop(context); // Quay lại màn hình trước
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Cập nhật địa chỉ thành công',
                selectionColor: Colors.green)),
      );
    } else {
      // Hiển thị thông báo nếu có lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cập nhật địa chỉ không thành công')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật địa chỉ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Địa chỉ',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(400, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: _updateAddress,
              child: Text(
                'Cập nhật địa chỉ',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Jaldi',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
