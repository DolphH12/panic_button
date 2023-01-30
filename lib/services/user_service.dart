import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_general_model.dart';
import '../utils/preferencias_app.dart';

class UsuarioService {
  final _prefs = PreferenciasUsuario();
  final ip = 'sistemic.udea.edu.co:4000';

  Future<Map<String, dynamic>> login(String usuario, String password) async {
    var headers = {
      'Authorization': 'Basic Zmx1dHRlci1yZXRvOnVkZWE=',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final request = http.Request(
        'POST', Uri.parse('http://$ip/reto/autenticacion/oauth/token'));
    request.bodyFields = {
      'username': usuario,
      'password': password,
      'grant_type': 'password'
    };
    request.headers.addAll(headers);

    try {
      print("PERRA");
      final http.StreamedResponse response = await request.send();

      final Map<String, dynamic> decodedResp =
          json.decode(await response.stream.bytesToString());
      _prefs.token = decodedResp['access_token'];
      _prefs.refreshToken = decodedResp['refresh_token'];
      _prefs.username = usuario;

      if (response.statusCode == 200) {
        return {'ok': true, 'token': decodedResp['access_token']};
      } else {
        return {'ok': false, 'mensaje': decodedResp["error_description"]};
      }
    } catch (e) {
      return {'ok': false, 'mensaje': "Bad credentials"};
    }
  }

  Future<bool> loginToRefresh(String refreshToken) async {
    var headers = {
      'Authorization': 'Basic Zmx1dHRlci1yZXRvOnVkZWE=',
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final request = http.Request(
        'POST', Uri.parse('http://$ip/reto/autenticacion/oauth/token'));
    request.bodyFields = {
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken
    };
    request.headers.addAll(headers);

    try {
      final http.StreamedResponse response = await request.send();

      final Map<String, dynamic> decodedResp =
          json.decode(await response.stream.bytesToString());
      _prefs.token = decodedResp['access_token'];
      _prefs.refreshToken = decodedResp['refresh_token'];

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(UserGeneralModel registro) async {
    _prefs.username = registro.username;

    final headers = {'Content-Type': 'application/json'};
    final request = http.Request(
        'POST', Uri.parse('http://$ip/reto/usuarios/registro/enviar'));
    request.body = userGeneralModelToJson(registro);
    request.headers.addAll(headers);

    final http.StreamedResponse response = await request.send();

    if (response.statusCode == 200 ||
        response.statusCode == 500 ||
        response.statusCode == 201) {
      return {'ok': true};
    } else {
      final decodedResp = json.decode(await response.stream.bytesToString());
      try {
        return {
          'ok': false,
          'mensaje': decodedResp["errors"][0]["defaultMessage"]
        };
      } catch (e) {
        return {'ok': false, 'mensaje': decodedResp["message"]};
      }
    }
  }

  Future<Map<String, dynamic>> codigoRegistro(String text) async {
    final username = _prefs.username;

    var headers = {'Cookie': 'color=rojo'};
    var request = http.MultipartRequest('POST',
        Uri.parse('http://$ip/reto/usuarios/registro/confirmar/$username'));
    request.fields.addAll({'codigo': text});

    request.headers.addAll(headers);

    final http.StreamedResponse response = await request.send();

    await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return {'ok': true};
    } else {
      return {'ok': false};
    }
  }

  Future<String> updateUser(String name, String lastName) async {
    final username = _prefs.username;
    var headers = {
      'Authorization': 'Bearer ${_prefs.token}',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'PUT', Uri.parse('http://$ip/reto/usuarios/usuarios/editar/$username'));
    request.body = json.encode({"name": name, "lastName": lastName});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return 'ok';
    } else {
      return 'none';
    }
  }

  Future<Map<String, dynamic>> profileUser() async {
    final user = _prefs.username;
    final token = _prefs.token;
    var headers = {'Authorization': 'Bearer $token', 'Cookie': 'color=rojo'};
    var request = http.Request(
        'GET', Uri.parse('http://$ip/reto/usuarios/usuarios/encontrar/$user'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final Map<String, dynamic> decodedResp =
        json.decode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      return decodedResp;
    } else {
      return {};
    }
  }
}
