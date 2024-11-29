import 'dart:typed_data';

class ProductModel {
  final int? id;
  final String name;
  final String description;
  final double price;
  final Uint8List image;
  final int quantity;

  ProductModel({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.quantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as Uint8List,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }
}
