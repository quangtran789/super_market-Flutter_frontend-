import 'package:app_supermarket/Views/Admin/Servives/category_service.dart';
import 'package:flutter/material.dart';

class AddCategoryScreen extends StatefulWidget {
  final Function onAdd;

  const AddCategoryScreen({super.key, required this.onAdd});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController(); // Thêm controller cho URL hình ảnh
  final CategoryService categoryService = CategoryService();

  Future<void> addCategory() async {
    try {
      await categoryService.addCategory(
        _nameController.text,
        _descriptionController.text,
        _imageUrlController.text,
      );
      widget.onAdd(); // Gọi callback sau khi thêm
      Navigator.pop(context); 
    } catch (e) {
      print('Error adding category: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm danh mục'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên danh mục'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
            ),
            TextField(
              controller: _imageUrlController, 
              decoration: const InputDecoration(labelText: 'URL hình ảnh'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addCategory,
              child: const Text('Thêm danh mục'),
            ),
          ],
        ),
      ),
    );
  }
}
