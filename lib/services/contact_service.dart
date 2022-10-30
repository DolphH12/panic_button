import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:panic_app/models/contacts_model.dart';

import '../utils/preferencias_app.dart';

class ContactService {
  final _prefs = PreferenciasUsuario();
  final ip = 'http://sistemic.udea.edu.co:4000';

  Future<List> getContacts() async {
    final String username = _prefs.username;
    var headers = {
      'Authorization': 'Bearer ${_prefs.token}',
      'Content-Type': 'application/json',
      'Cookie': 'color=rojo'
    };
    var request = http.Request(
        'GET', Uri.parse('$ip/reto/usuarios/contactos/listar/$username'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final List decodedResp = json.decode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      return decodedResp;
    } else {
      return [];
    }
  }

  Future<void> addContact(ContactModel model) async {
    final String username = _prefs.username;
    var headers = {
      'Authorization': 'Bearer ${_prefs.token}',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('$ip/reto/usuarios/contactos/crear/$username'));
    request.body = json.encode({
      "name": model.name,
      "lastName": model.lastName,
      "email": model.email,
      "cellPhone": model.cellPhone
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
