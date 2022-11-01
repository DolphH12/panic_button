import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import '../utils/preferencias_app.dart';

class EventService {
  final _prefs = PreferenciasUsuario();
  final ip = 'http://sistemic.udea.edu.co:4000';

  Future<void> addEvent(Position location, int type, String comment) async {
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

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<bool> attachFiles(String? image, String? audio) async {
    final username = _prefs.username;
    // print("IMAGEN $image");
    // print("AUDIO $audio");

    var headers = {
      'Authorization': 'Bearer ${_prefs.token}',
    };

    var request = http.MultipartRequest('POST', Uri.parse('$ip/reto/events/files/anexar/usuarios/$username'));

    if(image == null || audio == null) {
      if((image == null) && !(audio == null)) {
        request.files.add(await http.MultipartFile.fromPath('audios', audio));
      } else if (!(image == null) && (audio == null)) {
        request.files.add(await http.MultipartFile.fromPath('imagenes', image));
      }
    } else {
      request.files.add(await http.MultipartFile.fromPath('imagenes', image));
      request.files.add(await http.MultipartFile.fromPath('audios', audio));
    }
    // request.files.add(await http.MultipartFile.fromPath('videos', '/path/to/file'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      print(await response.stream.bytesToString());
      return true;
    }
    else {
      print(response.reasonPhrase);
      return false;
    }

  }
}
