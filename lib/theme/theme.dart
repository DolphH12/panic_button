import 'package:flutter/material.dart';

final temaApp = ThemeData(
    colorScheme: temaApp2,
    primaryColor: const Color.fromRGBO(0, 86, 145, 1.0),
    primaryColorDark: const Color.fromRGBO(0, 74, 124, 1),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: Color.fromARGB(135, 0, 0, 0)),
      labelStyle: TextStyle(color: Color.fromRGBO(0, 86, 145, 1.0)),
    ),
    textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color.fromRGBO(0, 86, 145, 1.0)));

final temaApp2 = ThemeData().colorScheme.copyWith(
      primary: const Color.fromRGBO(0, 86, 145, 1.0),
      secondary: const Color.fromRGBO(0, 74, 124, 1),
    );
