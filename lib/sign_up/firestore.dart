import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_mercado_flutter/Entites/Usuario/usuario.dart';
import 'package:mini_mercado_flutter/sign_up/localstorage.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

import '../Entites/Product.dart';

class FireStore {
  static var database = FirebaseFirestore.instance;

  static createUser(String login, String nome, String senha) {
    final List<Product> carrinho = [];
    final List<Product> compras = [];

    final newUser = <String, String>{
      "id": const Uuid().v4(),
      "login": login,
      "nome": nome,
      "senha": senha,
      "role": "cliente",
      "carrinho":
          jsonEncode(carrinho.map((produto) => produto.toJson()).toList()),
      "compras":
          jsonEncode(compras.map((produto) => produto.toJson()).toList()),
    };

    database
        .collection("Usuario")
        .doc()
        .set(newUser)
        .onError((error, stackTrace) => 0); // retorna 0 em caso de erro
  }

  static Future<List<String>> readUsers() async {
    QuerySnapshot querySnapshot = await database.collection('Usuario').get();

    List<Future<String>> futures =
        querySnapshot.docs.map((QueryDocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      String email = data['login'];

      return Future.value(email);
    }).toList();

    List<String> emails = await Future.wait(futures);
    return emails;
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>?> getUser(
      String email, String senha) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Usuario')
        .where('login', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = snapshot.docs.first;
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      // Adiciona o número do documento ao mapa userData
      userData['documento'] = userSnapshot.id;

      // Verifica a senha
      if (userData['senha'] == senha) {
        localstorage.saveUserJsonToLocalStorage(userData);
        return userSnapshot;
      } else {
        return null; // Senha incorreta
      }
    } else {
      return null; // Usuário não encontrado
    }
  }
}
