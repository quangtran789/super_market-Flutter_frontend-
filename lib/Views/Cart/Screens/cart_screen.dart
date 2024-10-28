import 'package:app_supermarket/Views/Admin/Servives/discount_service.dart';
import 'package:app_supermarket/Views/Cart/Widgets/address_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_supermarket/models/cart.dart'; // Nhớ import CartModel ở đây
import 'package:app_supermarket/Views/Cart/Services/cart_service.dart';
// Import dịch vụ giảm giá
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = []; // Danh sách sản phẩm trong giỏ hàng
  bool isLoading = true;
  String discountCode = ''; // Biến để lưu mã giảm giá
  double discountValue = 0.0; // Giá trị giảm giá

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
    return total - discountValue; // Trừ giá trị giảm giá
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
  Future<void> updateAddress() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AddressUpdateScreen()), // Điều hướng đến AddressUpdateScreen
    );
  }

  // Hàm thanh toán (chỉ in ra thông báo)
  Future<void> checkout() async {
    print("Proceeding to checkout...");
    // Logic thanh toán sẽ được thêm sau
  }

  // Hàm áp dụng mã giảm giá
  Future<void> applyDiscountCode() async {
    try {
      DiscountService discountService = DiscountService();
      var response = await discountService.applyDiscountCode(discountCode);
      setState(() {
        discountValue = response['discountValue']; // Cập nhật giá trị giảm giá
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mã giảm giá đã được áp dụng!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mã giảm giá không hợp lệ!'),
          backgroundColor: Colors.red,
        ),
      );
      print("Failed to apply discount code: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ Hàng'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(child: Text('Giỏ hàng trống'))
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
                        icon: const Icon(Icons.delete),
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
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Tổng tiền:",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Jaldi',
                  ),
                ),
                Text(
                  '${calculateTotalPrice().toStringAsFixed(2)} VNĐ',
                  style: const TextStyle(
                    fontSize: 25,
                    fontFamily: 'Jaldi',
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // TextField để nhập mã giảm giá
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nhập mã giảm giá',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  discountCode = value; // Cập nhật mã giảm giá
                });
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: const Size(400, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              onPressed: applyDiscountCode, // Gọi hàm áp dụng mã giảm giá
              child: const Text(
                'Áp dụng',
                style: TextStyle(
                  fontSize: 22,
                  fontFamily: 'Jaldi',
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0FD5AF),
                      minimumSize: const Size(175, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    updateAddress(); // Gọi hàm cập nhật địa chỉ
                  },
                  child:const Text(
                    'Cập nhật địa chỉ',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Jaldi',
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0091E5),
                      minimumSize: const Size(175, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    checkout(); // Gọi hàm thanh toán
                  },
                  child: const Text(
                    'Thanh Toán',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Jaldi',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
