import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:point_of_sales/components/textstyle.dart';
import 'package:point_of_sales/view/screen/product/product.dart';
import 'package:point_of_sales/view/screen/profile/profile.dart';

class HomescreenKasir extends StatefulWidget {
  const HomescreenKasir({super.key});

  @override
  State<HomescreenKasir> createState() => _HomescreenKasirState();
}

class _HomescreenKasirState extends State<HomescreenKasir> {
  int _selectedIndex = 0;

  _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _page = [
    ProductScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page[_selectedIndex],
      bottomNavigationBar: GNav(
        tabMargin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        gap: 8,
        tabActiveBorder: Border.all(color: Color(0xFFF87C47), width: 2),
        curve: Curves.fastOutSlowIn,
        hoverColor: const Color(0xFFF87C47),
        color: Color.fromARGB(255, 181, 179, 179),
        activeColor: Color(0xFFF87C47).withOpacity(0.8),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        tabBackgroundColor: Color(0xFFF87C47).withOpacity(0.1),
        textStyle: TextStyles.poppinsMedium.copyWith(
          color: Color(0xFFF87C47).withOpacity(0.8),
        ),
        selectedIndex: _selectedIndex,
        onTabChange: (index) => _changeTab(index),
        tabs: [
          GButton(
            icon: Icons.home,
            text: 'Produk',
          ),
          GButton(
            icon: Icons.people,
            text: 'Profil',
          ),
        ],
      ),
    );
  }
}
