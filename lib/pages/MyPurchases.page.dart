import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPurchasesPage extends StatefulWidget {
  const MyPurchasesPage({Key? key}) : super(key: key);

  @override
  _MyPurchasesPageState createState() => _MyPurchasesPageState();
}

class _MyPurchasesPageState extends State<MyPurchasesPage> {
  List<Map<String, dynamic>> compras = [];
  double totalGasto = 0.0;

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    loadPurchases();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> loadPurchases() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    Map<String, dynamic> user = jsonDecode(userJson ?? '{}');

    final snapshot = await FirebaseFirestore.instance
        .collection('Usuario')
        .doc(user["documento"])
        .get();

    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null && data.containsKey('compras')) {
        setState(() {
          compras = List<Map<String, dynamic>>.from(data['compras']);
          totalGasto = calculateTotalSpent(compras);
        });
      }
    }
  }

  double calculateTotalSpent(List<Map<String, dynamic>> purchases) {
    double total = 0.0;
    for (final purchase in purchases) {
      total += purchase['price'];
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Compras'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: compras.length,
              itemBuilder: (context, index) {
                final compra = compras[index];

                return Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Image.network(
                        compra['imageUrl'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              compra['name'],
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              compra['details'],
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        'R\$ ${compra['price']}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Valor total gasto: R\$ $totalGasto',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
