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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Product'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_cart),
              ),
              Consumer<CartProvider>(builder: (context, cartProvider, _) {
                return FutureBuilder<int>(
                  future: cartProvider.getCartItemCount(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Tampilkan indikator loading jika sedang menunggu
                    } else if (snapshot.hasData) {
                      final itemCount = snapshot.data;
                      return Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            itemCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              }),
            ],
          ),
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
                                File(
                                  productModel.file.toString(),
                                ),
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
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
