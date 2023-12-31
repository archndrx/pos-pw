import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sales/components/textstyle.dart';
import 'package:point_of_sales/model/sales_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReceiptPage extends StatelessWidget {
  final SaleModel saleData;

  const ReceiptPage({Key? key, required this.saleData}) : super(key: key);
  Future<void> _printPdf() async {
    final pdf = pw.Document();

    final font = await rootBundle.load("fonts/Inter-Regular.ttf");
    final fontBold = await rootBundle.load("fonts/Inter-Bold.ttf");
    final ttf = pw.Font.ttf(font);
    final ttfBold = pw.Font.ttf(fontBold);
    // Add content to PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'Thank you for your purchase!',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    font: ttfBold,
                  ),
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Receipt Details:',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    font: ttfBold,
                  )),
              pw.SizedBox(height: 8),
              pw.Text(
                'Total: Rp.${NumberFormat.decimalPattern('id_ID').format(saleData.total)}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: ttfBold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text('Products:',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    font: ttfBold,
                  )),
              pw.SizedBox(height: 8),
              // Use ListView.builder to display product details
              for (final product in saleData.products)
                pw.Container(
                  margin: pw.EdgeInsets.symmetric(vertical: 8),
                  child: pw.Row(
                    children: [
                      pw.Text(
                          '${product.name} (Qty: ${saleData.quantity[product.id] ?? 0})',
                          style: pw.TextStyle(font: ttf)),
                      pw.Spacer(),
                      pw.Text(
                          'Subtotal: Rp.${NumberFormat.decimalPattern('id_ID').format(product.price * (saleData.quantity[product.id] ?? 0))}',
                          style: pw.TextStyle(font: ttf)),
                    ],
                  ),
                ),
              pw.Divider(),
              pw.Text(
                'Total items: ${saleData.products.length}',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  font: ttfBold,
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save or print the PDF
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color(0xFFF87C47),
        title: Text(
          'Bukti Pembayaran',
          style: TextStyles.interBold.copyWith(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () {
              _printPdf();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Thank you for your purchase!',
                style: TextStyles.interBold.copyWith(
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Receipt Details:',
              style: TextStyles.interBold.copyWith(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Total: Rp.${NumberFormat.decimalPattern('id_ID').format(saleData.total)}',
              style: TextStyles.interBold.copyWith(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Products:',
              style: TextStyles.interBold.copyWith(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            // Use ListView.builder to display roduct details
            for (final product in saleData.products)
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Text(
                      '${product.name} (Qty: ${saleData.quantity[product.id] ?? 0})',
                      style: TextStyles.interRegular.copyWith(fontSize: 14),
                    ),
                    Spacer(),
                    Text(
                      'Subtotal: Rp.${NumberFormat.decimalPattern('id_ID').format(product.price * (saleData.quantity[product.id] ?? 0))}',
                      style: TextStyles.interRegular.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
            Divider(),
            Text(
              'Total items: ${saleData.products.length}',
              style: TextStyles.interBold.copyWith(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
