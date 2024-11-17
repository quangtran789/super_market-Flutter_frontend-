import 'package:app_supermarket/Views/Admin/Servives/discount_service.dart';
import 'package:app_supermarket/Views/Admin/Servives/order_service.dart';
import 'package:app_supermarket/Views/Cart/Widgets/address_update_screen.dart';
import 'package:app_supermarket/models/order.dart';
import 'package:app_supermarket/utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app_supermarket/models/cart.dart'; // Nhớ import CartModel ở đây
import 'package:app_supermarket/Views/Cart/Services/cart_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pay/pay.dart';

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
          SnackBar(
            content: Text(AppLocalizations.of(context)
                    ?.get('pleaseUpdateAddressBeforeCheckout') ??
                'Vui lòng cập nhật địa chỉ trước khi thanh toán!'),
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
          imageUrl: cartItem.product.imageUrl,
          name: cartItem.product.name,
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
          SnackBar(
            content: Text(
                AppLocalizations.of(context)?.get('orderSuccessful') ??
                    'Đặt hàng thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.get('orderFailed') ??
                'Đặt hàng thất bại!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      print("Failed to create order: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context)?.get('errorWhilePlacingOrder') ??
                  'Có lỗi xảy ra khi đặt hàng!'),
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
        SnackBar(
          content: Text(AppLocalizations.of(context)?.get('discountApplied') ??
              'Mã giảm giá đã được áp dụng!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      setState(() {
        discountValue = 0.0; // Reset discount value if code fails
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              AppLocalizations.of(context)?.get('invalidDiscountCode') ??
                  'Mã giảm giá không hợp lệ!'),
          backgroundColor: Colors.red,
        ),
      );
      print("Failed to apply discount code: $error");
    }
  }

  // Hàm cập nhật số lượng sản phẩm trong giỏ hàng
  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    try {
      CartService cartService = CartService();
      await cartService.updateCartItemQuantity(cartItemId, newQuantity);
      fetchCartItems(); // Làm mới giỏ hàng sau khi cập nhật
    } catch (error) {
      print("Failed to update quantity: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Có lỗi xảy ra khi cập nhật số lượng!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/shopping-bag.png', // Đường dẫn tới GIF
              height: 40, // Điều chỉnh kích thước phù hợp
              width: 40,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(AppLocalizations.of(context)?.get('cart') ?? 'Giỏ Hàng'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)?.get('emptyCart') ??
                            'Giỏ hàng trống',
                        style: const TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w400,
                            fontSize: 25),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Image.asset(
                        'assets/images/bag.png', // Hình ảnh bạn muốn thêm
                        width: 150, // Chiếm hết chiều rộng màn hình
                        height: 150, // Điều chỉnh chiều cao tùy ý
                        fit: BoxFit.cover, // Giúp hình ảnh không bị biến dạng
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            8.0), // Set the radius for the corners
                        child: Image.network(
                          item.product.imageUrl ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(item.product.name),
                      subtitle: Text(
                        '${AppLocalizations.of(context)?.get('quantity')}: ${item.quantity} \n${AppLocalizations.of(context)?.get('price')}: ${item.product.price.toStringAsFixed(3)} VNĐ',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Nút giảm số lượng
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () async {
                              if (item.quantity > 1) {
                                // Kiểm tra số lượng sản phẩm không giảm dưới 1
                                await updateQuantity(
                                    item.id, item.quantity - 1);
                              }
                            },
                          ),
                          // Nút tăng số lượng
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () async {
                              await updateQuantity(item.id, item.quantity + 1);
                            },
                          ),
                          // Nút xóa sản phẩm khỏi giỏ hàng
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await removeItemFromCart(item.id);
                            },
                          ),
                        ],
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
                Text(
                  AppLocalizations.of(context)?.get('totalAmount') ??
                      "Tổng tiền:",
                  style: const TextStyle(
                    fontSize: 25,
                    fontFamily: 'Jaldi',
                  ),
                ),
                Text(
                  '${calculateTotalPrice().toStringAsFixed(3)} VNĐ',
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
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context)?.get('enterDiscountCode') ??
                        'Nhập mã giảm giá',
                border: const OutlineInputBorder(),
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
              child: Text(
                AppLocalizations.of(context)?.get('apply') ?? 'Áp dụng',
                style: const TextStyle(
                  fontSize: 17,
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
                  child: Text(
                    AppLocalizations.of(context)?.get('updateAddress') ??
                        'Cập nhật địa chỉ',
                    style: const TextStyle(
                      fontSize: 17,
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
                  child: Text(
                    AppLocalizations.of(context)?.get('shipping') ??
                        'Giao hàng',
                    style: const TextStyle(
                      fontSize: 17,
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
