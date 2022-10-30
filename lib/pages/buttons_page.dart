import 'package:flutter/material.dart';
import 'package:panic_app/utils/utils.dart';
import '../widgets/select_button_emergency.dart';

class ButtonsPage extends StatelessWidget {
  const ButtonsPage({Key? key}) : super(key: key);

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
        body: const SelectEmergencyWidget());
  }
}

class SelectEmergencyWidget extends StatelessWidget {
  const SelectEmergencyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> labels = [
      "Robo Personas",
      "Riñas",
      "Secuestro",
      "Robo en vivienda",
      "Extorsión",
      "Homicidio",
      "Robo Vehiculos",
      "Desastres Naturales",
      "Accidentes Transito",
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: GridView.builder(
        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 50),
        itemCount: labels.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 3, mainAxisSpacing: 8),
        itemBuilder: (context, index) => SelectButtonWidget(
          tipo: labels[index],
          color: colors[index],
          type: index + 2,
        ),
      ),
    );
  }
}
