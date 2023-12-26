// ignore_for_file: library_private_types_in_public_api

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/components/textfield.dart';
import 'package:point_of_sales/components/textstyle.dart';
import 'package:point_of_sales/model/user_model.dart';
import 'package:point_of_sales/view/screen/user/user_provider.dart';
import 'package:provider/provider.dart';

class EditUser extends StatefulWidget {
  final UserModel userData;

  const EditUser({Key? key, required this.userData}) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _roleController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData.name);
    _emailController = TextEditingController(text: widget.userData.email);
    _passwordController = TextEditingController(text: widget.userData.password);
    _roleController = TextEditingController(text: widget.userData.role);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          "Ubah Pengguna",
          style: TextStyles.interBold.copyWith(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFF87C47),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: MyTextField(
                    controller: _nameController,
                    obscureText: false,
                    labelText: 'Name',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: MyTextField(
                    controller: _emailController,
                    obscureText: false,
                    labelText: 'Email',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: MyTextField(
                    controller: _passwordController,
                    obscureText: true,
                    labelText: 'Password',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: MyTextField(
                    controller: _roleController,
                    obscureText: false,
                    labelText: 'Role',
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
                    String updatedName = _nameController.text.trim();
                    String updatedEmail = _emailController.text.trim();
                    String updatedPassword = _passwordController.text.trim();
                    String updatedRole =
                        _roleController.text.trim().toLowerCase();
                    final updatedData = UserModel(
                      name: updatedName,
                      email: updatedEmail,
                      password: updatedPassword,
                      role: updatedRole,
                    );

                    try {
                      setState(() {
                        isLoading = true;
                      });
                      await userProvider.updateData(
                          widget.userData.id!, updatedData);
                      ElegantNotification.success(
                        title: Text(
                          'Success',
                          style: TextStyles.interRegular.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        description: Text(
                          "Update Berhasil",
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
                    } catch (error) {
                      ElegantNotification.error(
                        title: Text(
                          'Error',
                          style: TextStyles.interRegular.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        description: Text(
                          "Update Gagal",
                          style: TextStyles.interRegular.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        toastDuration: Duration(seconds: 2),
                        animation: AnimationType.fromBottom,
                        notificationPosition: NotificationPosition.center,
                      ).show(context);
                    }
                  },
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Ubah Pengguna',
                          style: TextStyles.poppinsBold.copyWith(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
