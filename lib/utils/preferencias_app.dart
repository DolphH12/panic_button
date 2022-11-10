import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:
  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    await prefs.initPrefs();
    
    Recuerden que el main() debe de ser async {...
*/

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // TOKEN
  String get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  String get refreshToken {
    return _prefs.getString('refreshToken') ?? '';
  }

  set refreshToken(String value) {
    _prefs.setString('refreshToken', value);
  }

  // USERNAME
  String get username {
    return _prefs.getString('username') ?? '';
  }

  set username(String value) {
    _prefs.setString('username', value);
  }

  // PRIMERA VEZ
  bool get firstTime {
    return _prefs.getBool('fisrtTime') ?? false;
  }

  set firstTime(bool value) {
    _prefs.setBool('fisrtTime', value);
  }

  int get audio {
    return _prefs.getInt('audio') ?? 0;
  }

  set audio(int value) {
    _prefs.setInt('audio', value);
  }

  bool get button {
    return _prefs.getBool('button') ?? false;
  }

  set button(bool value) {
    _prefs.setBool('button', value);
  }

  Color get colorButton {
    return Color(_prefs.getInt('colorButton') ?? 0);
  }

  set colorButton(Color color) {
    _prefs.setInt('colorButton', color.value);
  }
}
