import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:point_of_sales/view/screen/auth/auth_view_model.dart';
import 'package:point_of_sales/view/screen/auth/login/login_page.dart';

import 'package:point_of_sales/view/screen/homescreen/homescreen_admin.dart';
import 'package:point_of_sales/view/screen/homescreen/homescreen_kasir.dart';
import 'package:point_of_sales/view/screen/homescreen/homescreen_pemilik.dart';

class AuthTree extends StatefulWidget {
  const AuthTree({Key? key}) : super(key: key);

  @override
  State<AuthTree> createState() => _AuthTreeState();
}

class _AuthTreeState extends State<AuthTree> {
  final AuthProvider _authProvider = AuthProvider();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authProvider.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: const CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: const CircularProgressIndicator());
              }

              if (userSnapshot.hasData) {
                var userData =
                    userSnapshot.data!.data() as Map<String, dynamic>;
                var userRole = userData[
                    'role']; // Gantilah 'role' dengan nama field yang sesuai di Firestore

                if (userRole == 'admin') {
                  return const HomescreenAdmin();
                } else if (userRole == 'kasir') {
                  return HomescreenKasir();
                } else if (userRole == 'pemilik') {
                  return const HomescreenPemilik();
                } else {
                  // Jika peran tidak dikenali, Anda dapat mengarahkan ke halaman kesalahan atau menangani secara sesuai
                  return const LoginPage();
                }
              } else {
                // Jika data pengguna tidak ditemukan di Firestore
                return const LoginPage();
              }
            },
          );
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
