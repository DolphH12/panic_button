import 'package:flutter/material.dart';

class ButtonMainWidget extends StatelessWidget {
  final String textobutton;
  final VoidCallback onPressed;

  const ButtonMainWidget({
    Key? key,
    required this.textobutton,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: raisedButtonStyle(context),
        onPressed: onPressed,
        child: SizedBox(
          width: double.infinity,
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
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      );
}
