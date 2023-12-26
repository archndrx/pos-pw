import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:point_of_sales/components/textstyle.dart';
import 'package:point_of_sales/view/screen/history/history.dart';
import 'package:point_of_sales/view/screen/profile/profile.dart';
import 'package:point_of_sales/view/screen/sales/sales.dart';
import 'package:point_of_sales/view/screen/sales/sales_chart.dart';

class HomescreenPemilik extends StatefulWidget {
  const HomescreenPemilik({super.key});

  @override
  State<HomescreenPemilik> createState() => _HomescreenPemilikState();
}

class _HomescreenPemilikState extends State<HomescreenPemilik> {
  int _selectedIndex = 0;

  _changeTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _page = [
    SalesPage(),
    SalesChartPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: GNav(
          tabActiveBorder: Border.all(color: Color(0xFFF87C47), width: 2),
          curve: Curves.fastOutSlowIn,
          tabMargin: EdgeInsets.symmetric(vertical: 8),
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
              text: 'Laporan Penjualan',
            ),
            GButton(
              icon: Icons.graphic_eq,
              text: 'Grafik Penjualan',
            ),
            GButton(
              icon: Icons.verified_user,
              text: 'Riwayat Penjualan',
            ),
            GButton(
              icon: Icons.people,
              text: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
