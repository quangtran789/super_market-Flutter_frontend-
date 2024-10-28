import 'package:app_supermarket/Views/Admin/Servives/product_service.dart';
import 'package:app_supermarket/Views/Admin/Servives/category_service.dart';
import 'package:app_supermarket/models/category.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ProductService productService = ProductService();
  String? name;
  String? description;
  double? price;
  String? imageUrl;
  int? quantity;
  Category? selectedCategory; // Changed to use Category object
  List<Category> categories = []; // Changed to use Category objects
  final CategoryService categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Tải danh sách danh mục khi khởi tạo
  }

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await categoryService.getCategories();
      setState(() {
        categories = fetchedCategories; // Assuming this is a List<Category>
      });
    } catch (e) {
      print('Error fetching categories: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể tải danh mục')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (name == null ||
        description == null ||
        price == null ||
        imageUrl == null ||
        quantity == null ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    if (price! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giá sản phẩm phải lớn hơn 0')),
      );
      return;
    }

    if (quantity! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Số lượng phải lớn hơn 0')),
      );
      return;
    }

    if (!Uri.parse(imageUrl!).isAbsolute) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL hình ảnh không hợp lệ')),
      );
      return;
    }

    try {
      await productService.addProduct({
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'categoryId':
            selectedCategory!.id, // Use the `id` field of the Category
        'quantity': quantity,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sản phẩm đã được thêm thành công!')),
      );

      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${error.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Sản Phẩm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Tên sản phẩm'),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Mô tả sản phẩm'),
              onChanged: (value) {
                setState(() {
                  description = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Giá sản phẩm'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  price = double.tryParse(value);
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'URL hình ảnh'),
              onChanged: (value) {
                setState(() {
                  imageUrl = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Số lượng'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  quantity = int.tryParse(value);
                });
              },
            ),
            DropdownButton<Category>(
              hint: const Text('Chọn danh mục'),
              value: selectedCategory,
              onChanged: (Category? newValue) {
                setState(() {
                  selectedCategory = newValue;
                });
              },
              items: categories.isNotEmpty
                  ? categories.map((Category category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Text(category
                            .name), // Use the `name` field of the Category
                      );
                    }).toList()
                  : [
                      const DropdownMenuItem<Category>(
                        value: null,
                        child: Text('Chưa có danh mục'),
                      ),
                    ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  minimumSize: const Size(400, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: _submitForm,
              child: const Text(
                'Thêm sản phẩm',
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
