import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/model/sales_model.dart';

class SaleDetailPage extends StatelessWidget {
  final SaleModel sale;

  const SaleDetailPage({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale Detail'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
                'Total: Rp.${NumberFormat.decimalPattern('id_ID').format(sale.total)}'),
            subtitle: Text(
                'Waktu: ${DateFormat('dd-MM-yyyy HH:mm').format(sale.timestamp)}'),
          ),
          const Divider(),
          const Text('Item yang dibeli:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Column(
            children: sale.products.map((product) {
              return ListTile(
                title: Text(product.name),
                subtitle: Text(
                    'Harga: Rp.${NumberFormat.decimalPattern('id_ID').format(product.price)}'),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
