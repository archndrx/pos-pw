import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/model/product_model.dart';

class CartProvider extends ChangeNotifier {
  Future<int> getCartItemCount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartReference = FirebaseFirestore.instance
          .collection('carts')
          .doc(user.uid)
          .collection('items');
      final querySnapshot = await cartReference.get();
      return querySnapshot.size;
    } else {
      return 0; // Pengguna tidak terautentikasi
    }
  }

  Future<void> addToCart(ProductModel product) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartReference =
          FirebaseFirestore.instance.collection('carts').doc(user.uid);
      final json = product.toMap();
      await cartReference.collection('items').add(json);
      notifyListeners();
    }
  }

  Stream<QuerySnapshot> getCartItems() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('carts')
          .doc(user.uid)
          .collection('items')
          .snapshots();
    } else {
      return const Stream<QuerySnapshot>.empty();
    }
  }

  Future<void> removeFromCart(String itemId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(user.uid)
          .collection('items')
          .doc(itemId)
          .delete();
      notifyListeners();
    }
  }

  Future<void> checkout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartReference =
          FirebaseFirestore.instance.collection('carts').doc(user.uid);

      // Ambil semua item di keranjang
      final cartItems = await cartReference.collection('items').get();
      final orderData = {
        'userId': user.uid,
        'items': cartItems.docs.map((item) => item.data()).toList(),
        'totalPrice': calculateTotalPrice(cartItems.docs),
        'timestamp': FieldValue.serverTimestamp(), // Tambahkan waktu pesanan
      };

      // Simpan data pesanan ke koleksi 'orders'
      await FirebaseFirestore.instance.collection('orders').add(orderData);

      // Hapus semua item dari keranjang
      for (var item in cartItems.docs) {
        await item.reference.delete();
      }

      notifyListeners();
    }
  }

  int calculateTotalPrice(List<DocumentSnapshot> cartItems) {
    int totalHarga = 0;
    for (var item in cartItems) {
      final cartItem = item.data() as Map<String, dynamic>;
      final product = ProductModel.fromMap(cartItem);
      totalHarga += product.price;
    }
    return totalHarga;
  }
}
