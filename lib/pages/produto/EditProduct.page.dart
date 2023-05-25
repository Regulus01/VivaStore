import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mini_mercado_flutter/pages/home.page.dart';
import '../../Entites/Product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini_mercado_flutter/sign_up/firestore.dart';
import 'dart:convert';

class EditProductPage extends StatefulWidget {
  final Product product;

  EditProductPage({required this.product});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _estoqueController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();

  String? _nameError;
  String? _priceError;
  String? _estoqueError;
  String? _imageUrlError;
  String? _detailsError;
  String? _categoryError;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name;
    _priceController.text = widget.product.price.toStringAsFixed(2);
    _estoqueController.text = widget.product.estoque.toString();
    _imageUrlController.text = widget.product.imageUrl;
    _detailsController.text = widget.product.details;
    _categoryController.text = widget.product.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _estoqueController.dispose();
    _imageUrlController.dispose();
    _detailsController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _validateFields() {
    setState(() {
      _nameError = _nameController.text.isEmpty ? 'Campo obrigatório' : null;
      _priceError =
      _priceController.text.isEmpty ? 'Campo obrigatório' : null;
      _estoqueError =
      _estoqueController.text.isEmpty ? 'Campo obrigatório' : null;
      _imageUrlError =
      _imageUrlController.text.isEmpty ? 'Campo obrigatório' : null;
      _detailsError =
      _detailsController.text.isEmpty ? 'Campo obrigatório' : null;
      _categoryError =
      _categoryController.text.isEmpty ? 'Campo obrigatório' : null;
    });

    if (_nameError == null &&
        _priceError == null &&
        _estoqueError == null &&
        _imageUrlError == null &&
        _detailsError == null &&
        _categoryError == null) {
      var id = widget.product.id;
      Product newProduct = Product(
        id: id,
        name: _nameController.text,
        imageUrl: _imageUrlController.text,
        price: double.parse(_priceController.text),
        estoque: int.parse(_estoqueController.text),
        details: _detailsController.text,
        category: _categoryController.text,
      );

      FireStore.atualizarProduto(newProduct);

      Fluttertoast.showToast(
        msg: 'Produto atualizado com sucesso!',
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Produto'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  errorText: _nameError,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Preço',
                  errorText: _priceError,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _estoqueController,
                decoration: InputDecoration(
                  labelText: 'Estoque',
                  errorText: _estoqueError,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'URL da Imagem',
                  errorText: _imageUrlError,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _detailsController,
                decoration: InputDecoration(
                  labelText: 'Detalhes',
                  errorText: _detailsError,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  errorText: _categoryError,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _validateFields,
                child: const Text('Salvar Alterações'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
