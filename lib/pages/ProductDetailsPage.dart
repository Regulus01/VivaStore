import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mini_mercado_flutter/pages/produto/EditProduct.page.dart';
import '../Entites/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini_mercado_flutter/sign_up/firestore.dart';
import 'dart:convert';

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  ProductDetailsPage({required this.product});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool addedToCart = false;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    checkUserRole();
  }

  Future<void> checkUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    if (userJson != null) {
      Map<String, dynamic> userData = jsonDecode(userJson);
      String? role = userData['role'];

      setState(() {
        isAdmin = role == 'admin';
      });
    }
  }

  Future<void> addToCart(Product product) async {
    if(product.estoque == 0){
      Fluttertoast.showToast(
        msg: 'Sem mais produtos no estoque!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');

    if (userJson != null) {
      Map<String, dynamic> userData = jsonDecode(userJson);
      List<dynamic>? cartItemsJson = jsonDecode(userData['carrinho'] ?? '[]');

      if (cartItemsJson == null) {
        cartItemsJson = [product.toJson()];
      } else {
        cartItemsJson.add(product.toJson());
      }

      userData['carrinho'] = jsonEncode(cartItemsJson);

      await prefs.setString('user', jsonEncode(userData));

      List<Product> cartItems = cartItemsJson
          .map((json) => Product.fromJson(json))
          .toList();
      var documento = userData['documento'];

      await FireStore.updateCart(documento, cartItems);

      setState(() {
        addedToCart = true;
      });
    }
  }

  void editProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: widget.product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: editProduct,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                widget.product.imageUrl,
                height: 200,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 20),
              Text(
                widget.product.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'R\$ ${widget.product.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Estoque: ${widget.product.estoque}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Categoria: ${widget.product.category}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Detalhes: ${widget.product.details}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addedToCart
                    ? null
                    : () {
                  addToCart(widget.product);
                },
                child: Text('Adicionar ao Carrinho'),
              ),
              SizedBox(height: 10),
              addedToCart
                  ? Text(
                'Produto adicionado ao carrinho com sucesso!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
