import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/components/textfield.dart';
import 'package:point_of_sales/view/screen/auth/auth_view_model.dart';
import 'package:point_of_sales/view/screen/auth/register/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';

  // text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await AuthProvider().signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Ada masalah, $errorMessage');
  }

  Future<void> switchToRegister() async {
    AuthProvider authProvider = AuthProvider();
    authProvider.toggleLoginStatus(); // Ubah status isLogin
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Image.asset(
                  'assets/image/logo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 50),
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                _errorMessage(),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: signInWithEmailAndPassword,
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    switchToRegister();
                  },
                  child: const Text('Register instead'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
