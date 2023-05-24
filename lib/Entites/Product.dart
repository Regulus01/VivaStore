import 'package:uuid/uuid.dart';
import 'dart:convert';

class Product {
  late String id = const Uuid().v4();
  final String name;
  final double price;
  final int estoque;
  final String imageUrl;
  final String details;
  final String category;

  Product(
      {required this.name,
      required this.price,
      required this.estoque,
      required this.imageUrl,
      required this.details,
      required this.category});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
      estoque: json['estoque'],
      imageUrl: json['imageUrl'],
      details: json['details'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'estoque': estoque,
      'imageUrl': imageUrl,
      'details': details,
      'category': category,
    };
  }
}
