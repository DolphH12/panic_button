import 'package:flutter/material.dart';
import 'package:panic_app/utils/preferencias_app.dart';
import 'package:panic_app/utils/utils.dart';
import 'package:panic_app/widgets/audio_palyer_widget.dart';
import 'package:panic_app/widgets/btn_casual.dart';
import 'package:panic_app/widgets/camera_image_widget.dart';
import 'package:panic_app/widgets/custom_input.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context)!.settings.arguments as List;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColorDark,
        elevation: 0,
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Row(
              children: const [
                Icon(Icons.arrow_back_ios_new),
                Text("Regresar")
              ],
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Agrega información",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: ContainPresentation(type: args),
        ),
      ),
    );
  }
}

class ContainPresentation extends StatefulWidget {
  const ContainPresentation({super.key, required this.type});

  final List type;

  @override
  State<ContainPresentation> createState() => _ContainPresentationState();
}

class _ContainPresentationState extends State<ContainPresentation> {
  TextEditingController tipoCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  TextEditingController ubiCtrl = TextEditingController();
  TextEditingController desUbiCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TipoDeEventoInfo(
            type: widget.type,
            controller: tipoCtrl,
          ),
          DescripcionEmergency(controller: descCtrl),
          UbicacionEmergencia(
              ubiController: ubiCtrl, descUbiController: desUbiCtrl),
          const EvidenciasEmergencia(),
          EnviarEmergencia(
            desUbiCtrl: desUbiCtrl,
            descCtrl: descCtrl,
            tipoCtrl: tipoCtrl,
            ubiCtrl: ubiCtrl,
          )
        ],
      ),
    );
  }
}

class TipoDeEventoInfo extends StatelessWidget {
  const TipoDeEventoInfo(
      {super.key, required this.type, required this.controller});

  final List type;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final disabled = type[1] == 'Otro';
    controller.text = disabled ? '' : type[1];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Tipo de Evento",
            style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        CustomInput(
          icon: Icons.emergency,
          placehoder: "Escribe el tipo",
          textController: controller,
          keyboardType: TextInputType.text,
          disabled: disabled,
        ),
      ],
    );
  }
}

class DescripcionEmergency extends StatefulWidget {
  const DescripcionEmergency({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<DescripcionEmergency> createState() => _DescripcionEmergencyState();
}

class _DescripcionEmergencyState extends State<DescripcionEmergency> {
  bool audio = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              const Text(
                "Describe la emergencia",
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () => mensajeInfo(context, "Información",
                      "Puedes agregar informacion o grabar un audio para describir el evento."),
                  icon: const Icon(Icons.info))
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 10,
              child: CustomInput(
                icon: Icons.messenger,
                placehoder: "Descripción",
                textController: widget.controller,
                keyboardType: TextInputType.text,
              ),
            ),
            Flexible(
              flex: 2,
              child: FloatingActionButton.small(
                onPressed: () => setState(() => audio = !audio),
                child: const Icon(Icons.mic),
              ),
            )
          ],
        ),
        audio ? const AudioPlayerWidget() : const SizedBox()
      ],
    );
  }
}

class UbicacionEmergencia extends StatelessWidget {
  const UbicacionEmergencia(
      {super.key,
      required this.ubiController,
      required this.descUbiController});

  final TextEditingController ubiController;
  final TextEditingController descUbiController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              const Text(
                "Ubicación del evento",
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () => mensajeInfo(context, "Información",
                      "Puedes agregar informacion acerca del evento. Si tu ubicación es diferente a la del evento, escribela."),
                  icon: const Icon(Icons.info))
            ],
          ),
        ),
        CustomInput(
          icon: Icons.location_on,
          placehoder: "Ubicación",
          textController: ubiController,
          keyboardType: TextInputType.text,
        ),
        CustomInput(
          icon: Icons.add_location,
          placehoder: "Descripcion de la Ubicación",
          textController: descUbiController,
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }
}

class EvidenciasEmergencia extends StatelessWidget {
  const EvidenciasEmergencia({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Evidencias Adicionales",
            style: TextStyle(
                color: Colors.black54,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        Center(child: CameraImageWidget())
      ],
    );
  }
}

class EnviarEmergencia extends StatefulWidget {
  const EnviarEmergencia(
      {super.key,
      required this.tipoCtrl,
      required this.descCtrl,
      required this.ubiCtrl,
      required this.desUbiCtrl});

  final TextEditingController tipoCtrl;
  final TextEditingController descCtrl;
  final TextEditingController ubiCtrl;
  final TextEditingController desUbiCtrl;

  @override
  State<EnviarEmergencia> createState() => _EnviarEmergenciaState();
}

class _EnviarEmergenciaState extends State<EnviarEmergencia> {
  PreferenciasUsuario prefs = PreferenciasUsuario();
  bool anonimo = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text(
                    "NO",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Switch(
                      activeColor: prefs.colorButton,
                      value: anonimo,
                      onChanged: (value) => setState(() => anonimo = value)),
                  // onChanged: null),
                  const Text(
                    "SI",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              const Text(
                "¿Enviar Anonimo?",
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BtnCasual(
                  textobutton: "Cancelar",
                  onPressed: () => Navigator.pop(context),
                  width: MediaQuery.of(context).size.width / 3,
                  colorBtn: Colors.grey),
              BtnCasual(
                  textobutton: "Enviar",
                  onPressed: () {
                    Navigator.pushNamed(context, 'home');
                    mensajeInfo(context, "Envío exitoso",
                        "Evidencias enviadas correctamente.");
                  },
                  width: MediaQuery.of(context).size.width / 3,
                  colorBtn: prefs.colorButton),
            ],
          )
        ],
      ),
    );
  }
}
