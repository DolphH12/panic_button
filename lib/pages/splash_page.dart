import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3),
        () => Navigator.pushNamed(context, 'login'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: FadeInUp(
        duration: const Duration(seconds: 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _logoApp(),
            const SizedBox(
              height: 20,
            ),
            _tituloApp(),
          ],
        ),
      ),
    ));
  }

  Widget _tituloApp() {
    return Text(
      'Botón de pánico',
      style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 30,
          fontWeight: FontWeight.bold),
    );
  }

  Widget _logoApp() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
              color: Colors.grey[200]),
        ),
        const Hero(
          tag: "initImage",
          child: Image(
            image: AssetImage('assets/alert.png'),
            width: 300,
          ),
        )
      ],
    );
  }
}
