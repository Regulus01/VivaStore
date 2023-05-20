import 'package:uuid/uuid.dart';
import 'dart:convert';

class Product {
  final String id = const Uuid().v4();
  final String name;
  final double price;
  final String imageUrl;
  final String details;
  final String category;

  Product(
      {required this.name,
      required this.price,
      required this.imageUrl,
      required this.details,
      required this.category});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'details': details,
      'category': category,
    };
  }
}