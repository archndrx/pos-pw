import 'package:flutter/material.dart';
import 'package:point_of_sales/components/textstyle.dart';
import 'package:point_of_sales/model/sales_model.dart';
import 'package:point_of_sales/view/screen/receipt/receipt_page.dart';

class SuccessPage extends StatelessWidget {
  final SaleModel saleData;
  const SuccessPage({Key? key, required this.saleData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 2),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ReceiptPage(saleData: saleData),
          ),
        );
      },
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/success.png',
              width: 148,
              height: 146,
            ),
            SizedBox(
              height: 33,
            ),
            Text(
              'Pesanan berhasil diselesaikan!!!\nData akan segera masuk',
              textAlign: TextAlign.center,
              style: TextStyles.poppinsMedium.copyWith(
                fontSize: 18,
                color: Color(0xFF505050),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
