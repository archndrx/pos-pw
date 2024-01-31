import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/model/product_model.dart';
import 'package:point_of_sales/model/sales_model.dart';
import 'package:point_of_sales/view/screen/cart/success_page.dart';

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
      final productDoc = await FirebaseFirestore.instance
          .collection('product')
          .doc(product.id)
          .get();

      if (productDoc.exists) {
        final int currentStock = productDoc['stock'] as int;

        if (currentStock > 0) {
          final cartReference =
              FirebaseFirestore.instance.collection('carts').doc(user.uid);
          final json = product.toMap();
          final QuerySnapshot querySnapshot = await cartReference
              .collection('items')
              .where('id', isEqualTo: product.id)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            final existingCartItem = querySnapshot.docs.first;
            final existingQuantity = existingCartItem['quantity'] ?? 0;
            await existingCartItem.reference
                .update({'quantity': existingQuantity + 1});
          } else {
            await cartReference.collection('items').add({
              ...json,
              'quantity': 1, // Initial quantity for a new item
            });
          }

          notifyListeners();
        } else {
          print('Product is out of stock');
        }
      }
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

  Future<void> checkout(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final cartItems = await getCartItems().first;
      final products = cartItems.docs.map((doc) {
        final cartItem = doc.data() as Map<String, dynamic>;
        return ProductModel.fromMap(cartItem);
      }).toList();

      // Calculate the total quantity of each product in the cart
      final productQuantities = <String, int>{};

      for (var doc in cartItems.docs) {
        final cartItem = doc.data() as Map<String, dynamic>;
        final product = ProductModel.fromMap(cartItem);
        final quantity = cartItem['quantity'] ?? 0;

        productQuantities[product.id!] =
            (productQuantities[product.id!] ?? 0) + (quantity as int);
      }

      final saleData = SaleModel(
        products: products,
        total: calculateTotalPrice(cartItems.docs),
        timestamp: DateTime.now(),
        quantity:
            productQuantities, // Set the total quantity map in the SaleModel
      );

      await FirebaseFirestore.instance
          .collection('sales')
          .doc('history')
          .collection('transactions')
          .add(saleData.toMap());

      // Update stock and remove items from cart after checkout
      for (var doc in cartItems.docs) {
        final cartItem = doc.data() as Map<String, dynamic>;
        final product = ProductModel.fromMap(cartItem);

        // Update the stock of the product
        final productDoc = await FirebaseFirestore.instance
            .collection('product')
            .doc(product.id)
            .get();

        if (productDoc.exists) {
          final int currentStock = productDoc['stock'] as int;
          final int quantitySold = cartItem['quantity'] ?? 0;

          // Update the stock in the 'product' collection
          await FirebaseFirestore.instance
              .collection('product')
              .doc(product.id)
              .update({'stock': currentStock - quantitySold});
        }

        // Remove the item from the cart
        await doc.reference.delete();
      }

      // Generate payment receipt
      final receiptData = await generateReceiptData(cartItems.docs);

      // Navigate to ReceiptPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SuccessPage(saleData: receiptData),
        ),
      );

      notifyListeners();
    }
  }

  Future<SaleModel> generateReceiptData(
      List<QueryDocumentSnapshot> cartItems) async {
    // Similar to the existing code to fetch product details and calculate total

    final products = cartItems.map((doc) {
      final cartItem = doc.data() as Map<String, dynamic>;
      return ProductModel.fromMap(cartItem);
    }).toList();

    final productQuantities = <String, int>{};

    for (var doc in cartItems) {
      final cartItem = doc.data() as Map<String, dynamic>;
      final product = ProductModel.fromMap(cartItem);
      final quantity = cartItem['quantity'] ?? 0;

      productQuantities[product.id!] =
          (productQuantities[product.id!] ?? 0) + (quantity as int);
    }

    final receiptData = SaleModel(
      products: products,
      total: calculateTotalPrice(cartItems),
      timestamp: DateTime.now(),
      quantity: productQuantities,
    );

    return receiptData;
  }

  int calculateTotalPrice(List<DocumentSnapshot> cartItems) {
    int totalHarga = 0;

    for (var item in cartItems) {
      final cartItem = item.data() as Map<String, dynamic>;
      final product = ProductModel.fromMap(cartItem);

      // Multiply the product price by the quantity and cast to int
      totalHarga += (product.price * cartItem['quantity']).toInt();
    }

    return totalHarga;
  }

  bool _showQuantityWarning = false;

  bool get showQuantityWarning => _showQuantityWarning;

  Future<void> updateQuantity(String itemId, int newQuantity) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Dapatkan informasi produk dari cart
      final cartItemSnapshot = await FirebaseFirestore.instance
          .collection('carts')
          .doc(user.uid)
          .collection('items')
          .doc(itemId)
          .get();

      if (cartItemSnapshot.exists) {
        final cartItem = cartItemSnapshot.data() as Map<String, dynamic>;
        final product = ProductModel.fromMap(cartItem);

        // Dapatkan informasi produk dari koleksi produk
        final productDoc = await FirebaseFirestore.instance
            .collection('product')
            .doc(product.id)
            .get();

        if (productDoc.exists) {
          final int currentStock = productDoc['stock'] as int;

          // Periksa apakah kuantitas baru tidak melebihi stok produk
          if (newQuantity >= 0 && newQuantity <= currentStock) {
            // Update kuantitas
            await FirebaseFirestore.instance
                .collection('carts')
                .doc(user.uid)
                .collection('items')
                .doc(itemId)
                .update({'quantity': newQuantity});

            // Jika kuantitas 0, panggil fungsi removeFromCart
            if (newQuantity == 0) {
              await removeFromCart(itemId);
            }

            // Sembunyikan pesan peringatan
            _showQuantityWarning = false;
          } else {
            // Tampilkan pesan atau ambil tindakan lain jika kuantitas melebihi stok
            print('Kuantitas melebihi stok produk');

            // Tampilkan pesan peringatan
            _showQuantityWarning = true;
          }

          notifyListeners();
        }
      }
    }
  }
}
