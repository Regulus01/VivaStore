import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mini_mercado_flutter/pages/home.page.dart';
import 'package:mini_mercado_flutter/sign_up/firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Entites/Product.dart';
import '../Entites/Usuario/usuario.dart';

class ConfirmationPage extends StatefulWidget {
  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  String cep = '';
  String endereco = '';
  String frete = '';
  bool compraConcluida = false;

  Future<void> buscarEndereco() async {
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        endereco =
            '${data['logradouro']}, ${data['bairro']}, ${data['localidade']}, ${data['uf']}';
      });
      if (endereco == 'null, null, null, null') {
        setState(() {
          endereco = 'Endereço não encontrado';
          frete = '';
          compraConcluida = false;
        });
      }
      if (endereco != 'Endereço não encontrado') {
        calcularFrete();
      }
    } else {
      setState(() {
        endereco = 'Endereço não encontrado';
        frete = '';
        compraConcluida = false;
      });
    }
  }

  Future<void> calcularFrete() async {
    String cepOrigem = '60130240';
    String cepDestino = cep;
    String peso = '1.5';
    String formato = '1';
    String comprimento = '20';
    String altura = '10';
    String largura = '15';
    String diametro = '0';

    String url =
        'https://melhorenvio.com.br/api/v2/calculator?from=$cepOrigem&to=$cepDestino&weight=$peso&length=$comprimento&width=$largura&height=$altura&diameter=$diametro';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final firstItem = jsonResponse[0];
      final freteValor = firstItem['price'];
      final fretePrazo = firstItem['delivery_time'];
      final tipo = firstItem["name"];
      setState(() {
        frete =
            'Frete: Tipo de envio $tipo - R\$ $freteValor - Prazo de Entrega: $fretePrazo dias';
        compraConcluida = true;
      });
    } else {
      setState(() {
        frete = 'Erro ao calcular frete';
        compraConcluida = false;
      });
    }
  }

  Future<void> atualizarCompras() async {
    // Adicionar as compras ao local storage
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    Map<String, dynamic> user = jsonDecode(userJson ?? '{}');

    var usuarioObject = Usuario.fromJson(user);

    var carrinho = usuarioObject.getCarrinho;

    // Atualizar o estoque dos produtos no Firebase
    await atualizarEstoqueProdutos(usuarioObject.getCarrinho);

    usuarioObject.compras.addAll(carrinho);
    usuarioObject.carrinho.clear();

    // Limpa carrinho no firebase
    FireStore.clearCart(user["documento"]);

    // da update nas compras no Firebase
    FireStore.updateCompras(user["documento"], usuarioObject.compras);
    // Converte o carrinho para JSON
    List<Map<String, dynamic>> carrinhoJson =
        usuarioObject.carrinho.map((product) => product.toJson()).toList();
    List<Map<String, dynamic>> comprasJson =
        usuarioObject.compras.map((product) => product.toJson()).toList();



    // Atribui o carrinho em JSON ao mapa do usuário
    user["carrinho"] = json.encode(carrinhoJson);
    user["compras"] = json.encode(comprasJson);

    // Sobrescrever o userJson pelo novo valor do user
    String newUserJson = jsonEncode(user);
    await prefs.setString('user', newUserJson);
    setState(() {
      compraConcluida = true;
    });
  }

  Future<void> atualizarEstoqueProdutos(List<Product> produtos) async {
    for (var produto in produtos) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Product')
          .where('id', isEqualTo: produto.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final produtoDoc = querySnapshot.docs.first;
        final data = produtoDoc.data();

        if (data.containsKey('estoque')) {
          int estoque = int.parse(data['estoque']);
          estoque -= 1;

          await produtoDoc.reference.update({'estoque': estoque.toString()});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmação de compra'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Digite o CEP',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  cep = value;
                });
              },
              enabled:
                  !compraConcluida, // Bloqueia a digitação quando compraConcluida for true
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (compraConcluida) {
                atualizarCompras();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: const Text('Compra Concluida!'),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () => Navigator.of(context)
                            .pushReplacement(MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        )),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else {
                buscarEndereco();
              }
            },
            child: compraConcluida
                ? const Text('Finalizar')
                : const Text('Buscar Endereço e Calcular Frete'),
          ),
          const SizedBox(height: 16),
          Text(endereco),
          const SizedBox(height: 16),
          Text(frete),
        ],
      ),
    );
  }
}
