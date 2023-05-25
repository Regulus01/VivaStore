import 'package:flutter/material.dart';
import 'package:mini_mercado_flutter/pages/ProductDetailsPage.dart';
import 'package:mini_mercado_flutter/pages/login.page.dart';
import 'package:mini_mercado_flutter/pages/produto/create_produto.page.dart';
import 'package:mini_mercado_flutter/sign_up/firestore.dart';
import 'package:mini_mercado_flutter/sign_up/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Entites/Product.dart';
import 'MyPurchases.page.dart';
import 'carrinho.page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> allProducts = [];

  String? role;
  List<Product> filteredProducts = [];
  String selectedCategory = "Todas"; // Categoria selecionada inicialmente
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    initializeData();
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void fetchProducts() async {
    List<Product> productList = await FireStore.getProducts();
    setState(() {
      allProducts.addAll(productList);
      filteredProducts = allProducts;
    });
  }

  void initializeData() {
    localstorage.getRoleFromLocalStorage().then((role) {
      setState(() {
        this.role = role;
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

  void reloadProducts() {
    setState(() {
      allProducts.clear();
      filteredProducts.clear();
      fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0.0,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              filterProductsByName(value);
            },
            decoration: InputDecoration(
              hintText: 'Pesquisar produtos',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
            style: const TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartPage(),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
              ),
              onPressed: () {
                // Ação do ícone de notificações
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                reloadProducts();
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
                      color: Colors.white,
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
              title: const Text('Vestuário', style: TextStyle(fontSize: 16)),
              onTap: () {
                filterProductsByCategory("Vestuário");
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductFormPage(),
                    ),
                  );
                },
              ),
            ListTile(
              title: const Text('Logout', style: TextStyle(fontSize: 16)),
              onTap: () {
                _logout();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              padding: const EdgeInsets.all(16.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(
                          product: product,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'R\$ ${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyPurchasesPage(),
            ),
          );
        },
        child: const Icon(Icons.shopping_bag),
      ),
    );
  }
}
