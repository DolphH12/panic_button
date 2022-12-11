import 'package:flutter/material.dart';
import 'package:panic_app/utils/utils.dart';
import 'select_button_emergency.dart';

class SelectEmergencyWidget extends StatelessWidget {
  const SelectEmergencyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> labels = [
      "Robo a personas",
      "Accidente",
      "Acoso",
      "Violencia intrafamiliar",
      "Violencia de genero",
      "Extorsion",
      "Desastre",
      "Secuestro",
      "Homicidio",
      "Otro",
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 50),
        itemCount: labels.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 1, mainAxisSpacing: 10),
        itemBuilder: (context, index) => SelectButtonWidget(
          tipo: labels[index],
          color: colors[index],
          icon: Icons.warning,
          type: index + 2,
        ),
      ),
    );
  }
}
