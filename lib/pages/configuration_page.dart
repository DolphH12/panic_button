import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:panic_app/services/user_service.dart';
import 'package:panic_app/widgets/btn_ppal.dart';
import 'package:panic_app/widgets/custom_input.dart';

import '../../utils/preferencias_app.dart';
import '../../utils/utils.dart';
import '../../widgets/btn_casual.dart';

class ConfigurationPage extends StatelessWidget {
  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColorDark,
        elevation: 0,
        leadingWidth: 200,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: const [
                Icon(Icons.arrow_back_ios_new),
                Text("Regresar")
              ],
            ),
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(15.0),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          child: ContainConfiguration(),
        ),
      ),
    );
  }
}

class ContainConfiguration extends StatefulWidget {
  const ContainConfiguration({super.key});

  @override
  State<ContainConfiguration> createState() => _ContainConfigurationState();
}

class _ContainConfigurationState extends State<ContainConfiguration> {
  int type = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Configs(
            title: "Perfil",
            subtitle: "Cambia tu nombre",
            icon: Icons.person_pin_rounded,
            onPressed: () {
              setState(() {
                type = 1;
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Configs(
            title: "Boton",
            subtitle: "Cambia el color",
            icon: Icons.radio_button_checked,
            onPressed: () {
              setState(() {
                type = 2;
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ConfigView(type: type)
        ],
      ),
    );
  }
}

class Configs extends StatelessWidget {
  const Configs(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon,
      required this.onPressed});

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        leading: Icon(icon),
        onTap: onPressed,
      ),
    );
  }
}

class ConfigView extends StatefulWidget {
  const ConfigView({super.key, required this.type});

  final int type;

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  UsuarioService usuarioService = UsuarioService();
  PreferenciasUsuario prefs = PreferenciasUsuario();
  String state = "";
  Color pickerColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    if (pickerColor == Colors.transparent) {
      pickerColor = prefs.colorButton;
    }
    return widget.type == 0
        ? const SizedBox()
        : widget.type == 1
            ? Column(
                children: [
                  CustomInput(
                      icon: Icons.person_pin,
                      placehoder: "Nombre",
                      textController: nameCtrl,
                      keyboardType: TextInputType.name),
                  CustomInput(
                      icon: Icons.devices_fold,
                      placehoder: "Apellido",
                      textController: lastNameCtrl,
                      keyboardType: TextInputType.text),
                  BtnPpal(textobutton: "Enviar", onPressed: continuedPerfil)
                ],
              )
            : Column(
                children: [
                  BtnCasual(
                      textobutton: 'Selecciona color',
                      onPressed: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Color'),
                              content: BlockPicker(
                                pickerColor: pickerColor,
                                onColorChanged: (value) => setState(() {
                                  pickerColor = value;
                                }),
                                availableColors: colors,
                              ),
                              actions: [
                                BtnCasual(
                                    textobutton: 'Aceptar',
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    width: 100,
                                    colorBtn: Theme.of(context).primaryColor)
                              ],
                            ),
                          ),
                      width: 150,
                      colorBtn: pickerColor),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: pickerColor,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(3, 3),
                              blurRadius: 10)
                        ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  BtnPpal(textobutton: "Cambiar", onPressed: continuedColor)
                ],
              );
  }

  continuedPerfil() async {
    if (nameCtrl.text.isNotEmpty && lastNameCtrl.text.isNotEmpty) {
      state = await usuarioService.updateUser(nameCtrl.text, lastNameCtrl.text);
      if (!mounted) {}
      Future.delayed(
        const Duration(seconds: 2),
        () => Navigator.pushReplacementNamed(context, 'home'),
      );
      if (state == 'ok') {
        mensajeInfo(context, "Completado", "Actualización Exitosa.");
      } else {
        mensajeInfo(context, "Error",
            "Falló algo en la actualización. Intentalo luego");
      }
    } else if (nameCtrl.text.isNotEmpty && lastNameCtrl.text.isEmpty ||
        nameCtrl.text.isEmpty && lastNameCtrl.text.isNotEmpty) {
      mensajeInfo(
          context, "Algo anda mal", "Por favor llena los dos datos o ninguno");
    } else {
      Navigator.pop(context);
    }
  }

  continuedColor() {
    prefs.colorButton = pickerColor;
    Future.delayed(const Duration(seconds: 2),
        (() => Navigator.pushReplacementNamed(context, 'home')));
    mensajeInfo(context, "¡Cambio realizado!", "Personalización completa");
  }
}
