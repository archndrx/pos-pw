import 'package:flutter/material.dart';
import 'package:point_of_sales/view/screen/auth/auth_tree.dart';
import 'package:point_of_sales/view/screen/auth/auth_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:point_of_sales/view/screen/cart/cart_view_model.dart';
import 'package:point_of_sales/view/screen/product/product_view_model.dart';
import 'package:point_of_sales/view/screen/sales/sales_provider.dart';
import 'package:point_of_sales/view/screen/user/user_provider.dart';
import 'package:provider/provider.dart';

Future main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SalesProvider(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthTree(),
      ),
    );
  }
}
