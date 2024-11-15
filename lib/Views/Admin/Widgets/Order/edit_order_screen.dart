import 'package:flutter/material.dart';
import 'package:app_supermarket/models/order.dart';
import 'package:app_supermarket/Views/Admin/Servives/order_service.dart';

class UpdateOrderStatusPage extends StatefulWidget {
  final String orderId;

  UpdateOrderStatusPage({required this.orderId});

  @override
  _UpdateOrderStatusPageState createState() => _UpdateOrderStatusPageState();
}

class _UpdateOrderStatusPageState extends State<UpdateOrderStatusPage> {
  String? _selectedStatus;
  Order? _order;

  final List<String> _statuses = [
    'chưa giải quyết',
    'xác nhận',
    'đã vận chuyển',
    'đã giao hàng',
    'đã hủy bỏ'
  ];

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  Future<void> _fetchOrderDetails() async {
    try {
      List<Order> orders = await OrderService().getAllOrders();
      _order = orders.firstWhere((order) => order.id == widget.orderId);
      setState(() {});
    } catch (e) {
      print('Error fetching order details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật trạng thái đơn hàng'),
      ),
      body: _order == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Đơn hàng: ${_order!.id}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text('Sản phẩm trong đơn hàng:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _order!.items.length,
                      itemBuilder: (context, index) {
                        final item = _order!.items[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          child: ListTile(
                            leading: item.imageUrl.isNotEmpty
                                ? Image.network(item.imageUrl,
                                    width: 50, height: 50, fit: BoxFit.cover)
                                : Icon(Icons.image, size: 50),
                            title: Text(item.name), // Hiển thị tên sản phẩm
                            subtitle: Text(
                                'Số lượng: ${item.quantity}, Giá: ${item.price}'),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Chọn trạng thái mới:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: _selectedStatus,
                    hint: Text('Chọn trạng thái'),
                    isExpanded: true,
                    items: _statuses
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        minimumSize: const Size(400, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: _selectedStatus == null
                        ? null
                        : () async {
                            if (_selectedStatus != null) {
                              bool success = await OrderService()
                                  .updateOrderStatus(
                                      widget.orderId, _selectedStatus!);
                              if (success) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Cập nhật thành công'),
                                  backgroundColor: Colors.green,
                                ));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text('Cập nhật thất bại'),
                                  backgroundColor: Colors.red,
                                ));
                              }
                            }
                          },
                    child: Text(
                      'Cập nhật trạng thái',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Jaldi',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
