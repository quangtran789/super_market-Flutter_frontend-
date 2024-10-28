import 'package:app_supermarket/Views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:app_supermarket/models/discount_code.dart';
import 'package:app_supermarket/Views/Admin/Servives/discount_service.dart';
import 'package:app_supermarket/Views/Admin/Widgets/DiscountCode/create_discount_screen.dart';

class DiscountCodeListScreen extends StatefulWidget {
  @override
  _DiscountCodeListScreenState createState() => _DiscountCodeListScreenState();
}

class _DiscountCodeListScreenState extends State<DiscountCodeListScreen> {
  List<DiscountCode> discountCodes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDiscountCodes();
  }

  Future<void> fetchDiscountCodes() async {
    try {
      DiscountService discountService = DiscountService();
      List<DiscountCode> codes = await discountService.getDiscountCodes();
      setState(() {
        discountCodes = codes;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Failed to load discount codes: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Mã Giảm Giá'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Homepage()),
              (route) => false,
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateDiscountCodeScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : discountCodes.isEmpty
              ? Center(child: Text('Không có mã giảm giá nào.'))
              : ListView.builder(
                  itemCount: discountCodes.length,
                  itemBuilder: (context, index) {
                    var discountCode = discountCodes[index];
                    return ListTile(
                      title: Text(discountCode.code),
                      subtitle: Text(
                          'Giá trị: ${discountCode.discountValue} VNĐ - ${discountCode.isValid ? "Hợp lệ" : "Không hợp lệ"}'),
                    );
                  },
                ),
    );
  }
}
