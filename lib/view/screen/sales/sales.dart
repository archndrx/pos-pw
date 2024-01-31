// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/components/textstyle.dart';
import 'package:point_of_sales/model/sales_model.dart';
import 'package:point_of_sales/view/screen/sales/sales_provider.dart';
import 'package:provider/provider.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Laporan Penjualan",
          style: TextStyles.interBold.copyWith(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFF87C47),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 11,
            ),
            child: Container(
              width: 155, height: 44,
              decoration: BoxDecoration(
                color: Color(0xFFF87C47), // Warna latar belakang default
                borderRadius: BorderRadius.circular(
                    5.0), // Sesuaikan nilai radius sesuai keinginan Anda
              ),
              // Ganti dengan warna yang diinginkan
              child: Consumer<SalesProvider>(
                builder: (context, salesProvider, _) => DropdownButton<String>(
                  style: TextStyles.poppinsBold.copyWith(
                    fontSize: 18,
                  ),
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_downward_outlined,
                    color: Colors.white, // Add this
                  ),
                  underline: SizedBox(),
                  dropdownColor: Color(0xFFF87C47),
                  padding: EdgeInsets.only(
                    left: 13,
                    right: 13,
                  ),
                  value: salesProvider.filter,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      // Update the filter and reload data
                      salesProvider.updateFilter(newValue);
                    }
                  },
                  items: [
                    'Hari ini',
                    'Minggu ini',
                    'Bulan ini',
                    'Tahun ini',
                    'Semua'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: Future.wait([
                Provider.of<SalesProvider>(context).getTotalSales(),
                Provider.of<SalesProvider>(context).getTotalCheckoutCount(),
                Provider.of<SalesProvider>(context).getTopSellingProducts(),
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final List<dynamic> results = snapshot.data ?? [];

                  if (results.length < 3) {
                    return const Text('Insufficient data available');
                  }

                  final int totalSales = results[0] ?? 0;
                  final int totalCheckoutCount = results[1] ?? 0;
                  final List<SaleModel?> topSellingProducts =
                      results[2] as List<SaleModel?>;

                  if (topSellingProducts == null) {
                    return const Text('Top selling products data is null');
                  }
                  // Filter out null values from the list
                  final List<SaleModel> filteredSales = topSellingProducts
                      .where((sale) => sale != null)
                      .cast<SaleModel>()
                      .toList();
                  if (filteredSales.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 11,
                            right: 11,
                          ),
                          child: Row(
                            children: [
                              Flexible(
                                child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF87C47),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Total Pesanan: ',
                                          style:
                                              TextStyles.poppinsBold.copyWith(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          totalCheckoutCount.toString(),
                                          style: TextStyles.interBold.copyWith(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 21,
                              ),
                              Flexible(
                                child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF87C47),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Total Penjualan: ',
                                          style:
                                              TextStyles.poppinsBold.copyWith(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          'Rp.${NumberFormat.decimalPattern('id_ID').format(totalSales)}',
                                          style: TextStyles.interBold.copyWith(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 28,
                            left: 13,
                            bottom: 28,
                          ),
                          child: Text(
                            'Produk yang terjual:',
                            style: TextStyles.interBold.copyWith(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: ListView.builder(
                              itemCount: filteredSales.length,
                              itemBuilder: (context, index) {
                                final sale = filteredSales[index];
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.7),
                                                spreadRadius: 2,
                                                blurRadius: 10,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.network(
                                              sale.products[0].file,
                                              width: 122,
                                              height: 111,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              sale.products[0].name,
                                              style:
                                                  TextStyles.interBold.copyWith(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "Terjual sebanyak ${sale.quantity[sale.products[0].id]}x",
                                              style: TextStyles.poppinsMedium
                                                  .copyWith(
                                                fontSize: 16,
                                                color: Color(0xFFB6B6B6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                        child: Text(
                      'Belum ada Barang Terjual',
                      style: TextStyles.poppinsMedium.copyWith(fontSize: 16),
                    ));
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
