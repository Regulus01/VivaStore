import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Entites/Product.dart';
import 'dart:convert';

import 'Confirmation.page.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Product> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    if (userJson != null) {
      Map<String, dynamic> userData = jsonDecode(userJson);
      List<dynamic> cartItemsJson = jsonDecode(userData['carrinho']);

      setState(() {
        cartItems = cartItemsJson
            .map((json) => Product.fromJson(json))
            .cast<Product>()
            .toList();
      });
    }
  }

  void confirmPurchase() {
    // Lógica para confirmar a compra
    // Redirecionar para a página de confirmação, por exemplo:
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ConfirmationPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text('O carrinho está vazio'),
            )
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return ListTile(
                  leading: Image.network(
                    product.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name),
                  subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: confirmPurchase,
        label: const Text('Confirmar compra'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
