import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_background/flutter_background.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:url_launcher/url_launcher.dart';

import 'package:panic_app/services/background_service.dart';
import 'package:panic_app/utils/preferencias_app.dart';
import '../utils/confirm.dart';
import '../utils/utils.dart';
import '../widgets/buttons_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exitApp,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: const IconThemeData(size: 40),
        ),
        body: const ButtonPanicWidget(),
        drawer: const MenuDrawer(),
        floatingActionButton: const FloatingCall(),
      ),
    );
  }

  Future<bool> exitApp() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return true;
  }
}

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PreferenciasUsuario prefs = PreferenciasUsuario();
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                TituloDrawer(prefs: prefs),
                const SizedBox(
                  height: 25,
                ),
                ListTile(
                  title: const Text(
                    "Perfil",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text(
                    "Revisa tu información",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  leading: const Icon(Icons.person),
                  onTap: () => Navigator.pushNamed(context, 'profile'),
                ),
                const SizedBox(
                  height: 25,
                ),
                ListTile(
                  title: const Text(
                    "Contactos",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text(
                    "Agrega tus contactos de emergencia",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  leading: const Icon(Icons.person_add_rounded),
                  onTap: () => Navigator.pushNamed(context, 'contacts'),
                ),
                const SizedBox(
                  height: 25,
                ),
                ListTile(
                  title: const Text(
                    "Configuración",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text(
                    "Configura nuevamente tu cuenta",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  leading: const Icon(Icons.settings),
                  onTap: () => Navigator.pushNamed(context, 'config'),
                ),
                const SizedBox(
                  height: 25,
                ),
                ListTile(
                  title: const Text(
                    "Visualizador de eventos",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text(
                    "Visualiza los eventos generados en la ciudad",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  leading: const Icon(Icons.map),
                  onTap: () => Navigator.pushNamed(context, 'selectMap'),
                ),
                const SizedBox(
                  height: 25,
                ),
                const SwicthBtnPanic(),
              ],
            ),
            ListTile(
              title: const Text(
                "Cerrar sesión",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text(
                "Salir de la aplicación",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              trailing: const Icon(Icons.exit_to_app_rounded),
              onTap: () {
                prefs.token = "";
                prefs.refreshToken = "";
                Navigator.pushReplacementNamed(context, 'login');
              },
            )
          ],
        ),
      ),
    );
  }
}

class SwicthBtnPanic extends StatefulWidget {
  const SwicthBtnPanic({
    Key? key,
  }) : super(key: key);

  @override
  State<SwicthBtnPanic> createState() => _SwicthBtnPanicState();
}

class _SwicthBtnPanicState extends State<SwicthBtnPanic> {
  final PreferenciasUsuario _prefs = PreferenciasUsuario();

  var _speech = stt.SpeechToText();
  String _text = "";
  Timer? timer;
  int seconds = 3;
  // int confirm = 0;
  String text = "Start Service";
  Confirm confirm = Confirm();

  void stopVoice() {
    _text = "";
    timer?.cancel();
    _speech.stop();
    setState(() {});
  }

  void startTimer() {
    confirm.counter = 0;
    _text = "";
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => seconds--);
      if (seconds == 0) {
        _listen();
        seconds = 3;
      }
    });
  }

  Future<void> emergenciaVoz() async {
    print("hola");
    Position position = await determinePosition();
    final buttonemergency =
        await eventService.addEvent(position, 1, "Evento externo, por voz");

    print(buttonemergency);
    if (buttonemergency == 'ok') {
      if (!mounted) return;
      mensajeInfo(
          context, "Emergencia por voz", "Emergencia generada correctamente.");
    }
  }

  void _listen() async {
    bool available = await _speech.initialize(
        onStatus: (value) async => {
              print("onStatusR: $value"),
              print("confirm en ${confirm.counter}"),
              if ((value == "done" && confirm.counter == 2))
                {emergenciaVoz(), print("Emergencia"), confirm.counter = 0}
            },
        onError: (value) => print("onStatusERROR: $value"));

    if (available) {
      _speech.listen(
        onResult: (value) => setState(() {
          _text = value.recognizedWords;
          if ((_text.contains("ayuda") || _text.contains("Ayuda"))) {
            confirm.counter++;
            print(confirm.counter);

            _text = "";
            timer?.cancel();
            _speech.stop();
            _prefs.button = false;
            activacion.stopListening();
            setState(() {});
          }
        }),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        "Botón externo",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      ),
      subtitle: Row(
        children: [
          const Text(
            "NO",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Switch(
              activeColor: _prefs.colorButton,
              value: _prefs.button,
              onChanged: (value) async {
                _prefs.button = value;
                if (value) {
                  await FlutterBackground.enableBackgroundExecution();
                  activacion.startListening(_speech, timer);
                  startTimer();
                  // if(!mounted) return;
                  // Navigator.pushReplacementNamed(context, 'home');
                } else {
                  activacion.stopListening();
                  stopVoice();
                }
                setState(() {});
              }),
          // onChanged: null),
          const Text(
            "SI",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      leading: const Icon(Icons.radio_button_checked),
      onTap: () => Navigator.pop(context),
    );
  }
}

class TituloDrawer extends StatelessWidget {
  const TituloDrawer({
    Key? key,
    required this.prefs,
  }) : super(key: key);

  final PreferenciasUsuario prefs;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [prefs.colorButton, prefs.colorButton.withOpacity(0.9)],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
            borderRadius:
                const BorderRadius.only(bottomRight: Radius.circular(80))),
        child: Column(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage("assets/usuario.png"),
              radius: 45,
              backgroundColor: Colors.white,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              prefs.username,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}

class ButtonPanicWidget extends StatelessWidget {
  const ButtonPanicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    PreferenciasUsuario prefs = PreferenciasUsuario();
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Botón de pánico",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: prefs.colorButton,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Usuario ${prefs.username}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: prefs.colorButton.withOpacity(0.8),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "Presiona en caso de emergencia",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Expanded(child: SelectEmergencyWidget()),
            ],
          ),
        ),
      ),
    );
  }
}

class FloatingCall extends StatefulWidget {
  const FloatingCall({super.key});

  @override
  State<FloatingCall> createState() => _FloatingCallState();
}

class _FloatingCallState extends State<FloatingCall>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  PreferenciasUsuario prefs = PreferenciasUsuario();

  static const List<IconData> icons = [
    Icons.local_police,
    Icons.notification_important
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color foregroundColor = prefs.colorButton;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(icons.length, (int index) {
        Widget child = Container(
          height: 60.0,
          width: 50.0,
          alignment: FractionalOffset.topCenter,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: _controller,
              curve: Interval(0.0, 1.0 - index / icons.length / 2.0,
                  curve: Curves.easeOut),
            ),
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: backgroundColor,
              child: Icon(icons[index], color: foregroundColor),
              onPressed: () async {
                if (index == 0) {
                  final call = Uri.parse('tel:123');
                  if (await canLaunchUrl(call)) {
                    launchUrl(call);
                  } else {
                    throw 'Could not launch $call';
                  }
                } else {
                  final call = Uri.parse('tel:119');
                  if (await canLaunchUrl(call)) {
                    launchUrl(call);
                  } else {
                    throw 'Could not launch $call';
                  }
                }
              },
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          FloatingActionButton(
            backgroundColor: foregroundColor,
            child: const Icon(Icons.call),
            onPressed: () {
              if (_controller.isDismissed) {
                _controller.forward();
              } else {
                _controller.reverse();
              }
            },
          ),
        ),
    );
  }
}
