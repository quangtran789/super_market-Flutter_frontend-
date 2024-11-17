import 'package:app_supermarket/Views/Cart/Services/cart_service.dart';
import 'package:app_supermarket/Views/Home/Widgets/product_card.dart';
import 'package:app_supermarket/Views/Home/Widgets/product_detail_screen.dart';
import 'package:app_supermarket/utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app_supermarket/models/product.dart';
import 'package:app_supermarket/Views/Admin/Servives/product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Import đúng đường dẫn nếu cần

class SearchScreen extends StatefulWidget {
  final String query;
  const SearchScreen({Key? key, required this.query}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product> searchResults = [];
  bool isLoading = true;
  final ProductService productService = ProductService();

  @override
  void initState() {
    super.initState();
    searchProducts(widget.query);
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
        SnackBar(
          content: Text(AppLocalizations.of(context)?.get('addedToCart') ??
              'Đã thêm sản phẩm vào giỏ hàng'),
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

  Future<void> searchProducts(String query) async {
    setState(() {
      isLoading = true;
    });
    try {
      List<Product> results = await productService.searchProducts(query);
      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)?.get('cannotSearchProduct') ??
                    'Không thể tìm kiếm sản phẩm: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${AppLocalizations.of(context)?.get('searchResultsFor')} \ "${widget.query}"'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : searchResults.isEmpty
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)
                              ?.get('cannotSearchProduct') ??
                          'Không tìm thấy sản phẩm nào',
                      style: const TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                          fontSize: 23),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      'assets/images/people.png', // Hình ảnh bạn muốn thêm
                      width: 150, // Chiếm hết chiều rộng màn hình
                      height: 150, // Điều chỉnh chiều cao tùy ý
                      fit: BoxFit.cover, // Giúp hình ảnh không bị biến dạng
                    ),
                  ],
                ))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 15.0),
                    child: GridView.builder(
                      shrinkWrap:
                          true, // Giúp GridView không chiếm toàn bộ chiều cao
                      physics:
                          const NeverScrollableScrollPhysics(), // Tắt cuộn riêng của GridView
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Số cột là 2
                        crossAxisSpacing: 10, // Khoảng cách ngang giữa các cột
                        mainAxisSpacing: 10, // Khoảng cách dọc giữa các hàng
                        childAspectRatio: 0.7, // Tỉ lệ khung hình của từng ô
                      ),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final product = searchResults[index];
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
                              color: Colors.transparent, // Màu nền trong suốt
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.black26,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                          size: 50,
                                        );
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
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${product.price.toStringAsFixed(3)} VND',
                                            style:
                                                const TextStyle(fontSize: 14),
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
                    ),
                  ),
                ),
    );
  }
}
