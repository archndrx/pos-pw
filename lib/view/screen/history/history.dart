import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/components/textstyle.dart';
import 'package:point_of_sales/model/sales_model.dart';
import 'package:point_of_sales/view/screen/history/history_detail_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Riwayat Penjualan',
            style: TextStyles.interBold.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFFF87C47),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('sales')
              .doc(
                  'history') // Gunakan 'history' sebagai ID dokumen untuk koleksi global
              .collection(
                  'transactions') // atau gunakan 'transactions' sebagai subkoleksi jika diinginkan
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const CircularProgressIndicator());
            } else if (snapshot.hasData) {
              List<SaleModel> sales = snapshot.data!.docs.map((doc) {
                final data = doc.data();
                return SaleModel.fromMap(data);
              }).toList();

              if (sales.isEmpty) {
                return Center(
                  child: Text(
                    'Belum ada riwayat penjualan.',
                    style: TextStyles.poppinsMedium.copyWith(fontSize: 16),
                  ),
                );
              }
              return ListView.builder(
                itemCount: sales.length,
                itemBuilder: (context, index) {
                  final sale = sales[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        'Total: Rp.${NumberFormat.decimalPattern('id_ID').format(sale.total)}',
                        style: TextStyles.interBold.copyWith(
                          fontSize: 16,
                          color: Color(0xFF505050),
                        ),
                      ),
                      subtitle: Text(
                        'Waktu: ${DateFormat('dd-MM-yyyy HH:mm').format(sale.timestamp)}',
                        style: TextStyles.poppinsMedium.copyWith(
                          fontSize: 14,
                          color: Color(0xFFB6B6B6),
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SaleDetailPage(sale: sale),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return Text('Error: ${snapshot.error}');
            }
          },
        ));
  }
}
