import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/model/sales_model.dart';
import 'package:point_of_sales/view/screen/history/history_detail_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
        appBar: AppBar(
          title: const Text('History'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('sales')
              .doc(user!.uid)
              .collection('history')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              List<SaleModel> sales = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return SaleModel.fromMap(data);
              }).toList();

              // Urutkan data penjualan berdasarkan timestamp secara ascending
              sales.sort((a, b) => b.timestamp.compareTo(a.timestamp));

              if (sales.isEmpty) {
                return const Center(
                    child: Text('Belum ada riwayat penjualan.'));
              }

              return ListView.builder(
                itemCount: sales.length,
                itemBuilder: (context, index) {
                  final sale = sales[index];
                  return ListTile(
                    title: Text(
                        'Total: Rp.${NumberFormat.decimalPattern('id_ID').format(sale.total)}'),
                    subtitle: Text(
                        'Waktu: ${DateFormat('dd-MM-yyyy HH:mm').format(sale.timestamp)}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SaleDetailPage(sale: sale),
                        ),
                      );
                    },
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
