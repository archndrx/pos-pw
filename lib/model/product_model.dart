class ProductModel {
  late String? id;
  late String name;
  late int price;
  late String file;
  late int stock;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.file,
    required this.stock,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'file': file,
      'stock': stock
    };
  }

  static ProductModel fromMap(Map<String, dynamic> map) => ProductModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      file: map['file'],
      stock: map['stock'] ?? 0);
}
