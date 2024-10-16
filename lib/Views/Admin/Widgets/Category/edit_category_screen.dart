import 'package:flutter/material.dart';

class EditCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final String categoryDescription;
  final String? categoryImageUrl;
  final Function(String, String, String, String) onUpdate;

  const EditCategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryDescription,
    this.categoryImageUrl,
    required this.onUpdate, 
  });

  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController imageUrlController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.categoryName);
    descriptionController =
        TextEditingController(text: widget.categoryDescription);
    imageUrlController =
        TextEditingController(text: widget.categoryImageUrl ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  void _updateCategory() {
    // Gọi hàm onUpdate từ CategoryListScreen
    widget.onUpdate(
      widget.categoryId,
      nameController.text,
      descriptionController.text,
      imageUrlController.text,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa danh mục"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Tên danh mục'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
            ),
            TextField(
              controller: imageUrlController,
              decoration: const InputDecoration(labelText: 'URL hình ảnh'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateCategory,
              child: const Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }
}
