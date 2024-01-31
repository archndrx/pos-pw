import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/model/product_model.dart';
import 'package:point_of_sales/model/sales_model.dart';

class SalesProvider extends ChangeNotifier {
  int _transactionCount = 0;
  String _filter = 'Hari ini';

  int get transactionCount => _transactionCount;
  String get filter => _filter;

  void setTransactionCount(int count) {
    _transactionCount = count;
    notifyListeners();
  }

  void updateFilter(String newFilter) {
    _filter = newFilter;
    notifyListeners();
  }

  Stream<QuerySnapshot> getAllTransactions() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference transactionsCollection = FirebaseFirestore.instance
          .collection('sales')
          .doc('history')
          .collection('transactions');

      return transactionsCollection.snapshots();
    } else {
      return const Stream<QuerySnapshot>.empty();
    }
  }

  Stream<QuerySnapshot> getTransactions() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CollectionReference transactionsCollection = FirebaseFirestore.instance
          .collection('sales')
          .doc('history')
          .collection('transactions');

      DateTime now = DateTime.now();
      DateTime startOfPeriod;

      if (_filter == 'Minggu ini') {
        int daysUntilMonday = DateTime.monday - now.weekday;
        if (daysUntilMonday <= 0) {
          // If today is Monday or later, subtract daysUntilMonday to get to the start of the week
          startOfPeriod = now.subtract(
            Duration(days: now.weekday - DateTime.monday),
          );
        } else {
          // If today is before Monday, subtract daysUntilMonday plus 7 days to get to the start of the week
          startOfPeriod = now.subtract(
            Duration(days: daysUntilMonday + 7),
          );
        }
      } else if (_filter == 'Bulan ini') {
        startOfPeriod = DateTime(now.year, now.month, 1);
      } else if (_filter == 'Tahun ini') {
        startOfPeriod = DateTime(now.year, 1, 1);
      } else if (_filter == 'Hari ini') {
        startOfPeriod = DateTime(now.year, now.month, now.day);
      } else {
        // If filter is 'Overall' or invalid, return all transactions
        return transactionsCollection.snapshots();
      }

      return transactionsCollection
          .where('timestamp', isGreaterThanOrEqualTo: startOfPeriod)
          .snapshots();
    } else {
      return const Stream<QuerySnapshot>.empty();
    }
  }

  Future<int> getTotalSales() async {
    final transactions = await getTransactions().first;
    int totalSales = 0;
    if (transactions.docs.isNotEmpty) {
      for (var transaction in transactions.docs) {
        final transactionData = transaction.data() as Map<String, dynamic>;
        final total = transactionData['total'] as int;
        totalSales += total;
      }
    }
    return totalSales;
  }

  Future<int> getTotalCheckoutCount() async {
    final transactions = await getTransactions().first;
    return transactions.size;
  }

  Future<List<SaleModel?>> getTopSellingProducts() async {
    final transactions = await getTransactions().first;
    final productQuantities = <String, int>{};

    if (transactions.docs.isNotEmpty) {
      for (var transaction in transactions.docs) {
        final transactionData = transaction.data() as Map<String, dynamic>;
        final quantityMap = transactionData['quantity'] as Map<String, dynamic>;

        quantityMap.forEach((productId, quantity) {
          productQuantities[productId] =
              (productQuantities[productId] ?? 0) + (quantity as int);
        });
      }

      // Sort products based on total quantity in descending order
      final sortedProductIds = productQuantities.keys.toList()
        ..sort(
            (a, b) => productQuantities[b]!.compareTo(productQuantities[a]!));

      // Fetch product details and quantity for the top-selling products
      final topSellingProducts =
          await Future.wait(sortedProductIds.take(5).map((productId) async {
        final productDoc = await FirebaseFirestore.instance
            .collection('product')
            .doc(productId)
            .get();

        if (productDoc.exists) {
          final productData = productDoc.data() as Map<String, dynamic>;
          final product = ProductModel.fromMap(productData);
          final quantity = productQuantities[productId]!;

          return SaleModel(
            timestamp: DateTime.now(),
            total: product.price * quantity,
            products: [product],
            quantity: {productId: quantity},
          );
        } else {
          return null;
        }
      }));

      return topSellingProducts;
    } else {
      // Handle case when there are no transactions
      return [];
    }
  }
}
