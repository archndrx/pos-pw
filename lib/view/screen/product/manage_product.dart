import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/components/textstyle.dart';
import 'package:point_of_sales/model/product_model.dart';
import 'package:point_of_sales/view/screen/product/add_product.dart';
import 'package:point_of_sales/view/screen/product/edit_product.dart';
import 'package:point_of_sales/view/screen/product/product_view_model.dart';
import 'package:provider/provider.dart';

class Manageproduct extends StatefulWidget {
  const Manageproduct({super.key});

  @override
  State<Manageproduct> createState() => _ManageproductState();
}

class _ManageproductState extends State<Manageproduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF87C47),
        title: Text(
          'Kelola Produk',
          style: TextStyles.interBold.copyWith(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const AddProduct()),
                ),
              );
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Consumer<ProductProvider>(
          builder: (context, provider, _) {
            return StreamBuilder<List<ProductModel>>(
              stream: provider.getProduct(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final product = snapshot.data!;
                  return Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
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
                          itemCount: product.length,
                          itemBuilder: (context, index) {
                            final productModel = product[index];
                            bool isOutOfStock = productModel.stock == 0;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditProduct(productData: productModel),
                                  ),
                                );
                              },
                              child: Container(
                                height: 280,
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xFFF1F1F1),
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
                                        child: Image.network(
                                          productModel
                                              .file, // Load image from Firebase Storage
                                          fit: BoxFit.cover,
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
                                                    .copyWith(fontSize: 13),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                'Rp.${NumberFormat.decimalPattern('id_ID').format(productModel.price)}',
                                                style: TextStyles.interRegular
                                                    .copyWith(
                                                  fontSize: 13,
                                                  color:
                                                      const Color(0xFFFF0000),
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
                                                            ? Colors.red
                                                            : const Color
                                                                .fromARGB(255,
                                                                157, 155, 155)),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            child: Image.asset(
                                              'assets/icon/delete.png',
                                              width: 40,
                                              height: 40,
                                            ),
                                            onTap: () {
                                              provider
                                                  .deleteData(productModel.id!);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Belum ada data produk",
                          style:
                              TextStyles.poppinsMedium.copyWith(fontSize: 16),
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
    );
  }
}
