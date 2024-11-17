import 'package:app_supermarket/Views/Admin/Screens/admin_screen.dart';
import 'package:app_supermarket/Views/Admin/Servives/category_service.dart';
import 'package:app_supermarket/Views/Admin/Servives/product_service.dart';
import 'package:app_supermarket/Views/Cart/Services/cart_service.dart';
import 'package:app_supermarket/Views/Home/Screens/productByCategory_screen.dart';
import 'package:app_supermarket/utils/app_localizations.dart';
import 'package:app_supermarket/Views/Home/Widgets/carousel_image.dart';
import 'package:app_supermarket/Views/Home/Widgets/product_detail_screen.dart';
import 'package:app_supermarket/Views/Home/Widgets/search_screen.dart';
import 'package:app_supermarket/Views/Login/Screens/login_screens.dart';
import 'package:app_supermarket/Views/Login/Widgets/custom_textfield.dart';
import 'package:app_supermarket/models/category.dart';
import 'package:app_supermarket/models/product.dart';
import 'package:app_supermarket/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  static const String routeName = '/home';
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

  // Chuyển hướng đến trang tìm kiếm với từ khóa
  void navigateToSearchScreen() {
    String query = searchController.text;
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchScreen(query: query),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)?.get('pleaseEnterSearchKeyword') ??
                    'Vui lòng nhập từ khóa tìm kiếm')),
      );
    }
  }

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
        SnackBar(
          content: Text(AppLocalizations.of(context)?.get('noAccessToAdmin') ??
              'Bạn không có quyền truy cập vào Admin!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Add product to cart method
  void _addToCart(BuildContext context, Product product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    String? token = prefs.getString('token');

    if (userId == null || token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Bạn cần đăng nhập trước khi thêm sản phẩm vào giỏ hàng'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    CartService cartService = CartService();

    try {
      await cartService.addProductToCart(product.id, 1); // 1 is quantity
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã thêm sản phẩm vào giỏ hàng'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $error'),
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
          title: Column(
            children: [
              Text(
                '${AppLocalizations.of(context)!.get('hello')}, $userName',
                style: const TextStyle(
                    fontSize: 25,
                    fontFamily: 'Jaldi',
                    fontWeight: FontWeight.w400),
              ),
              Text(
                AppLocalizations.of(context)?.get('whatDoYouWantToBuy') ??
                    'Bạn muốn mua gì hôm nay?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: logout,
            ),
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: navigateToAdmin,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextfield(
                        controller: searchController,
                        labelText: AppLocalizations.of(context)
                                ?.get('searchProduct') ??
                            'Tìm kiếm sản phẩm...',
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed:
                          navigateToSearchScreen, // Điều hướng qua SearchScreen
                    ),
                  ],
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
                const SizedBox(height: 10),
                const CarouselImage(),
                const SizedBox(height: 20),
                Text(
                  AppLocalizations.of(context)?.get('storeProducts') ??
                      'Sản phẩm của cửa hàng',
                  style: const TextStyle(fontFamily: 'Jaldi', fontSize: 20),
                ),
                const SizedBox(height: 10),
                // Product list section
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : productList.isNotEmpty
                        ? GridView.builder(
                            shrinkWrap:
                                true, // Giúp GridView không chiếm toàn bộ chiều cao
                            physics:
                                const NeverScrollableScrollPhysics(), // Tắt cuộn riêng của GridView
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Số cột là 2
                              crossAxisSpacing:
                                  10, // Khoảng cách ngang giữa các cột
                              mainAxisSpacing:
                                  10, // Khoảng cách dọc giữa các hàng
                              childAspectRatio:
                                  0.7, // Tỉ lệ khung hình của từng ô
                            ),
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                              final product = productList[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ProductDetailScreen(product: product),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .transparent, // Màu nền trong suốt
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.black26,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                          ),
                                          child: Image.network(
                                            product.imageUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(
                                                  Icons.broken_image,
                                                  size: 50);
                                            },
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.name
                                                      .split(' ')
                                                      .take(2)
                                                      .join(' '),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  '${AppLocalizations.of(context)!.get('price')}: ${product.price} VND',
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.add_shopping_cart,
                                                color: Colors.blue,
                                              ),
                                              onPressed: () {
                                                // Xử lý sự kiện thêm vào giỏ hàng
                                                _addToCart(context, product);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text('Không có sản phẩm nào'),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
