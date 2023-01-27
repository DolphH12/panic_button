import 'package:flutter/material.dart';

class ContactWidget extends StatelessWidget {
  const ContactWidget(
      {super.key,
      required this.name,
      required this.email,
      required this.cellPhone});

  final String name;
  final String email;
  final String cellPhone;

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
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 5),
                    blurRadius: 15)
              ]),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          borderRadius: BorderRadius.circular(100)),
                    ),
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/alert.png"),
                      radius: 25,
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      email,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      cellPhone,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
