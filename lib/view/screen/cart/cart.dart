import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/model/product_model.dart';
import 'package:point_of_sales/view/screen/cart/cart_view_model.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: StreamBuilder(
        stream: cartProvider.getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            if (snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
              final cartItems = snapshot.data!.docs;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem =
                            cartItems[index].data() as Map<String, dynamic>;
                        final product = ProductModel.fromMap(cartItem);

                        return ListTile(
                          title: Text(product.name),
                          subtitle: Text(
                              'Harga: Rp.${NumberFormat.decimalPattern('id_ID').format(product.price)}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              cartProvider.removeFromCart(cartItems[index].id);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        cartProvider.checkout();
                      },
                      child: Text(
                        'Checkout Rp.${NumberFormat.decimalPattern('id_ID').format(cartProvider.calculateTotalPrice(cartItems))}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text('Keranjang belanja kosong.'));
            }
          }
        },
      ),
    );
  }
}
