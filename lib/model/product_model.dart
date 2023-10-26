class ProductModel {
  late String? id;
  late String name;
  late int price;
  late String file;

  ProductModel({
    this.id,
    required this.name,
    required this.price,
    required this.file,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'file': file,
    };
  }

  static ProductModel fromMap(Map<String, dynamic> map) => ProductModel(
        id: map['id'],
        name: map['name'],
        price: map['price'],
        file: map['file'],
      );
}
