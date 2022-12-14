import 'package:flutter/material.dart';
import 'package:panic_app/services/user_service.dart';

import '../models/user_general_model.dart';
import '../utils/utils.dart';
import '../widgets/button_main_widget.dart';
import '../widgets/custom_input.dart';
import '../widgets/labels.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 239, 239, 239),
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
                _labelRegister()
              ],
            ),
          ),
        ));
  }

  Widget _labelRegister() {
      return Column(
        children: [
          const Text(
            "¿Ya tienes una cuenta?",
            style: TextStyle(
                color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<void>(
              builder: (BuildContext context){
                return const LoginPage();
                },
              ),  (Route<dynamic> route) => false,
            );
            },
            child: Text(
              "Inicia sesión",
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    }

  Widget _tituloPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10,),
        Text(
          'Botón de pánico',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        const Text(
          'Registro',
          style: TextStyle(
              color: Colors.black54, fontSize: 25, fontWeight: FontWeight.bold),
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
  final pass2Ctrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final cellCtrl = TextEditingController();

  UsuarioService usuarioService = UsuarioService();
  late UserGeneralModel registro;
  // final PreferenciasUsuario _prefs = PreferenciasUsuario();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
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
            icon: Icons.email,
            placehoder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.phone_android,
            placehoder: 'Celular',
            keyboardType: TextInputType.number,
            textController: cellCtrl,
          ),
          CustomInput(
              icon: Icons.password_outlined,
              placehoder: 'Contraseña',
              textController: passCtrl,
              keyboardType: TextInputType.text,
              isPassword: true),
          CustomInput(
              icon: Icons.password_outlined,
              placehoder: 'Repetir Contraseña',
              textController: pass2Ctrl,
              keyboardType: TextInputType.text,
              isPassword: true),
          const SizedBox(
            height: 20,
          ),
          inputTermyCond(),
          ButtonMainWidget(
            textobutton: 'Registrarme',
            onPressed: () => _onSubmit(context),
          )
        ],
      ),
    );
  }

  void _onSubmit(BuildContext context) async {
    if (passCtrl.text == pass2Ctrl.text) {
      if (userCtrl.text.contains(' ')) {
        if (!mounted) return;
        mostrarAlerta(context, 'Verifica que no tengas espacios en tu usuario');
      } else if (isChecked) {
        registro = UserGeneralModel(
            username: userCtrl.text,
            password: passCtrl.text,
            email: emailCtrl.text,
            cellPhone: cellCtrl.text);
        final Map info = await usuarioService.nuevoUsuario(registro);
        if (info['ok']) {
          if (!mounted) {}
          Navigator.pushNamed(context, 'otp', arguments: registro.email);
        } else {
          if (!mounted) {}
          mostrarAlerta(context, info['mensaje']);
        }
      } else {
        mostrarAlerta(context, "Recuerde aceptar los términos y condiciones.");
      }
    } else {
      mostrarAlerta(context, "Las contraseñas no coinciden");
    }
  }

  Widget inputTermyCond() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          activeColor: Theme.of(context).primaryColor,
          value: isChecked,
          onChanged: (value) {
            setState(() {
              isChecked = value!;
            });
          },
        ),
        GestureDetector(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) => _termsyconds());
          },
          child: const Text(
            'Términos y condiciones*',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        )
      ],
    );
  }

  Widget _termsyconds() {
    return AlertDialog(
      scrollable: true,
      title: const Text(
        "Términos y condiciones",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
      content: const Text(
        "Contenido para términos y Condiciones",
        style: TextStyle(fontSize: 10),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        Center(
          child: ButtonMainWidget(
              textobutton: "Cerrar",
              onPressed: () => Navigator.pop(context, 'OK')),
        ),
      ],
    );
    // return FutureBuilder(
    //   future: usuarioProvider.cargarTermyCond(),
    //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //     if (snapshot.hasData) {
    //       final termsandconds = snapshot.data;

    //       return AlertDialog(
    //         scrollable: true,
    //         title: const Text(
    //           "Terminos y condiciones",
    //           style: TextStyle(
    //             fontSize: 20,
    //             fontWeight: FontWeight.w700,
    //           ),
    //           textAlign: TextAlign.center,
    //         ),
    //         content: Text(
    //           termsandconds,
    //           style: TextStyle(fontSize: 10),
    //           textAlign: TextAlign.center,
    //         ),
    //         actions: <Widget>[
    //           Center(
    //             child: GFButton(
    //               onPressed: () => Navigator.pop(context, 'OK'),
    //               text: "Cerrar",
    //               shape: GFButtonShape.pills,
    //               type: GFButtonType.outline2x,
    //               color: Colors.red[900]!,
    //               padding: const EdgeInsets.symmetric(horizontal: 50),
    //             ),
    //           ),
    //         ],
    //       );
    //     } else {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //   },
    // );
  }
}
