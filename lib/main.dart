import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:panic_app/routes/routes.dart';
import 'utils/preferencias_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  await FlutterBackground.initialize(androidConfig: androidConfig);
  await FlutterBackground.hasPermissions;
  runApp(const MyApp());
}

const androidConfig = FlutterBackgroundAndroidConfig(
  notificationTitle: "flutter_background example app",
  notificationText:
      "Background notification for keeping the example app running in the background",
  notificationImportance: AndroidNotificationImportance.Default,
  notificationIcon: AndroidResource(
      name: 'background_icon',
      defType: 'drawable'), // Default is ic_launcher from folder mipmap
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Boton Panico UdeA',
      initialRoute: 'splash',
      routes: appRoutes,
    );
  }
}

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   StreamSubscription<HardwareButton>? subscription;

//   String prueba = "";
//   int ayuda2 = 0;
//   int ayuda3 = 0;
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               Text("prueba $prueba"),
//               ElevatedButton(
//                   onPressed: startListening,
//                   child: const Text("Start listening")),
//               ElevatedButton(
//                   onPressed: stopListening,
//                   child: const Text("Stop listening")),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
