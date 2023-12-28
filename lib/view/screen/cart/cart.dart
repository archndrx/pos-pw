import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/components/textstyle.dart';
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
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Keranjang',
          style: TextStyles.interBold.copyWith(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFF87C47),
      ),
      body: StreamBuilder(
        stream: cartProvider.getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
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
                        int quantity = cartItem['quantity'] ?? 0;
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                product.name,
                                style: TextStyles.interBold.copyWith(
                                  fontSize: 20,
                                  color: Color(0xFF505050),
                                ),
                              ),
                              subtitle: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Rp.${NumberFormat.decimalPattern('id_ID').format(product.price)}',
                                            style: TextStyles.interRegular
                                                .copyWith(
                                              fontSize: 18,
                                              color: Color(0xFFFF0000),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              cartProvider.updateQuantity(
                                                  cartItems[index].id,
                                                  quantity - 1);
                                            },
                                            child: Image.asset(
                                              'assets/icon/minus.png',
                                              width: 25,
                                              height: 25,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 13,
                                          ),
                                          Text(
                                            quantity.toString(),
                                            style:
                                                TextStyles.interBlack.copyWith(
                                              fontSize: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 13,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              cartProvider.updateQuantity(
                                                  cartItems[index].id,
                                                  quantity + 1);
                                            },
                                            child: Image.asset(
                                              'assets/icon/plus.png',
                                              width: 25,
                                              height: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1,
                            ), // Divider di sini
                          ],
                        );
                      },
                    ),
                  ),
                  if (cartProvider.showQuantityWarning)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Kuantitas melebihi stok produk',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8D4D),
                        fixedSize: const Size(367, 72),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () async {
                        cartProvider.checkout(context);
                      },
                      child: Text(
                        'Checkout Rp.${NumberFormat.decimalPattern('id_ID').format(cartProvider.calculateTotalPrice(cartItems))}',
                        style: TextStyles.poppinsBold.copyWith(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                  child: Text(
                'Keranjang belanja kosong.',
                style: TextStyles.poppinsMedium.copyWith(fontSize: 16),
              ));
            }
          }
        },
      ),
    );
  }
}
