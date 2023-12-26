import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:point_of_sales/model/user_model.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> getUsers() async {
    try {
      final snapshot = await _firestore
          .collection("users")
          .orderBy("name", descending: false)
          .get();

      List<UserModel> users = [];

      for (var doc in snapshot.docs) {
        var userData = doc.data();
        userData['id'] = doc.id; // Add UID to user data
        var userModel = UserModel(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          password: userData['password'],
          role: userData['role'],
        );
        users.add(userModel);
      }

      return users;
    } catch (error) {
      return []; // Return an empty list in case of an error
    }
  }

  Future<void> deleteUser(String uid) async {
    final response = await http
        .delete(Uri.parse('https://pos-admin.cyclic.app/deleteUser/$uid'));
    await _firestore.collection('users').doc(uid).delete();
    notifyListeners();

    if (response.statusCode == 200) {
      print('Pengguna berhasil dihapus');
    } else {
      print('Gagal menghapus pengguna. Status code: ${response.statusCode}');
    }
  }

  Future<void> addData(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse('https://pos-admin.cyclic.app/signup'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'email': user.email,
          'password': user.password,
          'role': user.role,
          'name': user.name,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        String uid = responseData['userId'];

        await addUserDataToFirestore(
            uid, user.email, user.role, user.name, user.password);

        // Notify listeners that the user list has changed
        notifyListeners();

        print('Registration successful');
      } else {
        print('Registration failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error during registration: $error');
    }
  }

  Future<void> addUserDataToFirestore(String uid, String email, String role,
      String name, String password) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'role': role,
        'name': name,
        'password': password,
      });
    } catch (error) {
      throw Exception('User data addition failed');
    }
  }

  Future<void> updateData(String uid, UserModel user) async {
    try {
      final response = await http.put(
        Uri.parse('https://pos-admin.cyclic.app/editUser/$uid'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'updatedName': user.name,
          'updatedEmail': user.email,
          'updatedPassword': user.password,
          'updatedRole': user.role,
        }),
      );

      if (response.statusCode == 200) {
        // Update the user list in the state with the provider if needed
        // ...

        // Notify listeners that the user list has changed
        notifyListeners();

        print('Update successful');
        // Show success message or perform other actions
      } else {
        // Handle the error if the request fails
        print('Update failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle errors that occur during request processing
      print('Error during update: $error');
    }
  }
}
