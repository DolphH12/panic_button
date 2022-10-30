import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:panic_app/services/user_service.dart';
import 'package:panic_app/utils/preferencias_app.dart';

import '../utils/utils.dart';
import '../widgets/btn_ppal.dart';
import '../widgets/custom_input.dart';
import '../widgets/labels.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showExitPopup(),
      child: ProgressHUD(
        backgroundColor: Theme.of(context).primaryColorDark,
        child: Builder(
            builder: (context) => Scaffold(
                backgroundColor: const Color.fromARGB(250, 250, 250, 255),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _tituloPage(),
                        const _Form(),
                        const SizedBox(
                          height: 10,
                        ),
                        const Labels(
                            ruta: 'register',
                            label1: '¿No tienes una cuenta?',
                            label2: '¡Crea una ahora!'),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ))),
      ),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Boton de Panico'),
            content: const Text('Quieres salir de la app?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                //return true when click on "Yes"
                child: const Text('Si'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  Widget _tituloPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Boton de panico',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        const Hero(
          tag: "initImage",
          child: Image(
            image: AssetImage('assets/alert.png'),
            width: 150,
          ),
        )
      ],
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  UsuarioService usuarioService = UsuarioService();
  PreferenciasUsuario prefs = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.person,
            placehoder: 'Usuario',
            keyboardType: TextInputType.text,
            textController: userCtrl,
          ),
          CustomInput(
              icon: Icons.password_outlined,
              placehoder: 'Contraseña',
              textController: passCtrl,
              keyboardType: TextInputType.text,
              isPassword: true),
          const SizedBox(
            height: 20,
          ),
          BtnPpal(
            textobutton: 'Iniciar Sesión',
            onPressed: () {
              final progress = ProgressHUD.of(context);
              _onSubmit(context);
              progress!.show();
              Future.delayed(const Duration(seconds: 5), () {
                progress.dismiss();
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  void _onSubmit(BuildContext context) async {
    Map info = {};
    info = await usuarioService.login(userCtrl.text, passCtrl.text);

    if (info['ok']) {
      final seen = prefs.firstTime;
      Future.delayed(const Duration(seconds: 5), () {
        // Navigator.pushReplacementNamed(context, 'intro');
        if (seen) {
          Navigator.pushReplacementNamed(context, 'home');
        } else {
          prefs.firstTime = true;
          Navigator.pushReplacementNamed(context, 'intro');
        }
      });
    } else {
      if (userCtrl.text.contains(' ')) {
        if (!mounted) return;
        mostrarAlerta(context, 'Verifica que no tengas espacios en tu usuario');
      } else {
        if (!mounted) return;
        if (info['mensaje'] == "Bad credentials") {
          mostrarAlerta(context, "Usuario o contraseña incorrectos");
        } else {
          mostrarAlerta(context, info['mensaje']);
        }
      }
    }
  }
}
