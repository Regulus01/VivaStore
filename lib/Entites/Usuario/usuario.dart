import 'package:uuid/uuid.dart';

import '../Product';

class Usuario {
  final String id = const Uuid().v4();
  final String login;
  final String nome;
  final String senha;
  final String role;
  late List<Product> carrinho;
  late List<Product> compras;

  Usuario(
      {required this.login,
      required this.senha,
      required this.role,
      required this.nome});

  String get getId => id;

  String get getLogin => login;

  String get getNome => nome;

  String get getSenha => senha;

  String get getRole => role;

  List<Product> get getCarrinho => carrinho;

  List<Product> get getCompras => compras;

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
