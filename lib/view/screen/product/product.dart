import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/model/product_model.dart';
import 'package:point_of_sales/view/screen/cart/cart.dart';
import 'package:point_of_sales/view/screen/cart/cart_view_model.dart';
import 'package:point_of_sales/view/screen/product/add_product.dart';
import 'package:point_of_sales/view/screen/product/edit_product.dart';
import 'package:point_of_sales/view/screen/product/product_view_model.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    // final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Product'),
        actions: [
          Consumer<CartProvider>(builder: (context, cartProvider, _) {
            return IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartPage(),
                  ),
                );
              },
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart),
                  if (cartProvider.itemCount > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          cartProvider.itemCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          return StreamBuilder<List<ProductModel>>(
            stream: provider.getProduct(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final product = snapshot.data!;
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: product.length,
                  itemBuilder: (context, index) {
                    final productModel = product[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProduct(data: productModel),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        // margin: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 240, 227, 227),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.file(
                                File(productModel.file.toString()),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      productModel.name,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Rp.${NumberFormat.decimalPattern('id_ID').format(productModel.price)}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Provider.of<CartProvider>(context,
                                            listen: false)
                                        .addToCart(productModel);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Produk ditambahkan ke keranjang'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  child: const Icon(Icons.add_shopping_cart),
                                ),
                                GestureDetector(
                                  child: const Icon(
                                    Icons.delete,
                                    size: 25,
                                  ),
                                  onTap: () {
                                    provider.deleteData(productModel.id!);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Belum ada data"),
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => const AddProduct()),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
        child: const Text(
          'Add Product',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
