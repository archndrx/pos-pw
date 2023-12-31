import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/components/textstyle.dart';
import 'package:point_of_sales/model/sales_model.dart';

class SaleDetailPage extends StatelessWidget {
  final SaleModel sale;

  const SaleDetailPage({Key? key, required this.sale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Detail Riwayat Penjualan',
          style: TextStyles.interBold.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFF87C47),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ListTile(
            title: Text(
              'Total Penjualan : Rp.${NumberFormat.decimalPattern('id_ID').format(sale.total)}',
              style: TextStyles.interBold.copyWith(
                fontSize: 18,
                color: Color(0xFF505050),
              ),
            ),
            subtitle: Text(
              'Waktu: ${DateFormat('dd-MM-yyyy HH:mm').format(sale.timestamp)}',
              style: TextStyles.poppinsMedium.copyWith(
                fontSize: 16,
                color: Color(0xFFB6B6B6),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: Text(
              'Produk yang terjual :',
              style: TextStyles.interBold.copyWith(
                fontSize: 16,
                color: Color(0xFF505050),
              ),
            ),
          ),
          Column(
            children: sale.products.map((product) {
              return Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Container(
                          width: 125,
                          height: 111,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              product.file,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: TextStyles.interBold
                                        .copyWith(fontSize: 16),
                                  ),
                                  Text(
                                    'Harga: Rp.${NumberFormat.decimalPattern('id_ID').format(product.price)}',
                                    style: TextStyles.poppinsMedium.copyWith(
                                        fontSize: 16, color: Color(0xFFB6B6B6)),
                                  ),
                                ],
                              ),
                              Spacer(), // Spacer to push 'x${sale.quantity[product.id]}' to the right
                              Text(
                                'x${sale.quantity[product.id]}',
                                style:
                                    TextStyles.interBold.copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 10,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
