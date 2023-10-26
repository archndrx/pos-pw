import 'package:flutter/material.dart';
import 'package:point_of_sales/view/screen/product/product.dart';
import 'package:point_of_sales/view/screen/profile/profile.dart';
import 'package:point_of_sales/view/screen/sales/sales.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _page = [
    const ProductScreen(),
    const SalesScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => _changeTab(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Product',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_shopping_cart,
              ),
              label: 'Sales'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
              ),
              label: 'Profile'),
        ],
      ),
    );
  }
}
