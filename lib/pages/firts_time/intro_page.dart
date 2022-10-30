import 'package:flutter/material.dart';
import 'package:panic_app/widgets/btn_ppal.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Padding(
      padding: EdgeInsets.all(15.0),
      child: ContainIntro(),
    ));
  }
}

class ContainIntro extends StatelessWidget {
  const ContainIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              "Boton de Panico",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "Nuestra App le da una calurosa bienvenida!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Image(
          image: AssetImage('assets/settings.png'),
          width: 200,
        ),
        const Text(
          "Al ser la primera vez que ingresas te invitamos a configurar tu nueva cuenta.",
          style: TextStyle(
              color: Colors.black54, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        BtnPpal(
            textobutton: "Siguiente",
            onPressed: () => Navigator.pushNamed(context, 'presentation'))
      ],
    );
  }
}
