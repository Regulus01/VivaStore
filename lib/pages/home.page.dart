import 'package:flutter/material.dart';
import 'package:mini_mercado_flutter/pages/ProductDetailsPage.dart';
import 'package:mini_mercado_flutter/sign_up/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Entites/Product.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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

  String? role;
  List<Product> filteredProducts = [];
  String selectedCategory = "Todas"; // Categoria selecionada inicialmente
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() {
    localstorage.getRoleFromLocalStorage().then((role) {
      setState(() {
        this.role = role;
        filteredProducts = allProducts;
      });
    });
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

  void filterProductsByName(String keyword) {
    final List<Product> filteredList = allProducts
        .where((product) =>
            product.name.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
    setState(() {
      filteredProducts = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.0),
        elevation: 0.0,
        title: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(0, 255, 166, 0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              filterProductsByName(value);
            },
            decoration: InputDecoration(
              hintText: 'Pesquisar produtos',
              hintStyle:
                  const TextStyle(color: Color.fromARGB(255, 236, 135, 20)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Color.fromARGB(255, 236, 135, 20),
              ),
            ),
            style: const TextStyle(color: Color.fromARGB(255, 250, 0, 0)),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: Color.fromARGB(255, 236, 135, 20),
              ),
              onPressed: () {
                // Ação do ícone de carrinho de compras
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Color.fromARGB(255, 236, 135, 20),
              ),
              onPressed: () {
                // Ação do ícone de notificações
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Categorias',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Todas', style: TextStyle(fontSize: 16)),
              onTap: () {
                filterProductsByCategory("Todas");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Vestuario', style: TextStyle(fontSize: 16)),
              onTap: () {
                filterProductsByCategory("Vestuario");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Decoração', style: TextStyle(fontSize: 16)),
              onTap: () {
                filterProductsByCategory("Decoração");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Beleza', style: TextStyle(fontSize: 16)),
              onTap: () {
                filterProductsByCategory("Beleza");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Cama', style: TextStyle(fontSize: 16)),
              onTap: () {
                filterProductsByCategory("Cama");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Mesa', style: TextStyle(fontSize: 16)),
              onTap: () {
                filterProductsByCategory("Mesa");
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Banho', style: TextStyle(fontSize: 16)),
              onTap: () {
                filterProductsByCategory("Banho");
                Navigator.pop(context);
              },
            ),
            if (role == 'admin')
              ListTile(
                title: const Text(
                  'Cadastrar Produtos',
                  style: TextStyle(fontSize: 16),
                ),
                onTap: () {
                  // Ação do item "Cadastrar Produtos"
                  Navigator.pop(context);
                  // Implemente a ação de navegação para a página de cadastro de produtos
                },
              ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final Product product = filteredProducts[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              product.name,
              style: const TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              'R\$ ${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
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
