import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:panic_app/routes/routes.dart';
import 'package:panic_app/services/internet_service.dart';
import 'native_services/button_volume_service.dart'; // boton de panico
import 'utils/preferencias_app.dart';
import 'package:camera/camera.dart';
import 'package:panic_app/pages/camera_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();  
  await checkInternet();
  cameras = await availableCameras();
  if (prefs.button == true) {
    activacion.startListening();
  }
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
      title: 'Botón pánico UdeA',
      initialRoute: 'splash',
      routes: appRoutes,
      navigatorKey: navigatorKey,
    );
  }
}
