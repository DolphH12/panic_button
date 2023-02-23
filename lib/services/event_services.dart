import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../utils/preferencias_app.dart';

class EventService {
  final _prefs = PreferenciasUsuario();
  final ip = 'http://sistemic.udea.edu.co:4000';
  
  Future<bool> addEvent(Position location, int type, String comment) async {
    
    final username = _prefs.username;

    var headers = {
      'Authorization': 'Bearer ${_prefs.token}',
      'Content-Type': 'application/json',
      'Cookie': 'color=rojo'
    };
    var request = http.Request(
        'POST', Uri.parse('$ip/reto/events/eventos/crear/usuario/$username'));
    request.body = json.encode({
      "location": [location.latitude, location.longitude],
      "typeEmergency": type,
      "comment": comment
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print(await response.stream.bytesToString());
      return true;
    } else {
      // print(response.reasonPhrase);
      return false;
      // print(response.reasonPhrase);
    }
  }

  Future<bool> attachFiles(List? image, String? audio, List? video) async {
    final username = _prefs.username;

    var headers = {
      'Authorization': 'Bearer ${_prefs.token}',
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('$ip/reto/events/files/anexar/usuarios/$username'));
    
    print(video);
    print(image);

    image!.isEmpty ? null : request.files.add(await http.MultipartFile.fromPath('imagenes', image[0].path));
    audio == null  ? null : request.files.add(await http.MultipartFile.fromPath('audios', audio));
    video![0] == "" ? null : request.files.add(await http.MultipartFile.fromPath('videos', video[0]));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print(await response.stream.bytesToString());
      return true;
    } else {
      print(response.reasonPhrase);
      return false;
    }
  }

  Future<List<dynamic>> allEvents() async {
    var headers = {
      'Authorization': 'Bearer ${_prefs.token}',
      'Cookie': 'color=rojo'
    };
    var request =
        http.Request('GET', Uri.parse('$ip/reto/events/eventos/listar'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    final List<dynamic> decodeData =
        json.decode(await response.stream.bytesToString());

    return decodeData;
  }

  Future<List<dynamic>> zoneEvents(String zone) async {
    var headers = {
      'Authorization': 'Bearer ${_prefs.token}',
      'Cookie': 'color=rojo; color=rojo'
    };
    var request = http.Request(
        'GET', Uri.parse('$ip/reto/events/eventos/listar/zona/$zone'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final List<dynamic> decodeData =
        json.decode(await response.stream.bytesToString());

    return decodeData;
  }

  Future<List<dynamic>> statusEvents(String status) async {
    var headers = {
      'Authorization': 'Bearer ${_prefs.token}',
      'Cookie': 'color=rojo; color=rojo'
    };

    var request = http.Request(
        'GET', Uri.parse('$ip/reto/events/eventos/listar/status/$status'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final List<dynamic> decodeData =
        json.decode(await response.stream.bytesToString());

    return decodeData;
  }

  Future<Map<String, dynamic>> eventMedia(String userId) async {
    print("LLEGUE");
    var headers = {'Authorization': 'Bearer ${_prefs.token}'};
    var request =
        http.Request('GET', Uri.parse('$ip/reto/events/files/obtener/$userId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final Map<String, dynamic> decodeData =
        jsonDecode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      print("TERMINÉ");
      return decodeData;
    } else {
      print(response.reasonPhrase);
    }

    return {'error': 'No fue posible recuperar los archivos'};
  }

  Future<Map<String, dynamic>> getEvents() async {
    var headers = {
      'Authorization': 'Bearer ${_prefs.token}',
      'Cookie': 'color=rojo'
    };

    try {
      var request =
          http.Request('GET', Uri.parse('$ip/reto/events/eventos/listar'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode != 200) throw Exception('${response.statusCode}');

      return {
        'status': true,
        'data': jsonDecode(await response.stream.bytesToString())
      };
    } catch (e) {
      return {
        'status': false,
        'data': {'message': e.toString()}
      };
    }
  }

  Future<Map<String, dynamic>> getZones() async {
    var headers = {'Authorization': 'Bearer ${_prefs.token}'};

    try {
      final response = await http.get(
          Uri.parse('http://sistemic.udea.edu.co:4000/reto/zonas/zonas/listar'),
          headers: headers);

      if (response.statusCode != 200) throw Exception('${response.statusCode}');

      return {'status': true, 'data': jsonDecode(response.body)};
    } catch (e) {
      return {
        'status': false,
        'data': {'message': e.toString()}
      };
    }
  }

  Future<List<dynamic>> getListEvents() async {
    var headers = {
      'Authorization': 'Bearer ${_prefs.token}',
      'Cookie': 'color=rojo'
    };

    var request = http.Request(
        'GET', Uri.parse('$ip/parametrizacion/boton/reporttype/listar'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    final List decodeData = json.decode(await response.stream.bytesToString());

    if (response.statusCode == 200) {
      return decodeData;
    } else {
      return [];
    }
  }
  Future<Map<String, dynamic>> getEmergency() async {
    var headers = {
      //'Authorization': 'Bearer ${_prefs.token}',
      'Cookie': 'color=rojo'
    };

    try {
      var request =
          http.Request('GET', Uri.parse('$ip/parametrizacion/boton/emergencyagency/listar'));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode != 200) throw Exception('${response.statusCode}');

      return {
        'status': true,
        'data': jsonDecode(await response.stream.bytesToString())
      };
    } catch (e) {
      return {
        'status': false,
        'data': {'message': e.toString()}
      };
    }
  }
}
