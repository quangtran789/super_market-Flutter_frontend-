import 'package:flutter/material.dart';
import 'package:app_supermarket/models/cart.dart'; // Nhớ import CartModel ở đây
import 'package:app_supermarket/Views/Cart/Services/cart_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = []; // Danh sách sản phẩm trong giỏ hàng
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  // Hàm lấy danh sách sản phẩm trong giỏ hàng
  Future<void> fetchCartItems() async {
    try {
      CartService cartService = CartService();
      List<CartItem> items =
          await cartService.getCartItems(); // Sử dụng CartItem
      print(
          'Cart items received: $items'); // In ra danh sách sản phẩm trong giỏ hàng
      setState(() {
        cartItems = items;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Failed to load cart items: $error");
    }
  }

  // Hàm để tính tổng giá
  double calculateTotalPrice() {
    double total = 0;
    for (var item in cartItems) {
      total += item.quantity *
          item.product.price; // Sử dụng thuộc tính price từ CartItem
    }
    return total;
  }

  // Hàm xóa sản phẩm khỏi giỏ hàng
  Future<void> removeItemFromCart(String productId) async {
    try {
      CartService cartService = CartService();
      await cartService.removeProductFromCart(
          productId); // Gọi phương thức removeItem từ CartService
      fetchCartItems(); // Refresh cart after removal
    } catch (error) {
      print("Failed to remove item from cart: $error");
    }
  }

  // Hàm thanh toán (có thể gọi tới một service khác)
  Future<void> checkout() async {
    // Implement your checkout logic here
    print("Proceeding to checkout...");
    // Giả sử bạn sẽ điều hướng đến màn hình thanh toán hoặc gửi yêu cầu đến server
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ Hàng'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(child: Text('Giỏ hàng trống'))
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    return ListTile(
                      leading: Image.network(
                        item.product.imageUrl ?? '',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item.product.name),
                      subtitle: Text(
                        'Số lượng: ${item.quantity} - Giá: ${item.product.price} VNĐ',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          removeItemFromCart(item.id);
                        },
                      ),
                    );
                  },
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(),
            Text(
              'Tổng cộng: ${calculateTotalPrice().toStringAsFixed(2)} VNĐ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                checkout(); // Gọi hàm thanh toán
              },
              child: Text('Thanh Toán'),
            ),
          ],
        ),
      ),
    );
  }
}
