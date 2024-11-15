import 'package:app_supermarket/Views/Home/Widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:app_supermarket/models/product.dart';
import 'package:app_supermarket/Views/Admin/Servives/product_service.dart';
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
        SnackBar(content: Text('Không thể tìm kiếm sản phẩm: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả tìm kiếm cho "${widget.query}"'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : searchResults.isEmpty
              ? const Center(child: Text('Không tìm thấy sản phẩm nào'))
              : ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final product = searchResults[index];
                    return ProductCard(product: product); // Sử dụng ProductCard để hiển thị sản phẩm
                  },
                ),
    );
  }
}
