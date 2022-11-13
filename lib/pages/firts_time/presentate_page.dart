import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:panic_app/services/user_service.dart';
import 'package:panic_app/widgets/btn_ppal.dart';
import 'package:panic_app/widgets/custom_input.dart';

import '../../utils/preferencias_app.dart';
import '../../utils/utils.dart';
import '../../widgets/btn_casual.dart';

class PresentationPage extends StatelessWidget {
  const PresentationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          child: ContainPresentation(),
        ),
      ),
    );
  }
}

class ContainPresentation extends StatelessWidget {
  const ContainPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Personaliza la App",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        const Expanded(child: StepPresentation())
      ],
    );
  }
}

class StepPresentation extends StatefulWidget {
  const StepPresentation({
    Key? key,
  }) : super(key: key);

  @override
  State<StepPresentation> createState() => _StepPresentationState();
}

class _StepPresentationState extends State<StepPresentation> {
  int currentStep = 0;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController lastNameCtrl = TextEditingController();
  UsuarioService usuarioService = UsuarioService();
  PreferenciasUsuario prefs = PreferenciasUsuario();
  String state = "";
  Color pickerColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Stepper(
        controlsBuilder: (context, details) {
          return BtnPpal(textobutton: 'Continuar', onPressed: continued);
        },
        type: StepperType.vertical,
        physics: const ScrollPhysics(),
        currentStep: currentStep,
        onStepTapped: (value) => tapped(value),
        onStepContinue: () => continued,
        onStepCancel: () => cancel,
        steps: [
          Step(
              title: const Text("Datos iniciales"),
              content: Column(
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
                ],
              ),
              isActive: currentStep > 0,
              state: currentStep > 0 ? StepState.complete : StepState.disabled),
          Step(
              title: const Text("Seleccionar color"),
              content: Column(
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
                ],
              ),
              isActive: currentStep > 0,
              state: currentStep > 0 ? StepState.complete : StepState.disabled),
        ]);
  }

  tapped(int value) {
    setState(() {
      currentStep = value;
    });
  }

  continued() async {
    if (currentStep == 0) {
      state = await usuarioService.updateUser(nameCtrl.text, lastNameCtrl.text);
      if (!mounted) {}
      state == 'ok'
          ? setState(() => currentStep += 1)
          : mostrarAlerta(context, "Falló algo en la actualización.");
      // setState(() => currentStep += 1);
    } else if (currentStep == 1) {
      prefs.colorButton = pickerColor;
      prefs.firstTime = true;
      Future.delayed(const Duration(seconds: 2),
          (() => Navigator.pushReplacementNamed(context, 'home')));
      mensajeInfo(context, "¡Felicidades!", "Personalización completa");
    }
  }

  cancel() {
    currentStep > 0 ? setState(() => currentStep -= 1) : null;
  }
}
