import 'package:app_supermarket/Views/Admin/Servives/product_service.dart';
import 'package:app_supermarket/models/product.dart';
import 'package:app_supermarket/utils/app_localizations.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  final Product product; // Thay 'dynamic' bằng 'Product'

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final ProductService productService = ProductService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController imageUrlController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller với dữ liệu sản phẩm hiện có
    nameController =
        TextEditingController(text: widget.product.name); // Thay đổi ở đây
    descriptionController = TextEditingController(
        text: widget.product.description); // Thay đổi ở đây
    priceController = TextEditingController(
        text: widget.product.price.toString()); // Thay đổi ở đây
    imageUrlController =
        TextEditingController(text: widget.product.imageUrl); // Thay đổi ở đây
  }

  @override
  void dispose() {
    // Hủy controller để giải phóng bộ nhớ
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  Future<void> updateProduct() async {
    if (_formKey.currentState!.validate()) {
      final updatedProduct = {
        'name': nameController.text,
        'description': descriptionController.text,
        'price': double.tryParse(priceController.text) ?? 0.0,
        'imageUrl': imageUrlController.text,
      };

      try {
        await productService.updateProduct(
            widget.product.id, updatedProduct); // Sử dụng id thay vì _id
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)
                      ?.get('productUpdatedSuccessfully') ??
                  'Sản phẩm đã được cập nhật')),
        );
        Navigator.pop(context); // Trở về màn hình trước đó sau khi cập nhật
      } catch (e) {
        print('Error updating product: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi cập nhật sản phẩm: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.get('editProduct') ??
            'Chỉnh sửa sản phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)?.get('productName') ??
                            'Tên sản phẩm'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên sản phẩm';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)?.get('description') ??
                            'Mô tả'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mô tả sản phẩm';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)?.get('price') ??
                        'Giá sản phẩm'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập giá sản phẩm';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Giá không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: imageUrlController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)?.get('imageUrl') ??
                        'URL hình ảnh'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập URL hình ảnh';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0091E5),
                    minimumSize: const Size(400, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: updateProduct,
                child: Text(
                  AppLocalizations.of(context)?.get('updateProduct') ??
                      'Cập nhật sản phẩm',
                  style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'Jaldi',
                    color: Colors.white,
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
