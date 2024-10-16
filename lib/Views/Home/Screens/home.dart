import 'package:app_supermarket/Views/Admin/Screens/admin_screen.dart';
import 'package:app_supermarket/Views/Admin/Servives/category_service.dart';
import 'package:app_supermarket/Views/Admin/Servives/product_service.dart';

import 'package:app_supermarket/Views/Home/Screens/productByCategory_screen.dart';

import 'package:app_supermarket/Views/Home/Widgets/carousel_image.dart';
import 'package:app_supermarket/Views/Home/Widgets/product_detail_screen.dart';
import 'package:app_supermarket/Views/Login/Screens/login_screens.dart';
import 'package:app_supermarket/Views/Login/Widgets/custom_textfield.dart';
import 'package:app_supermarket/models/category.dart';
import 'package:app_supermarket/models/product.dart';
import 'package:app_supermarket/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  List<Category> categories = [];
  final CategoryService categoryService = CategoryService();
  final TextEditingController searchController = TextEditingController();
  String userName = 'Người dùng';
  List<Product> productList = [];
  bool isLoading = true;
  String selectedCategoryId = '';

  

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreens()),
    );
  }

  Future<String?> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  void navigateToAdmin() async {
    String? role = await getUserRole();
    if (role == 'admin') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn không có quyền truy cập vào Admin!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchUserName();
    fetchProducts();
  }

  Future<void> fetchCategories() async {
    try {
      final List<Category> data = await categoryService.getCategories();
      setState(() {
        categories = data;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải danh mục: $e')),
      );
    }
  }

  Future<void> fetchProducts() async {
    try {
      final productService = ProductService();
      productList = await productService.getProducts();
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      throw Exception('Error fetching products: $error');
    }
  }

  Future<void> fetchUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedName = prefs.getString('name');
    setState(() {
      userName = storedName ?? 'Người dùng';
    });
  }
  

  @override
  Widget build(BuildContext context) {
    AppSizes().initSizes(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  'Xin chào, $userName',
                  style: const TextStyle(
                      fontSize: 25,
                      fontFamily: 'Jaldi',
                      fontWeight: FontWeight.w400),
                ),
                const Text(
                  'Bạn muốn mua gì hôm nay?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: logout, // Gọi hàm đăng xuất
            ),
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: navigateToAdmin, // Gọi hàm điều hướng
            ),
          ],
        ),
        body: SingleChildScrollView(
          // Thêm SingleChildScrollView bao quanh toàn bộ nội dung
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                CustomTextfield(
                  controller: searchController,
                  labelText: 'Tìm kiếm sản phẩm...',
                  prefixIcon: const Icon(Icons.search),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 100,
                  child: categories.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductbycategoryScreen(
                                        categoryId: category.id,
                                        categoryName: category.name,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    category.imageUrl != null
                                        ? Image.network(
                                            category.imageUrl!,
                                            width: 65,
                                            height: 65,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(
                                                  Icons.broken_image,
                                                  size: 71);
                                            },
                                          )
                                        : const Icon(Icons.category, size: 50),
                                    const SizedBox(height: 5),
                                    Text(
                                      category.name,
                                      style: const TextStyle(
                                        fontFamily: 'Jaldi',
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(child: Text('Không có danh mục nào')),
                ),

                const SizedBox(
                  height: 10,
                ),
                const CarouselImage(),
                const SizedBox(
                  height: 10,
                ),
                // Product list section
                isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator()) // Hiển thị vòng tròn tải
                    : productList.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true, // Để danh sách sản phẩm cuộn được
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                              final product = productList[index];
                              return ListTile(
                                leading: Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(8), // Bo góc
                                    border: Border.all(
                                      color: Colors.black26, // Màu viền đen
                                      width: 2, // Độ dày của viền
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        8), // Bo góc cho hình ảnh
                                    child: Image.network(
                                      product
                                          .imageUrl, // Đường dẫn ảnh của sản phẩm
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.broken_image,
                                            size:
                                                50); // Icon khi không tải được ảnh
                                      },
                                    ),
                                  ),
                                ),
                                title: Text(
                                  product.name,
                                  style: const TextStyle(
                                      fontFamily: 'Jaldi', fontSize: 20),
                                ),
                                subtitle: Text('Giá: ${product.price} VND'),
                                trailing: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
                                                product: product),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        Colors.blue, // Màu của chữ nút
                                  ),
                                  child: const Text('Xem Thông Tin'),
                                ),
                              );
                            },
                          )
                        : const Center(child: Text('Không có sản phẩm nào')),
              ],
            ),
          ),
        ),
        
      ),
    );
  }
}
