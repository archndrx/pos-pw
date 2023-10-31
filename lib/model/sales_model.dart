import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:point_of_sales/model/product_model.dart';

class SaleModel {
  final List<ProductModel> products;
  final int total;
  final DateTime timestamp;

  SaleModel({
    required this.products,
    required this.total,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'products': products.map((product) => product.toMap()).toList(),
      'total': total,
      'timestamp': timestamp,
    };
  }

  factory SaleModel.fromMap(Map<String, dynamic> data) {
    final productsData = data['products'] as List<dynamic>;
    final products = productsData.map((productData) {
      return ProductModel.fromMap(productData);
    }).toList();
    return SaleModel(
      products: products,
      total: data['total'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
