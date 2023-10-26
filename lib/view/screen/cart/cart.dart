import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/view/screen/cart/cart_view_model.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: cartProvider.items.isEmpty
          ? Center(
              child: const Text('Keranjang belanja kosong'),
            )
          : ListView.builder(
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final productModel = cartProvider.items[index];
                return ListTile(
                  title: Text(productModel.name),
                  subtitle: Text(
                      'Harga: Rp.${NumberFormat.decimalPattern('id_ID').format(productModel.price)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_shopping_cart),
                    onPressed: () {
                      cartProvider.removeFromCart(productModel);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          cartProvider.clearCart();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Keranjang belanja telah dikosongkan'),
            duration: Duration(seconds: 2),
          ));
        },
        child: const Text('Kosongkan Keranjang'),
      ),
    );
  }
}
