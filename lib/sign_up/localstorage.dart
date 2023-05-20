import 'package:mini_mercado_flutter/Entites/Usuario/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class localstorage {
  void saveUserToLocalStorage(Usuario usuario) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', usuario);
  }

  Future<String?> getUserFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user');
  }
}
