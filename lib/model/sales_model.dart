import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:point_of_sales/model/product_model.dart';

class SaleModel {
  DateTime timestamp;
  int total;
  List<ProductModel> products;
  Map<String, int> quantity;

  SaleModel({
    required this.timestamp,
    required this.total,
    required this.products,
    required this.quantity,
  });

  factory SaleModel.fromMap(Map<String, dynamic> map) {
    final productsData = map['products'] as List<dynamic>? ?? [];
    final products = productsData
        .map((productMap) => ProductModel.fromMap(productMap))
        .toList();

    Map<String, int> quantity = {};

    if (map['quantity'] != null) {
      if (map['quantity'] is Map<String, dynamic>) {
        // If 'quantity' is a Map<String, dynamic>, cast the values to int
        quantity = (map['quantity'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, value as int));
      } else if (map['quantity'] is int) {
        // If 'quantity' is an int, assume it's the total quantity for all products
        quantity['total'] = map['quantity'] as int;
      } else {
        // Handle other cases or log a warning
      }
    }

    return SaleModel(
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      total: map['total'] ?? 0,
      products: products,
      quantity: quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'total': total,
      'products': products.map((product) => product.toMap()).toList(),
      'quantity': quantity,
    };
  }
}
