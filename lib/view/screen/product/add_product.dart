import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/components/styledContainer.dart';
import 'package:point_of_sales/components/textfield.dart';
import 'package:point_of_sales/components/textstyle.dart';
import 'package:point_of_sales/model/product_model.dart';
import 'package:point_of_sales/view/screen/product/product_view_model.dart';
import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final fileController = TextEditingController();
  final stockController = TextEditingController();
  bool _isLoading = false;

  Future<void> _pickFiles() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (mounted) {
        if (pickedFile != null) {
          File file = File(pickedFile.files.single.path!);

          // Upload the file to Firebase Storage
          Reference storageReference = FirebaseStorage.instance
              .ref()
              .child('images/${DateTime.now().toString()}');
          UploadTask uploadTask = storageReference.putFile(file);
          TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

          // Get the download URL
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();

          // Update the UI with the download URL
          if (mounted) {
            setState(() {
              fileController.text = downloadUrl;
            });
          }
        } else {
          // Handle the case when no file is picked
        }
      }
    } catch (error) {
      // Handle errors during file upload
      print("Error picking/uploading file: $error");
      // You can show a snackbar or dialog to inform the user about the error
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          "Tambah Produk",
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
                    controller: priceController,
                    labelText: 'Price',
                    obscureText: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter price';
                      }
                      if (double.tryParse(value) == null ||
                          double.parse(value) < 0) {
                        return 'Masukan nilai non-negatif';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: MyTextField(
                    controller: stockController,
                    labelText: 'Stock',
                    obscureText: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a stock';
                      }

                      // Pastikan value yang dimasukkan adalah angka positif atau nol
                      if (double.tryParse(value) == null ||
                          double.parse(value) < 0) {
                        return 'Masukan nilai non-negatif';
                      }

                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 12.0),
                PickFilesWidget(
                  onPressed: _pickFiles,
                ),
                const SizedBox(height: 172),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final name = nameController.text;
                      final price = int.parse(priceController.text);
                      final file = fileController.text;
                      final stock = stockController.text;
                      final newData = ProductModel(
                        name: name,
                        price: price,
                        file: file,
                        stock: int.parse(stock),
                      );
                      final productProvider = context.read<ProductProvider>();
                      productProvider.addProduct(newData);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8D4D),
                    fixedSize: const Size(320, 72),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Simpan Produk',
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
