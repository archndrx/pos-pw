import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/components/textfield.dart';
import 'package:point_of_sales/components/textstyle.dart';
import 'package:point_of_sales/view/screen/auth/auth_tree.dart';
import 'package:point_of_sales/view/screen/auth/auth_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      setState(() {
        isLoading = true;
      });

      await AuthProvider().signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AuthTree(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
        isLoading = false; // Set isLoading back to false in case of an error.
      });
      _showErrorDialog(errorMessage!);
    }
  }

  _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 87,
                    bottom: 64,
                  ),
                  child: Image.asset(
                    'assets/image/logo.png',
                    width: 207,
                    height: 207,
                  ),
                ),
                Text(
                  'Login',
                  style: TextStyles.interBold.copyWith(
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyles.poppinsMedium.copyWith(
                    color: const Color(0xFFB6B6B6),
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: MyTextField(
                    controller: emailController,
                    labelText: 'Email',
                    obscureText: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: MyTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 132),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8D4D),
                    fixedSize: const Size(367, 72),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && !isLoading) {
                      await signInWithEmailAndPassword();
                    }
                  },
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        ) // Menampilkan CircularProgressIndicator jika isLoading true
                      : Text(
                          'Login',
                          style: TextStyles.poppinsBold.copyWith(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
