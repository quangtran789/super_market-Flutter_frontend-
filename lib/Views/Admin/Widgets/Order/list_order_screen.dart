import 'package:app_supermarket/Views/Admin/Servives/order_service.dart';
import 'package:app_supermarket/Views/Admin/Widgets/Order/edit_order_screen.dart';
import 'package:app_supermarket/Views/homepage.dart';
import 'package:app_supermarket/utils/app_localizations.dart';
import 'package:flutter/material.dart';

import 'package:app_supermarket/models/order.dart';

class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late Future<List<Order>> _orders;

  @override
  void initState() {
    super.initState();
    // Gọi API lấy danh sách đơn hàng
    _orders = OrderService().getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.get('orderList') ??
            "Danh Sách Đơn Hàng"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const Homepage()),
              (route) => false,
            );
          },
        ),
      ),
      body: FutureBuilder<List<Order>>(
        future: _orders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có đơn hàng nào.'));
          } else {
            List<Order> orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                Order order = orders[index];
                return ListTile(
                  title: Text(
                      '${AppLocalizations.of(context)?.get('order')} ${order.id}'),
                  subtitle: Text(
                      '${AppLocalizations.of(context)?.get('totalAmount')}\:  ${order.totalAmount.toStringAsFixed(3)} VND'),
                  trailing: Text(order.status),
                  onTap: () {
                    // Truyền đúng orderId vào UpdateOrderStatusPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateOrderStatusPage(
                          orderId: order
                              .id, // Truyền orderId thực tế từ đối tượng order
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
