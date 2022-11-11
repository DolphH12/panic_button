import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:panic_app/services/background_service.dart';
//import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:panic_app/utils/preferencias_app.dart';

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
          // title: Text(
          //   "¡Bienvenidos!",
          //   style: TextStyle(
          //       fontSize: 25,
          //       color: _prefs.colorButton,
          //       fontWeight: FontWeight.w700),
          // ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: const IconThemeData(size: 40),
        ),
        body: const ButtonPanicWidget(),
        drawer: const MenuDrawer(),
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
  String text = "Start Service";
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
              // onChanged: (value) async {
              //   _prefs.button = value;
              //   if (value) {
              //     await FlutterBackground.enableBackgroundExecution();
              //     activacion.startListening();
              //   } else {
              //     activacion.stopListening();
              //     if (FlutterBackground.isBackgroundExecutionEnabled) {
              //       print("Si toy");
              //       await FlutterBackground.disableBackgroundExecution();
              //     }
              //   }
              //   setState(() {});
              // }),
              onChanged: null),
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
              backgroundImage: AssetImage("assets/alert.png"),
              radius: 40,
              backgroundColor: Colors.white,
            ),
            const SizedBox(
              height: 20,
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
            mainAxisAlignment: MainAxisAlignment.center,
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
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 25,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  "Presiona en caso de emergencia.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                height: 300,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "selectEmergency");
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 20,
                      shadowColor: prefs.colorButton.withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200),
                      ),
                      padding: const EdgeInsets.all(0.0),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              prefs.colorButton,
                              prefs.colorButton.withOpacity(0.8)
                            ],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                          ),
                          borderRadius: BorderRadius.circular(200)),
                    )),
              ),
              const SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
    );
  }
}
