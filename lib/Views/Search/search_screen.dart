// import 'package:app_supermarket/Views/Admin/Servives/product_service.dart';
// import 'package:flutter/material.dart';
// import 'package:app_supermarket/models/product.dart';


// class SearchProductScreen extends StatefulWidget {
//   final String query;

//   const SearchProductScreen({Key? key, required this.query}) : super(key: key);

//   @override
//   _SearchProductScreenState createState() => _SearchProductScreenState();
// }

// class _SearchProductScreenState extends State<SearchProductScreen> {
//   final ProductService productService = ProductService();
//   List<Product> searchResults = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchSearchResults();
//   }

//   Future<void> fetchSearchResults() async {
//     try {
//       searchResults = await productService.searchProducts(widget.query);
//     } catch (error) {
//       print('Error fetching search results: $error');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Kết quả tìm kiếm'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : searchResults.isNotEmpty
//               ? ListView.builder(
//                   itemCount: searchResults.length,
//                   itemBuilder: (context, index) {
//                     final product = searchResults[index];
//                     return ListTile(
//                       title: Text(product.name),
//                       subtitle: Text('Giá: ${product.price} VND'),
//                       leading: Image.network(
//                         product.imageUrl,
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return const Icon(Icons.broken_image, size: 50);
//                         },
//                       ),
//                       onTap: () {
//                         // Điều hướng đến trang chi tiết sản phẩm
//                       },
//                     );
//                   },
//                 )
//               : const Center(child: Text('Không tìm thấy sản phẩm nào')),
//     );
//   }
// }
