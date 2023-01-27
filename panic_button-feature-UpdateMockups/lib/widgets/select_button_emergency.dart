import 'dart:convert';

import 'package:flutter/material.dart';

class SelectButtonWidget extends StatelessWidget {
  const SelectButtonWidget(
      {super.key,
      required this.tipo,
      required this.color,
      required this.type,
      required this.icon});

  final String tipo;
  final Color color;
  final int type;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, "information", arguments: type);
        },
        style: ElevatedButton.styleFrom(
          elevation: 10,
          shadowColor: const Color.fromARGB(255, 19, 101, 223),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(0.0),
        ),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color,
                  color.withOpacity(0.7),
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
              borderRadius: BorderRadius.circular(15)),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: MemoryImage(base64Decode(icon)),
                  width: 50,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  tipo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
