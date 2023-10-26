import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:point_of_sales/model/product_model.dart';
import 'package:point_of_sales/view/screen/product/product_view_model.dart';
import 'package:provider/provider.dart';

class EditProduct extends StatefulWidget {
  final ProductModel data;

  const EditProduct({super.key, required this.data});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _fileController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.data.name);
    _priceController =
        TextEditingController(text: widget.data.price.toString());
    _fileController = TextEditingController(text: widget.data.file);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _fileController.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (pickedFile != null) {
      setState(() {
        _fileController.text = pickedFile.files.single.path!;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
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
                                backgroundColor:
                                    const Color.fromARGB(255, 110, 148, 225),
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
                final updatedData = ProductModel(
                  id: widget.data.id,
                  name: _nameController.text,
                  price: int.parse(_priceController.text),
                  file: _fileController.text,
                );
                final productProvider =
                    Provider.of<ProductProvider>(context, listen: false);
                productProvider.updateData(updatedData);
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
