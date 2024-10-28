import 'package:flutter/material.dart';
import 'package:app_supermarket/Views/Admin/Servives/discount_service.dart';
import 'package:app_supermarket/models/discount_code.dart';

class CreateDiscountCodeScreen extends StatefulWidget {
  @override
  _CreateDiscountCodeScreenState createState() =>
      _CreateDiscountCodeScreenState();
}

class _CreateDiscountCodeScreenState extends State<CreateDiscountCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  String code = '';
  double discountValue = 0;
  DateTime expiryDate = DateTime.now();
  bool isValid = true;
  bool isLoading = false; // Thêm biến trạng thái loading

  final DiscountService discountService = DiscountService();

  void _createDiscountCode() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      DiscountCode discountCode = DiscountCode(
        id: '', // ID sẽ được tạo tự động từ server
        code: code,
        discountValue: discountValue,
        isValid: isValid,
        expiryDate: expiryDate,
      );

      setState(() {
        isLoading = true; // Bắt đầu quá trình tạo mã
      });

      try {
        await discountService.createDiscountCode(discountCode);
        Navigator.pop(context); // Quay lại trang trước
      } catch (error) {
        print('Failed to create discount code: $error');
      } finally {
        setState(() {
          isLoading = false; // Kết thúc quá trình tạo mã
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tạo Mã Giảm Giá'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Hiển thị loading
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Mã Giảm Giá'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mã giảm giá.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        code = value!;
                      },
                    ),
                    TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Giá trị Giảm Giá (VNĐ)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập giá trị giảm giá.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        discountValue = double.parse(value!);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Ngày Hết Hạn'),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: expiryDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            expiryDate = pickedDate;
                          });
                        }
                      },
                      controller: TextEditingController(
                          text: '${expiryDate.toLocal()}'.split(' ')[0]),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                          minimumSize: const Size(400, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: _createDiscountCode,
                      child: Text(
                        'Tạo Mã Giảm Giá',
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
            ),
    );
  }
}
