// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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

  Future<void> _pickFiles() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (pickedFile != null) {
      setState(() {
        fileController.text = pickedFile.files.single.path!;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Data"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 228, 235, 249),
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Pick Files"),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 110, 148, 225),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                                  onPressed: () {
                                    _pickFiles();
                                  },
                                  child: const Text("Pick and Open Files"),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final name = nameController.text;
                      final price = int.parse(priceController.text);
                      final file = fileController.text;
                      final newData = ProductModel(
                        name: name,
                        price: price,
                        file: file,
                      );
                      final dataProvider = context.read<ProductProvider>();
                      dataProvider.addProduct(newData);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
