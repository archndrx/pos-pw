import 'package:flutter/material.dart';
import 'package:point_of_sales/model/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];

  List<ProductModel> get items => _items;

  void addToCart(ProductModel product) {
    _items.add(product);
    notifyListeners();
  }

  void removeFromCart(ProductModel product) {
    _items.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
