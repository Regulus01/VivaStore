import 'package:flutter/material.dart';
import 'package:mini_mercado_flutter/sign_up/firestore.dart';
import 'package:uuid/uuid.dart';

class ProductFormPage extends StatefulWidget {
  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  final List<String> categories = [
    'Vestuário',
    'Decoração',
    'Beleza',
    'Cama',
    'Mesa',
    'Banho'
  ];

  String? selectedCategory;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _detailsController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final String name = _nameController.text;
    final double price = double.tryParse(_priceController.text) ?? 0.0;
    final String imageUrl = _imageUrlController.text;
    final String details = _detailsController.text;
    final int stock = int.tryParse(_stockController.text) ?? 0;

    // Limpar os campos após o envio
    _nameController.clear();
    _priceController.clear();
    _imageUrlController.clear();
    _detailsController.clear();
    _stockController.clear();

    // Chamar a função para cadastrar o produto
    var category = selectedCategory ?? "Vestuario";
    createProduct(name, price, imageUrl, details, category, stock);

    // Exibir algum feedback para o usuário, como uma notificação ou redirecionamento
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Produto Criado'),
          content: Text('O produto $name foi cadastrado com sucesso!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> createProduct(
    String name,
    double price,
    String imageUrl,
    String details,
    String category,
    int stock,
  ) async {
    try {
      // Chamar a função para cadastrar o produto no Firestore
      await FireStore.createProduct(const Uuid().v4(),name, price, imageUrl, details, category, stock);
    } catch (error) {
      // Tratar o erro, exibir uma mensagem de erro, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Produto'),
      ),
      body: SingleChildScrollView(
        // Adicionado SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'URL da Imagem'),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _detailsController,
                decoration: const InputDecoration(labelText: 'Detalhes'),
              ),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Categoria'),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Estoque'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
