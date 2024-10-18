import 'dart:convert';
import 'package:app_supermarket/models/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  String baseUrl = 'http://192.168.1.20:5000/api/products';

  // Lấy danh sách sản phẩm
  Future<List<Product>> getProducts() async {
    try {
      // Thực hiện yêu cầu HTTP GET
      final response = await http.get(Uri.parse(baseUrl));
      // Kiểm tra phản hồi từ server
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        // Chuyển đổi dữ liệu từ JSON thành danh sách sản phẩm
        return data
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching products: $error');
    }
  }

  //Tìm sản phẩm(search)

  // Lấy thông tin sản phẩm theo ID
  Future<Product?> getProductById(String id) async {
    try {
      final uri =
          Uri.parse('$baseUrl/products/$id'); // Sử dụng API URL hợp lệ với ID
      final response = await http.get(uri);

      // Kiểm tra statusCode
      if (response.statusCode == 200) {
        final Map<String, dynamic> productData = json.decode(response.body);
        print('Product data: $productData');

        // Kiểm tra nếu data không phải là null và có dữ liệu hợp lệ
        if (productData.isNotEmpty) {
          return Product.fromJson(productData);
        } else {
          throw Exception('Product not found');
        }
      } else {
        throw Exception(
            'Failed to load product. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching product: $error');
      return null; // Trả về null nếu có lỗi
    }
  }

  List<Product> productFromJson(String str) {
    final jsonData = json.decode(str);
    return List<Product>.from(jsonData.map((x) => Product.fromJson(x)));
  }

  // Hàm lấy sản phẩm theo danh mục
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/products?category=$categoryId'));

    if (response.statusCode == 200) {
      final List<Product> products = productFromJson(
          response.body); // Chuyển dữ liệu thành danh sách sản phẩm
      return products;
    } else {
      throw Exception('Failed to load products for category');
    }
  }

  /// Hàm thêm sản phẩm mới
  Future<void> addProduct(Map<String, dynamic> productData) async {
    // Kiểm tra nếu categoryId có trong productData
    if (productData['categoryId'] == null) {
      throw Exception('Category ID is required');
    }

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productData),
      );

      // Kiểm tra mã trạng thái và in phản hồi
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Response body: ${response.body}'); // In ra nội dung phản hồi
        throw Exception('Failed to add product: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }

  // Hàm cập nhật sản phẩm
  Future<void> updateProduct(
      String id, Map<String, dynamic> productData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productData),
      );

      // Kiểm tra mã trạng thái của response
      if (response.statusCode == 200) {
        print('Product updated successfully');
      } else {
        // Xử lý lỗi nếu response không phải 200
        throw Exception(
            'Failed to update product: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Xử lý lỗi khi có exception xảy ra
      throw Exception('Error updating product: $e');
    }
  }

  // Xóa sản phẩm
  Future<void> deleteProduct(String id) async {
    final url = '$baseUrl/$id'; // Xác định URL
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 200) {
      print(
          'Failed to delete product: ${response.statusCode} ${response.body}'); // In ra thông tin phản hồi
      throw Exception('Failed to delete product: ${response.body}');
    }
  }
}
