import 'package:app_supermarket/Views/Admin/Widgets/Category/category_list_screen.dart';
import 'package:app_supermarket/Views/Admin/Widgets/DiscountCode/discount_code_list_screen.dart';
import 'package:app_supermarket/Views/Admin/Widgets/Order/list_order_screen.dart';
import 'package:app_supermarket/Views/Admin/Widgets/Product/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_supermarket/utils/app_localizations.dart';

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
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.category),
              label:
                  AppLocalizations.of(context)?.get('category') ?? 'Danh mục',
            ),
            NavigationDestination(
              icon: const Icon(Icons.store),
              label: AppLocalizations.of(context)?.get('product') ?? 'Sản phẩm',
            ),
            NavigationDestination(
              icon: Icon(Icons.discount),
              label: AppLocalizations.of(context)?.get('discountCode') ??
                  'Mã giảm giá',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt),
              label: AppLocalizations.of(context)?.get('order') ?? 'Đơn hàng',
            ),
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
    DiscountCodeListScreen(),
    OrderListScreen()
  ];
}
