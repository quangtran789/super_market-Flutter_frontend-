import 'package:app_supermarket/Views/homepage.dart';
import 'package:app_supermarket/utils/app_localizations.dart';
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

  // Hàm xóa mã giảm giá
  Future<void> deleteDiscountCode(String id, int index) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)?.get('delete') ?? 'Xóa mã giảm giá'),
          content: Text(AppLocalizations.of(context)?.get('confirmDelete') ?? 'Bạn có chắc chắn muốn xóa mã giảm giá này?'),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)?.get('cancel') ?? 'Hủy'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)?.get('delete') ?? 'Xóa'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm) {
      try {
        DiscountService discountService = DiscountService();
        await discountService.deleteDiscountCode(id);
        setState(() {
          discountCodes.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.get('deletedSuccessfully') ?? 'Đã xóa mã giảm giá thành công!')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.get('deleteFailed') ?? 'Xóa thất bại: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.get('discountList') ?? 'Danh Sách Mã Giảm Giá'),
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
                        '${AppLocalizations.of(context)?.get('value')}: ${discountCode.discountValue} VNĐ - ${discountCode.isValid ? AppLocalizations.of(context)?.get('valid') : AppLocalizations.of(context)?.get('invalid')}',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteDiscountCode(discountCode.id, index),
                      ),
                    );
                  },
                ),
    );
  }
}
