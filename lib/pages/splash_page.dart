import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:panic_app/services/user_service.dart';
import 'package:panic_app/utils/preferencias_app.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    final prefs = PreferenciasUsuario();
    if (prefs.refreshToken.isNotEmpty) {
      final ok = access(prefs.refreshToken);
      Timer(const Duration(seconds: 5), () async {
        if (await ok) {
          Navigator.pushReplacementNamed(context, 'home');
        } else {
          Navigator.pushReplacementNamed(context, 'login');
        }
      });
    } else {
      Timer(const Duration(seconds: 3),
          () => Navigator.pushReplacementNamed(context, 'login'));
    }
  }

  Future<bool> access(String value) async {
    return await UsuarioService().loginToRefresh(value);
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
