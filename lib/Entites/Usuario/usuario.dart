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
