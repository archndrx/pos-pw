import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/components/textstyle.dart';
import 'package:point_of_sales/model/product_model.dart';
import 'package:point_of_sales/view/screen/cart/cart.dart';
import 'package:point_of_sales/view/screen/cart/cart_view_model.dart';
import 'package:point_of_sales/view/screen/product/product_view_model.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String searchQuery = '';
  Timer? _debounceTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF87C47),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Produk',
          style: TextStyles.interBold.copyWith(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
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
                      return Container(); // Tampilkan indikator loading jika sedang menunggu
                    } else if (snapshot.hasData) {
                      final itemCount = snapshot.data;
                      return Positioned(
                        bottom: 20,
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 11,
            ),
            child: TextField(
              onChanged: (value) {
                // Hapus timer sebelumnya untuk mencegah pemanggilan yang berlebihan
                if (_debounceTimer != null) {
                  _debounceTimer!.cancel();
                }
                // Membuat timer baru untuk debounce
                _debounceTimer = Timer(const Duration(milliseconds: 300), () {
                  setState(() {
                    searchQuery = value;
                  });
                });
              },
              decoration: InputDecoration(
                labelText: 'Cari Produk...',
                labelStyle: TextStyles.interRegular.copyWith(
                  fontSize: 16,
                  color: const Color(0xFF9CA3AF),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, _) {
                return StreamBuilder<List<ProductModel>>(
                  stream: provider.getProduct(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      final products = snapshot.data!;
                      final filteredProducts = products
                          .where((product) => product.name
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()))
                          .toList();

                      if (filteredProducts.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Belum ada data produk",
                                style: TextStyles.poppinsMedium
                                    .copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        padding:
                            EdgeInsets.only(left: 11, right: 11, bottom: 11),
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 19,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final productModel = filteredProducts[index];
                          bool isOutOfStock = productModel.stock == 0;

                          return Container(
                            height: 280,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isOutOfStock
                                  ? const Color(0xFFF1F1F1).withOpacity(0.7)
                                  : const Color(0xFFF1F1F1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 200,
                                  height: 183,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(6),
                                      bottomRight: Radius.circular(6),
                                    ),
                                    child: isOutOfStock
                                        ? Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Image.network(
                                                productModel.file,
                                                fit: BoxFit
                                                    .cover, // Atur BoxFit sesuai kebutuhan Anda
                                              ),
                                              ClipRRect(
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaX: 5, sigmaY: 5),
                                                  child: Center(
                                                    child: Text(
                                                      'Stok Habis',
                                                      style: TextStyles
                                                          .poppinsBold
                                                          .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Image.network(
                                            productModel.file,
                                            fit: BoxFit
                                                .cover, // Atur BoxFit sesuai kebutuhan Anda
                                          ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5,
                                    right: 9,
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            productModel.name,
                                            style: TextStyles.interBold
                                                .copyWith(fontSize: 14),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'Rp.${NumberFormat.decimalPattern('id_ID').format(productModel.price)}',
                                            style: TextStyles.interRegular
                                                .copyWith(
                                              fontSize: 13,
                                              color: isOutOfStock
                                                  ? Colors.black
                                                  : const Color(0xFFFF0000),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            'Stok : ${productModel.stock}',
                                            style: TextStyles.poppinsMedium
                                                .copyWith(
                                              fontSize: 12,
                                              color: isOutOfStock
                                                  ? Colors.black
                                                  : const Color.fromARGB(
                                                      255, 157, 155, 155),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          if (!isOutOfStock) {
                                            Provider.of<CartProvider>(context,
                                                    listen: false)
                                                .addToCart(productModel);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Produk ditambahkan ke keranjang'),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text('Stok produk habis'),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                          }
                                        },
                                        child: isOutOfStock
                                            ? Container()
                                            : Image.asset(
                                                'assets/icon/addProduct.png',
                                                width: 40,
                                                height: 40,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 8),
                            Text(
                              "Memuat data...",
                              style: TextStyles.poppinsMedium
                                  .copyWith(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
