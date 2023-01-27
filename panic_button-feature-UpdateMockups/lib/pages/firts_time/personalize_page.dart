import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:panic_app/utils/preferencias_app.dart';
import 'package:panic_app/widgets/btn_casual.dart';
import 'package:panic_app/widgets/btn_ppal.dart';

class PersonalizePage extends StatelessWidget {
  const PersonalizePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          child: ContainPersonalize(),
        ),
      ),
    );
  }
}

class ContainPersonalize extends StatelessWidget {
  const ContainPersonalize({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Personaliza tu bóton",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        const Expanded(child: StepPersonalize())
      ],
    );
  }
}

class StepPersonalize extends StatefulWidget {
  const StepPersonalize({
    Key? key,
  }) : super(key: key);

  @override
  State<StepPersonalize> createState() => _StepPersonalizeState();
}

class _StepPersonalizeState extends State<StepPersonalize> {
  int currentStep = 0;
  Color pickerColor = Colors.grey;
  PreferenciasUsuario prefs = PreferenciasUsuario();

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
          Step(
              title: const Text("Código de confirmación"),
              content: Column(
                children: const [
                  Text(
                    "Esta ha sido la configuración... Continua para disfrutar de nuestra app",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
              isActive: currentStep > 0,
              state: currentStep > 0 ? StepState.complete : StepState.disabled)
        ]);
  }

  tapped(int value) {
    setState(() {
      currentStep = value;
    });
  }

  continued() {
    if (currentStep == 0) {
      // state = await usuarioService.updateUser(nameCtrl.text, lastNameCtrl.text);
      // if (!mounted) {}
      // state == 'ok'
      //     ? setState(() => currentStep += 1)
      //     : mostrarAlerta(context, "Fallo algo en la actualizacion.");
      prefs.colorButton = pickerColor;
      setState(() => currentStep += 1);
    } else if (currentStep == 1) {
      Navigator.pushReplacementNamed(context, 'home');
    }
  }

  cancel() {
    currentStep > 0 ? setState(() => currentStep -= 1) : null;
  }
}

const List<Color> colors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black,
];
