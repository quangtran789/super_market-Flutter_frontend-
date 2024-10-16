import 'package:app_supermarket/Views/Admin/Servives/category_service.dart';
import 'package:app_supermarket/Views/Admin/Widgets/Category/add_category_screen.dart';
import 'package:app_supermarket/Views/Admin/Widgets/Category/edit_category_screen.dart';
import 'package:app_supermarket/Views/Home/Screens/home.dart';
import 'package:app_supermarket/Views/homepage.dart';
import 'package:app_supermarket/models/category.dart';
import 'package:flutter/material.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  List<dynamic> categories = [];
  final CategoryService categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await categoryService.getCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> fetchUpdate(
      String id, String name, String description, String imageUrl) async {
    try {
      await categoryService.updateCategory(id, name, description, imageUrl);
      fetchCategories(); // Cập nhật danh sách sau khi sửa
    } catch (e) {
      print('Error during category update: $e');
    }
  }

  Future<void> fetchDelete(Category category) async {
    try {
      await categoryService.deleteCategory(category); // Truyền cả đối tượng
      fetchCategories(); // Cập nhật danh sách sau khi xóa
    } catch (e) {
      print('Error deleting category: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách danh mục"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const Homepage()), 
              (route) => false, 
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            leading: category.imageUrl != null
                ? Image.network(category.imageUrl!)
                : null, // Hiển thị hình ảnh nếu có
            title: Text(category.name),
            subtitle: Text(
              category.description ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditCategoryScreen(
                          categoryId: category
                              .id, // Dùng category.id thay vì categories[index]['_id']
                          categoryName: category
                              .name, // Dùng category.name thay vì categories[index]['name']
                          categoryDescription: category
                              .description, // Dùng category.description thay vì categories[index]['description']
                          categoryImageUrl: category
                              .imageUrl, // Dùng category.imageUrl thay vì categories[index]['imageUrl']
                          onUpdate: fetchUpdate,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Xóa danh mục'),
                        content: const Text(
                            'Bạn có chắc chắn muốn xóa danh mục này không?'),
                        actions: [
                          TextButton(
                            child: const Text('Hủy'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Xóa'),
                            onPressed: () {
                              fetchDelete(
                                  category); // Truyền cả đối tượng category
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddCategoryScreen(
                onAdd: fetchCategories,
              ),
            ),
          );
        },
        tooltip: "Thêm danh mục",
        child: const Icon(Icons.add),
      ),
    );
  }
}
