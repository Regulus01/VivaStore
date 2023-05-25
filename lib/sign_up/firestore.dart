import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_mercado_flutter/sign_up/localstorage.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

import '../Entites/Product.dart';

class FireStore {
  static var database = FirebaseFirestore.instance;

  static createUser(String login, String nome, String senha) {
    final List<Product> carrinho = [];
    final List<Product> compras = [];

    final newUser = {
      "id": const Uuid().v4(),
      "login": login,
      "nome": nome,
      "senha": senha,
      "role": "cliente",
      "carrinho": carrinho.map((produto) => produto.toJson()).toList(),
      "compras": compras.map((produto) => produto.toJson()).toList(),
    };

    database
        .collection("Usuario")
        .doc()
        .set(newUser)
        .catchError((error, stackTrace) => 0); // retorna 0 em caso de erro
  }

  static Future<void> updateCart(
      String documento, List<Product> cartItems) async {
    CollectionReference usersRef = database.collection('Usuario');

    // Converta a lista de produtos em uma lista de mapas
    List<Map<String, dynamic>> cartItemsMap =
        cartItems.map((product) => product.toJson()).toList();

    // Atualize o documento do usuário com o novo carrinho
    await usersRef.doc(documento).update({'carrinho': cartItemsMap});
  }

  static Future<void> clearCart(String documento) async {
    CollectionReference usersRef = database.collection('Usuario');

    // Crie uma lista vazia para representar o carrinho vazio
    List<Map<String, dynamic>> emptyCart = [];

    // Atualize o documento do usuário com o carrinho vazio
    await usersRef.doc(documento).update({'carrinho': emptyCart});
  }

  static Future<void> updateCompras(
      String documento, List<Product> cartItems) async {
    CollectionReference usersRef = database.collection('Usuario');

    // Converta a lista de produtos em uma lista de mapas
    List<Map<String, dynamic>> cartItemsMap =
        cartItems.map((product) => product.toJson()).toList();

    // Atualize o documento do usuário com o novo carrinho
    await usersRef.doc(documento).update({'compras': cartItemsMap});
  }

  static createProduct(String id, String name, double price, String imageUrl,
      String details, String category, int estoque) {
    final newProduct = <String, String>{
      'id': id,
      'name': name,
      'price': price.toString(),
      'imageUrl': imageUrl,
      'estoque': estoque.toString(),
      'details': details,
      'category': category,
    };

    database
        .collection("Product")
        .doc()
        .set(newProduct)
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

  static Future<List<Product>> getProducts() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Product').get();

    List<Product> products = [];

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      String id = data['id'];
      String name = data['name'];
      double price = double.parse(data['price']);
      int estoque = int.parse(data['estoque']);
      String imageUrl = data['imageUrl'];
      String details = data['details'];
      String category = data['category'];

      Product product = Product(
        id: id,
        name: name,
        price: price,
        estoque: estoque,
        imageUrl: imageUrl,
        details: details,
        category: category,
      );

      products.add(product);
    }

    return products;
  }

  static Future<void> atualizarProduto(Product produto) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Product')
        .where('id', isEqualTo: produto.id)
        .get();

    final doc = querySnapshot.docs.first;

    await doc.reference.update({
      'name': produto.name,
      'price': produto.price.toString(),
      'estoque': produto.estoque.toString(),
      'imageUrl': produto.imageUrl,
      'details': produto.details,
      'category': produto.category,
    });
  }
}
