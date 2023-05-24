import 'dart:convert';

import 'package:mini_mercado_flutter/Entites/Usuario/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class localstorage {
  void saveUserToLocalStorage(Usuario usuario) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var user = {
      "id": usuario.getId,
      "login": usuario.login,
      "nome": usuario.getNome,
      "senha": usuario.getSenha,
      "role": usuario.getRole,
      "carrinho":
          usuario.getCarrinho.map((produto) => produto.toJson()).toList(),
      "compras": usuario.getCompras.map((produto) => produto.toJson()).toList(),
    };

    final userJson = json.encode(user);
    prefs.setString('user', userJson);
  }

  static void saveUserJsonToLocalStorage(Map<String, dynamic> usuario) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (usuario.containsKey("carrinho")) {
      final carrinho = usuario["carrinho"];
      final carrinhoJson =
          json.encode(carrinho.map((produto) => produto).toList());
      usuario["carrinho"] = carrinhoJson;
    }

    if (usuario.containsKey("compras")) {
      final compras = usuario["compras"];
      final comprasJson =
          json.encode(compras.map((produto) => produto).toList());
      usuario["compras"] = comprasJson;
    }

    final userJson = json.encode(usuario);
    prefs.setString('user', userJson);
  }

  static Future<String?> getUserFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
  }

  static Future<String?> getUserNameLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('nome');
  }

  static Future<String?> getRoleFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = prefs.getString('user');
    // Analisar a string JSON para um objeto Map<String, dynamic>
    String? role;
    if (userData != null) {
      Map<String, dynamic> userMap = jsonDecode(userData);
      role = userMap['role'];
    }
    return role;
  }
}
