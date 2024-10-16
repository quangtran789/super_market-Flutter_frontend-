import 'package:app_supermarket/Views/Admin/Widgets/Category/category_list_screen.dart';
import 'package:app_supermarket/Views/Admin/Widgets/Product/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigatorCotroller());
    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.category), label: 'Danh mục'),
            NavigationDestination(
                icon: Icon(Icons.production_quantity_limits),
                label: 'Sản phẩm'),
            NavigationDestination(
                icon: Icon(Icons.shopping_bag_rounded), label: 'Đơn hàng'),
            NavigationDestination(icon: Icon(Icons.settings), label: 'Cài đặt'),
          ],
        ),
      ),
    );
  }
}

class NavigatorCotroller extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const CategoryListScreen(),
    const ProductListScreen(),
    Container(color: Colors.blue),
    Container(color: Colors.orange),
  ];
}
