import 'package:flutter/material.dart';

class Labels extends StatefulWidget {
  const Labels(
      {Key? key,
      required this.ruta,
      required this.label1,
      required this.label2})
      : super(key: key);

  final String ruta;
  final String label1;
  final String label2;

  @override
  State<Labels> createState() => _LabelsState();
}

class _LabelsState extends State<Labels> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.label1,
          style: const TextStyle(
              color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, widget.ruta);
          },
          child: Text(
            widget.label2,
            style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
