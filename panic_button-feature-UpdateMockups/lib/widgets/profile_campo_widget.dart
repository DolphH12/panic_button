import 'package:flutter/material.dart';

class ProfileCampoWidget extends StatelessWidget {
  const ProfileCampoWidget(
      {super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(right: 20, top: 5, left: 5, bottom: 5),
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 5),
                    blurRadius: 15)
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
    );
  }
}
