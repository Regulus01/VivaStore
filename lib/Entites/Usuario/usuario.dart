import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../Product.dart';

class Usuario {
  final String id = const Uuid().v4();
  final String login;
  final String nome;
  final String senha;
  final String role;
  final List<Product> carrinho;
  final List<Product> compras;

  Usuario({
    required this.login,
    required this.senha,
    required this.role,
    required this.nome,
    List<Product>? carrinho,
    List<Product>? compras,
  })  : carrinho = carrinho ?? [],
        compras = compras ?? [];

  String get getId => id;

  String get getLogin => login;

  String get getNome => nome;

  String get getSenha => senha;

  String get getRole => role;

  List<Product> get getCarrinho => carrinho;

  List<Product> get getCompras => compras;

  factory Usuario.fromJson(Map<String, dynamic> json) {
    List<dynamic> carrinhoJson = jsonDecode(json['carrinho']);
    List<dynamic> comprasJson = jsonDecode(json['compras']);

    return Usuario(
      login: json['login'],
      nome: json['nome'],
      senha: json['senha'],
      role: json['role'],
      carrinho: carrinhoJson.map((item) => Product.fromJson(item)).toList(),
      compras: comprasJson.map((item) => Product.fromJson(item)).toList(),
    );
  }

  void adicionarAoCarrinho(Product product) {
    carrinho.add(product);
  }

  void removerDoCarrinho(Product product) {
    carrinho.remove(product);
  }

  void adicionarAsCompras(List<Product> products) {
    carrinho.addAll(products);
  }
}
