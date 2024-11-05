import 'package:app_supermarket/Views/Admin/Servives/discount_service.dart';
import 'package:app_supermarket/Views/Admin/Servives/order_service.dart';
import 'package:app_supermarket/Views/Cart/Widgets/address_update_screen.dart';
import 'package:app_supermarket/models/order.dart';
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

  // Hàm checkout với kiểm tra địa chỉ trước khi đặt hàng
  Future<void> checkout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      String? address = prefs.getString('address');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng đăng nhập trước khi thanh toán!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (address == null || address.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng cập nhật địa chỉ trước khi thanh toán!'),
            backgroundColor: Colors.orange,
          ),
        );
        updateAddress();
        return;
      }

      List<OrderItem> orderItems = cartItems.map((cartItem) {
        return OrderItem(
          productId: cartItem.productId,
          quantity: cartItem.quantity,
          price: cartItem.product.price,
        );
      }).toList();

      OrderService orderService = OrderService();
      bool orderCreated = await orderService.createOrder(
          token, orderItems, address, discountCode, discountValue);

      if (orderCreated) {
        CartService cartService = CartService();
        await cartService.clearCart(); // Xóa toàn bộ giỏ hàng

        setState(() {
          cartItems.clear(); // Cập nhật lại UI sau khi giỏ hàng được xóa
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đặt hàng thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đặt hàng thất bại!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print("Failed to create order: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Có lỗi xảy ra khi đặt hàng!'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
      setState(() {
        discountValue = 0.0; // Reset discount value if code fails
      });
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
                          await removeItemFromCart(item.id);
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
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: updateAddress, // Gọi hàm cập nhật địa chỉ
                  child: const Text(
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
                    backgroundColor: const Color(0xffFF744D),
                    minimumSize: const Size(175, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: checkout, // Gọi hàm thanh toán
                  child: const Text(
                    'Thanh toán',
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
