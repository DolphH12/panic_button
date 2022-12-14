import 'package:flutter/material.dart';

class ButtonCasualWidget extends StatelessWidget {
  final String textobutton;
  final VoidCallback onPressed;
  final double width;
  final Color colorBtn;

  const ButtonCasualWidget({
    Key? key,
    required this.textobutton,
    required this.onPressed,
    required this.width,
    required this.colorBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: raisedButtonStyle(context),
        onPressed: onPressed,
        child: SizedBox(
          width: width,
          height: 45,
          child: Center(
            child: Text(
              textobutton,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ));
  }

  ButtonStyle raisedButtonStyle(BuildContext context) =>
      ElevatedButton.styleFrom(
        backgroundColor: colorBtn,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      );
}
