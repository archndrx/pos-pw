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

class EditProduct extends StatefulWidget {
  final ProductModel productData;

  const EditProduct({super.key, required this.productData});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _fileController;
  late final TextEditingController _stockController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productData.name);
    _priceController =
        TextEditingController(text: widget.productData.price.toString());
    _fileController = TextEditingController(text: widget.productData.file);
    _stockController =
        TextEditingController(text: widget.productData.stock.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _fileController.dispose();
    _stockController.dispose();
    super.dispose();
  }

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
              _fileController.text = downloadUrl;
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
          "Ubah Produk",
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
                    controller: _priceController,
                    obscureText: false,
                    labelText: 'Price',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: MyTextField(
                    controller: _stockController,
                    obscureText: false,
                    labelText: 'Stock',
                  ),
                ),
                const SizedBox(height: 12.0),
                PickFilesWidget(
                  onPressed: _pickFiles,
                ),
                const SizedBox(height: 172),
                ElevatedButton(
                  onPressed: () {
                    // Validasi untuk memastikan stok tidak boleh kurang dari 0
                    if (int.parse(_stockController.text) < 0) {
                      // Tampilkan pesan kesalahan jika stok kurang dari 0
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Stok tidak boleh kurang dari 0'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    if (int.parse(_priceController.text) < 0) {
                      // Tampilkan pesan kesalahan jika stok kurang dari 0
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Harga tidak boleh kurang dari 0'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      // Lanjutkan dengan pembaruan data jika validasi berhasil
                      final updatedData = ProductModel(
                        id: widget.productData.id,
                        name: _nameController.text,
                        price: int.parse(_priceController.text),
                        file: _fileController.text,
                        stock: int.parse(_stockController.text),
                      );
                      final productProvider =
                          Provider.of<ProductProvider>(context, listen: false);
                      productProvider.updateData(updatedData);
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
                          'Ubah Produk',
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
