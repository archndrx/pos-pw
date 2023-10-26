import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/view/screen/auth/auth_view_model.dart';
import 'package:point_of_sales/view/screen/auth/login/login_page.dart';
import 'package:point_of_sales/view/screen/homepage.dart';
import 'package:point_of_sales/view/screen/profile/profile.dart';

class AuthTree extends StatefulWidget {
  const AuthTree({super.key});

  @override
  State<AuthTree> createState() => _AuthTreeState();
}

class _AuthTreeState extends State<AuthTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthProvider().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (userSnapshot.hasData) {
                final userRole = userSnapshot.data!.get('role');

                if (userRole == 'admin') {
                  return ProfilePage(); // Ganti dengan halaman admin
                } else if (userRole == 'kasir') {
                  return const HomeScreen(); // Ganti dengan halaman pengguna biasa
                } else {
                  // Role tidak dikenali, batasi akses atau tampilkan pesan kesalahan
                  return const LoginPage();
                }
              } else {
                // Dokumen pengguna tidak ditemukan
                return const LoginPage();
              }
            },
          );
        } else {
          // Pengguna belum terautentikasi
          return const LoginPage();
        }
      },
    );
  }
}
