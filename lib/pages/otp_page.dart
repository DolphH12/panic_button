import 'package:panic_app/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';

import '../utils/utils.dart';
import '../widgets/btn_ppal.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({Key? key}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String text = '';
  UsuarioService usuarioService = UsuarioService();
  String email = '';

  void _onKeyboardTap(String value) {
    setState(() {
      text = text + value;
    });
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text(
          text[position],
          style: const TextStyle(color: Colors.black),
        )),
      );
    } catch (e) {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final prodData = ModalRoute.of(context)?.settings.arguments;
    if (prodData != null) {
      email = prodData.toString();
      //preguntas  = prodData.preguntas[0];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _botonBack(context),
      body: _contenidoOTP(context),
    );
  }

  SafeArea _contenidoOTP(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              'Ingrese el código de 6 dígitos enviada a su correo $email.',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w500))),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            otpNumberWidget(0),
                            otpNumberWidget(1),
                            otpNumberWidget(2),
                            otpNumberWidget(3),
                            otpNumberWidget(4),
                            otpNumberWidget(5),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: BtnPpal(
                      textobutton: "Confirma",
                      onPressed: () async {
                        final Map info =
                            await usuarioService.codigoRegistro(text);
                        if (info['ok']) {
                          if (!mounted) {}
                          Future.delayed(
                            const Duration(seconds: 2),
                            () => Navigator.pushReplacementNamed(
                                context, 'login'),
                          );

                          mensajeInfo(context, "¡Bienvenido!",
                              "Su registro ha sido exitoso");
                        } else {
                          if (!mounted) {}
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Algo salio mal, Intentalo de nuevo.')));
                          Navigator.of(context).pop();
                        }
                      },
                    )),
                NumericKeyboard(
                  onKeyboardTap: _onKeyboardTap,
                  textColor: Theme.of(context).primaryColor,
                  rightIcon: Icon(
                    Icons.backspace,
                    color: Theme.of(context).primaryColor,
                  ),
                  rightButtonFn: () {
                    setState(() {
                      text = text.substring(0, text.length - 1);
                    });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  AppBar _botonBack(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: Theme.of(context).primaryColor.withAlpha(20),
          ),
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).primaryColor,
            size: 16,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }
}
