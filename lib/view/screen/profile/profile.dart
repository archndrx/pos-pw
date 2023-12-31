import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/components/textstyle.dart';
import 'package:point_of_sales/view/screen/auth/auth_view_model.dart';
import 'package:point_of_sales/view/screen/auth/login/login_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final User? user = AuthProvider().currentUser;

  Future<void> signOut() async {
    await AuthProvider().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profil",
          style: TextStyles.interBold.copyWith(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFF87C47),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            DocumentSnapshot? userData = snapshot.data;

            // Check if user data exists
            if (userData != null && userData.exists) {
              Map<String, dynamic>? userDataMap =
                  userData.data() as Map<String, dynamic>?;

              String userEmail = userDataMap?['email'] ?? 'User email';
              String userName = userDataMap?['name'] ?? 'User name';

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icon/profile.png',
                            width: 112,
                            height: 112,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '$userName',
                            style: TextStyles.interBold.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '$userEmail',
                            style: TextStyles.poppinsMedium.copyWith(
                              fontSize: 18,
                              color: Color(0xFFB6B6B6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8D4D),
                        fixedSize: const Size(190, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "Sign Out",
                        style: TextStyles.poppinsBold.copyWith(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              );
            } else {
              return Text('User data not found');
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
