import 'package:app_supermarket/utils/app_localizations.dart';
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
        title: Text(AppLocalizations.of(context)?.get('editCategory') ??
            "Chỉnh sửa danh mục"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)?.get('categoryName') ??
                          'Tên danh mục'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)?.get('description') ??
                      'Mô tả'),
            ),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)?.get('imageUrl') ??
                      'URL hình ảnh'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  minimumSize: const Size(400, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: _updateCategory,
              child: Text(
                AppLocalizations.of(context)?.get('saveChanges') ??
                    'Lưu thay đổi',
                style: const TextStyle(
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
