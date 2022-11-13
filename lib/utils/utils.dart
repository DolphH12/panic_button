import 'package:flutter/material.dart';

import '../widgets/btn_ppal.dart';

void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Algo salió mal'),
          content: Text(mensaje),
          actions: [
            Container(
              margin: const EdgeInsets.only(right:50, left:50, bottom: 25),
              child: BtnPpal(
                  textobutton: "Cerrar",
                  onPressed: () => Navigator.pop(context, 'OK')),
            ),
          ],
        );
      });
}

void mensajeInfo(BuildContext context, String titulo, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: mensaje!="" ?Text(mensaje): null,
        );
      });
}

const List<Color> colors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black,
];
