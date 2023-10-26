import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/view/screen/auth/auth_view_model.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final User? user = AuthProvider().currentUser;

  Future<void> signOut() async {
    await AuthProvider().signOut();
  }

  Widget _title() {
    return const Text('Tes Auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: StreamBuilder<User?>(
        stream: AuthProvider().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            return Container(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(user?.email ?? 'User email'),
                  ElevatedButton(
                    onPressed: () {
                      signOut();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => LoginPage()),
                      // );
                    },
                    child: const Text("SignOut"),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
