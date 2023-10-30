import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/model/product_model.dart';

class ProductProvider extends ChangeNotifier {
  Stream<List<ProductModel>> getProduct() => FirebaseFirestore.instance
      .collection("product")
      .orderBy("name")
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data()))
          .toList());

  Future<void> addProduct(ProductModel product) async {
    final docProd = FirebaseFirestore.instance.collection('product').doc();
    product.id = docProd.id;
    final json = product.toMap();
    await docProd.set(json);
    notifyListeners();
  }

  void updateData(ProductModel product) async {
    final docProd =
        FirebaseFirestore.instance.collection('product').doc(product.id);
    docProd.update(product.toMap());
    notifyListeners();
  }

  void deleteData(String id) async {
    FirebaseFirestore.instance.collection('product').doc(id).delete();
  }
}
