import 'package:app_supermarket/Views/Cart/Screens/cart_screen.dart';
import 'package:app_supermarket/Views/Home/Screens/home.dart';
import 'package:app_supermarket/Views/Profile/profile_screen.dart';
import 'package:app_supermarket/utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
// Import AppLocalizations

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;

  final _items = [
    SalomonBottomBarItem(
      icon: const Icon(Icons.home),
      title: Builder(
        builder: (context) {
          return Text(
            AppLocalizations.of(context)?.get('home') ??
                'Danh sách danh mục', // Sử dụng bản dịch
            style: const TextStyle(fontSize: 16),
          );
        },
      ),
      selectedColor: const Color(0xff0FD5AF),
    ),
    SalomonBottomBarItem(
      icon: const Icon(
        Icons.shopping_bag,
      ),
      title: Builder(
        builder: (context) {
          return Text(
            AppLocalizations.of(context)?.get('cart') ??
                'Giỏ hàng', // Sử dụng bản dịch
            style: const TextStyle(fontSize: 16),
          );
        },
      ),
      selectedColor: const Color(0xff0FD5AF),
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.person),
      title: Builder(
        builder: (context) {
          return Text(
            AppLocalizations.of(context)?.get('personal') ??
                'Cá nhân', // Sử dụng bản dịch
            style: const TextStyle(fontSize: 16),
          );
        },
      ),
      selectedColor: const Color(0xff0FD5AF),
    ),
  ];

  final _screens = [
    const Home(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Card(
        elevation: 6,
        margin: const EdgeInsets.all(13.0),
        child: SalomonBottomBar(
          items: _items,
          currentIndex: _currentIndex,
          onTap: (index) => setState(
            () {
              _currentIndex = index;
            },
          ),
        ),
      ),
    );
  }
}
