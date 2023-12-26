// user_page.dart

import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/components/textstyle.dart';
import 'package:point_of_sales/model/user_model.dart';
import 'package:point_of_sales/view/screen/user/add_user.dart';
import 'package:point_of_sales/view/screen/user/edit_user.dart';
import 'package:point_of_sales/view/screen/user/user_provider.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          "Kelola Pengguna",
          style: TextStyles.interBold.copyWith(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFF87C47),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const AddUser(), // Navigate to AddUserPage
                ),
              ).then((result) {
                // Handle the result if needed
                if (result != null && result is bool && result) {
                  // No need to use setState here
                }
              });
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer<UserProvider>(builder: (context, provider, _) {
        return FutureBuilder<List<UserModel>>(
          future: provider.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: const CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<UserModel> users = snapshot.data!;
              return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  thickness: 1,
                ),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      users[index].name,
                      style: TextStyles.interBold.copyWith(
                        fontSize: 18,
                        color: Color(0xFF505050),
                      ),
                    ),
                    subtitle: Text(
                      users[index].email,
                      style: TextStyles.poppinsMedium.copyWith(
                        fontSize: 16,
                        color: Color(0xFFB6B6B6),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditUser(userData: users[index]),
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/icon/edit.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                        SizedBox(
                          width: 17,
                        ),
                        GestureDetector(
                          onTap: () async {
                            showDialog(
                              context: context,
                              barrierDismissible:
                                  false, // Prevent dismissing by tapping outside
                              builder: (BuildContext context) {
                                return Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: EdgeInsets.all(20.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            );

                            try {
                              // Perform the delete operation
                              await provider.deleteUser(users[index].id!);

                              // Dismiss the loading overlay
                              Navigator.of(context)
                                  .pop(); // Pop the loading overlay

                              // Show success notification
                              ElegantNotification.success(
                                title: Text(
                                  'Success',
                                  style: TextStyles.interRegular.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                description: Text(
                                  "Hapus Data Berhasil",
                                  style: TextStyles.interRegular.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                animation: AnimationType.fromBottom,
                                background: Color.fromARGB(181, 248, 124, 71),
                                notificationPosition:
                                    NotificationPosition.center,
                              ).show(context);
                            } catch (error) {
                              // Dismiss the loading overlay on error
                              Navigator.of(context)
                                  .pop(); // Pop the loading overlay

                              // Show error notification
                              ElegantNotification.error(
                                title: Text(
                                  'Error',
                                  style: TextStyles.interRegular.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                description: Text(
                                  "Hapus Data Gagal",
                                  style: TextStyles.interRegular.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                animation: AnimationType.fromBottom,
                                background: Color.fromARGB(181, 248, 124, 71),
                                toastDuration: Duration(seconds: 2),
                                notificationPosition:
                                    NotificationPosition.center,
                              ).show(context);
                            }
                          },
                          child: Image.asset(
                            'assets/icon/delete.png',
                            width: 30,
                            height: 30,
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }
          },
        );
      }),
    );
  }
}
