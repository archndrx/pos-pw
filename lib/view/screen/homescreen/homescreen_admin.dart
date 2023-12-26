import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:point_of_sales/components/textstyle.dart';
import 'package:point_of_sales/view/screen/product/manage_product.dart';
import 'package:point_of_sales/view/screen/profile/profile.dart';
import 'package:point_of_sales/view/screen/user/user.dart';

class HomescreenAdmin extends StatefulWidget {
  const HomescreenAdmin({super.key});

  @override
  State<HomescreenAdmin> createState() => _HomescreenAdminState();
}

class _HomescreenAdminState extends State<HomescreenAdmin> {
  int _selectedIndex = 0;

  _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _page = [
    Manageproduct(),
    const UserPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page[_selectedIndex],
      bottomNavigationBar: GNav(
        gap: 8,
        tabActiveBorder: Border.all(color: Color(0xFFF87C47), width: 2),
        curve: Curves.fastOutSlowIn,
        tabMargin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
            icon: Icons.production_quantity_limits,
            text: 'Kelola Produk',
          ),
          GButton(
            icon: Icons.verified_user,
            text: 'Kelola user',
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
