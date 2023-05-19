import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FireStore {
  static var database = FirebaseFirestore.instance;

  static createUser(String login, String nome, String senha) {
    final newUser = <String, String>{
      "id": const Uuid().v4(),
      "login": login,
      "nome": nome,
      "senha": senha,
      "role": "cliente"
    };

    database
        .collection("Usuario")
        .doc("kwRAPneCkaBmgLmxCmpL")
        .set(newUser)
        .onError((error, stackTrace) => 0); // retorna 0 em caso de erro
  }
}
