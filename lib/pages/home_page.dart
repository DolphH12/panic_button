import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:panic_app/native_services/button_volume_service.dart';
import 'package:panic_app/utils/preferencias_app.dart';
import '../utils/confirm.dart';
import '../widgets/buttons_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PreferenciasUsuario _prefs = PreferenciasUsuario();

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
                  onTap: () => Navigator.pushNamed(context, 'map'),
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

  Timer? timer;
  int seconds = 3;
  String text = "Start Service";
  Confirm confirm = Confirm();

  @override
  void initState() {
    super.initState();
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
                  //     await FlutterBackground.enableBackgroundExecution();
                  await activacion.initializeButtonService();

                  //     startTimer();
                  //     // if(!mounted) return;
                  //     // Navigator.pushReplacementNamed(context, 'home');
                } else {
                  await activacion.stopbuttonService();
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
  bool floatExtended = true;

  static const List<IconData> icons = [
    Icons.local_police,
    Icons.notification_important
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color foregroundColor = prefs.colorButton;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: List.generate(icons.length, (int index) {
        Widget child = Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 50.0,
            //width: 50.0,
            //alignment: FractionalOffset.centerLeft,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _controller,
                curve: Interval(0.0, 1.0 - index / icons.length / 2.0,
                    curve: Curves.easeOut),
              ),
              child: FloatingActionButton.extended(
                heroTag: null,
                backgroundColor: backgroundColor,
                icon: Icon(icons[index], color: foregroundColor),
                label: Text(
                  index == 0 ? "Policia" : "Bomberos",
                  style: TextStyle(fontSize: 12, color: prefs.colorButton),
                ),
                onPressed: () async {
                  if (index == 0) {
                    const call = '123';
                    try {
                      FlutterPhoneDirectCaller.callNumber(call);
                    } catch (e) {
                      throw 'Could not launch $call';
                    }
                  } else {
                    const call = '119';
                    try {
                      FlutterPhoneDirectCaller.callNumber(call);
                    } catch (e) {
                      throw 'Could not launch $call';
                    }
                  }
                },
              ),
            ),
          ),
        );
        return child;
      }).toList()
        ..add(
          FloatingActionButton.extended(
            label: const Text(
              "Llamada de \nemergencia",
              style: TextStyle(fontSize: 12),
            ),
            isExtended: floatExtended,
            icon: Icon(
              floatExtended == true ? Icons.call : Icons.close,
              color: floatExtended == true ? Colors.white : Colors.red,
            ),
            backgroundColor: foregroundColor,
            onPressed: () {
              setState(() {
                floatExtended = !floatExtended;
              });
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
