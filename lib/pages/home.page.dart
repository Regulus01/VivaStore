// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../Entites/Product.dart';
import 'package:mini_mercado_flutter/pages/ProductDetailsPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Product> allProducts = [
    Product(
      category: "Cama",
      name: "Produto 1",
      price: 9.99,
      details: "detalhe1",
      imageUrl:
          "https://st.depositphotos.com/1010338/2099/i/600/depositphotos_20999947-stock-photo-tropical-island-with-palms.jpg",
    ),
    Product(
      category: "Vestuario",
      name: "Produto 2",
      price: 19.99,
      details: "detalhe2",
      imageUrl:
          "https://st.depositphotos.com/1010338/2099/i/600/depositphotos_20999947-stock-photo-tropical-island-with-palms.jpg",
    ),
    Product(
      category: "Mesa",
      name: "Produto 3",
      price: 29.99,
      details: "detalhe3",
      imageUrl:
          "https://st.depositphotos.com/1010338/2099/i/600/depositphotos_20999947-stock-photo-tropical-island-with-palms.jpg",
    ),
  ];

  List<Product> filteredProducts = [];

  String selectedCategory = "Todas"; // Categoria selecionada inicialmente

  @override
  void initState() {
    super.initState();
    filteredProducts = allProducts;
  }

  void filterProductsByCategory(String category) {
    if (category == "Todas") {
      setState(() {
        filteredProducts = allProducts;
        selectedCategory = category;
      });
    } else {
      final List<Product> filteredList =
          allProducts.where((product) => product.category == category).toList();
      setState(() {
        filteredProducts = filteredList;
        selectedCategory = category;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Categorias',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Todas'),
              onTap: () {
                filterProductsByCategory("Todas");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Vestuario'),
              onTap: () {
                filterProductsByCategory("Vestuario");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Decoração'),
              onTap: () {
                filterProductsByCategory("Decoração");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Beleza'),
              onTap: () {
                filterProductsByCategory("Beleza");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Cama'),
              onTap: () {
                filterProductsByCategory("Cama");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Mesa'),
              onTap: () {
                filterProductsByCategory("Mesa");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Banho'),
              onTap: () {
                filterProductsByCategory("Banho");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return ListTile(
            leading: Image.network(product.imageUrl),
            title: Text(product.name),
            subtitle: Text('R\$ ${product.price.toStringAsFixed(2)}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
