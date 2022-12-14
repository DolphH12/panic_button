import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import 'package:panic_app/services/services.dart';
import '../utils/preferencias_app.dart';
import '../utils/utils.dart';
import 'package:panic_app/widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    
    final Size size = MediaQuery.of(context).size;

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
                    height: size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        _tituloPage(),
                        const _Form(),
                        const SizedBox(height: 1),
                      ],
                    ),
                  ),
                )
              )
            ),
      ),
    );
  }

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Botón de pánico'),
            content: const Text('¿Quieres salir de la app?'),
            actions: [

              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),

              ElevatedButton(
                onPressed: () =>SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: const Text('Si'),
              ),
            ],
          ),
        ) ?? false; 
  }

  Widget _tituloPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Text(
          'Botón de pánico',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 30,
              fontWeight: FontWeight.bold
          ),
        ),

        const SizedBox(height: 20),
        const Hero(
          tag: "initImage",
          child: Image(
            image: AssetImage('assets/alert.png'),
            width: 140,
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

  Widget _labelLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        const Text(
          "¿No tiene cuenta? ",
          style: TextStyle(
              color: Colors.black54, 
              fontSize: 16, 
              fontWeight: FontWeight.w300
          ),
        ),
        const SizedBox(height: 10),

        GestureDetector(
          onTap: () => Navigator.pushNamed(context, "register"),
          child: Text(
            "Registrate",
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35),
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
              isPassword: true
          ),

          const SizedBox(height: 20),

          ButtonMainWidget(
            textobutton: 'Iniciar sesión',
            onPressed: () {
              final progress = ProgressHUD.of(context);
              _onSubmit(context);
              progress!.show();
              Future.delayed(const Duration(seconds: 5), () => progress.dismiss());
            },
          ),

          const SizedBox(height: 20),
          _labelLogin(),
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
        if (seen) {
          Navigator.pushReplacementNamed(context, 'home');
        } else {
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
