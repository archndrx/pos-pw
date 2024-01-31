import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/components/textfield.dart';
import 'package:point_of_sales/components/textstyle.dart';

import 'package:point_of_sales/model/user_model.dart';
import 'package:point_of_sales/view/screen/user/user_provider.dart';
import 'package:provider/provider.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          "Tambah Pengguna",
          style: TextStyles.interBold.copyWith(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFF87C47),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: MyTextField(
                    controller: nameController,
                    labelText: 'Name',
                    obscureText: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: MyTextField(
                    controller: emailController,
                    labelText: 'Email',
                    obscureText: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: MyTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    obscureText: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 16,
                    right: 16,
                  ),
                  child: DropdownButtonFormField<String>(
                    value: roleController.text.isEmpty
                        ? null
                        : roleController.text,
                    items: [
                      "Kasir",
                      "Admin",
                      "Pemilik"
                    ] // Ganti dengan pilihan role yang diinginkan
                        .map((role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        roleController.text = value!;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFDDDDDD),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFDDDDDD),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFDDDDDD),
                          width: 2,
                        ),
                      ),
                      labelText: 'Role',
                      labelStyle: TextStyles.poppinsMedium.copyWith(
                        fontSize: 16,
                        color: Color(0xFF757575),
                      ),
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please choose a role';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 320,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8D4D),
                    fixedSize: const Size(320, 72),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    // Ambil nilai dari input field
                    if (_formKey.currentState!.validate()) {
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();
                      String role = roleController.text.trim();
                      String name = nameController.text.trim();
                      final addDataUser = UserModel(
                          name: name,
                          email: email,
                          password: password,
                          role: role);
                      try {
                        setState(() {
                          isLoading = true;
                        });
                        final existingUsers = await userProvider.getUsers();
                        bool emailExists = existingUsers
                            .any((existingUser) => existingUser.email == email);
                        if (emailExists) {
                          ElegantNotification.info(
                            title: Text(
                              'Alert',
                              style: TextStyles.interRegular.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            description: Text(
                              "Email Sudah Digunakan Pengguna Lain",
                              style: TextStyles.interRegular.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            animation: AnimationType.fromBottom,
                            background: Color.fromARGB(181, 248, 124, 71),
                            toastDuration: Duration(seconds: 2),
                            notificationPosition: NotificationPosition.center,
                          ).show(context);
                        } else {
                          await userProvider.addData(addDataUser);
                          ElegantNotification.success(
                            title: Text(
                              'Success',
                              style: TextStyles.interRegular.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            description: Text(
                              "Tambah Data Berhasil",
                              style: TextStyles.interRegular.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            animation: AnimationType.fromBottom,
                            background: Color.fromARGB(181, 248, 124, 71),
                            toastDuration: Duration(seconds: 2),
                            notificationPosition: NotificationPosition.center,
                          ).show(context);
                          await Future.delayed(Duration(seconds: 2));
                          Navigator.pop(context);
                        }
                      } catch (error) {
                        ElegantNotification.error(
                          title: Text(
                            'Error',
                            style: TextStyles.interRegular.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          description: Text(
                            "Tambah data Gagal",
                            style: TextStyles.interRegular.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          animation: AnimationType.fromBottom,
                          background: Color.fromARGB(181, 248, 124, 71),
                          toastDuration: Duration(seconds: 2),
                          notificationPosition: NotificationPosition.center,
                        ).show(context);
                      } finally {
                        // Ensure isLoading is set back to false in all scenarios
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Tambah Pengguna',
                          style: TextStyles.poppinsBold.copyWith(
                            fontSize: 20,
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
