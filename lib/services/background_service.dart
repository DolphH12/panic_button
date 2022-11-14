import 'dart:async';

import 'package:flutter_android_volume_keydown/flutter_android_volume_keydown.dart';
import 'package:geolocator/geolocator.dart';
import 'package:panic_app/main.dart';
import 'package:panic_app/pages/home_page.dart';
import 'package:panic_app/services/event_services.dart';
import 'package:panic_app/utils/preferencias_app.dart';
import 'package:panic_app/utils/utils.dart';

class ActivacionBotton {
  
  final PreferenciasUsuario _prefs = PreferenciasUsuario();
  late StreamSubscription<HardwareButton> subscription;

  
  int counter = 0;
  void startListening() {
    subscription = FlutterAndroidVolumeKeydown.stream.listen((event) {
      print("sirve");
      if (event == HardwareButton.volume_down) {
        counter++;
        print(counter);
        if (counter == 3) {
          // envio la alerta
          _message();
          stopListening();
          _prefs.button =  false;
          counter = 0;
        }
      } else if (event == HardwareButton.volume_up) {}
    });
  }

  void stopListening() {
      subscription.cancel();
      
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void _message() async{
    Position position = await _determinePosition();
    final buttonemergency = await eventService.addEvent(position, 1 , "Evento externo, botones de volumen");
    if(buttonemergency =="ok"){
      print("enviado");
      var context  =  navigatorKey.currentContext;
      mensajeInfo(context!,  "Alerta de emergencia enviada!", "");
    }
    
    
  }

}


EventService eventService =  new EventService();
ActivacionBotton activacion = ActivacionBotton();




// import 'dart:async';
// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';

// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       // this will be executed when app is in foreground or background in separated isolate
//       onStart: onStart,

//       // auto start service
//       autoStart: false,
//       isForegroundMode: true,
//     ),
//     iosConfiguration: IosConfiguration(
//       // auto start service
//       autoStart: false,

//       // this will be executed when app is in foreground in separated isolate
//       onForeground: onStart,

//       // you have to enable background fetch capability on xcode project
//       onBackground: onIosBackground,
//     ),
//   );
//   //service.startService();
// }

// // to ensure this is executed
// // run app from xcode, then from xcode menu, select Simulate Background Fetch
// bool onIosBackground(ServiceInstance service) {
//   WidgetsFlutterBinding.ensureInitialized();

//   return true;
// }

// void onStart(ServiceInstance service) async {
//   // Only available for flutter 3.0.0 and later
//   DartPluginRegistrant.ensureInitialized();

//   // For flutter prior to version 3.0.0
//   // We have to register the plugin manually

//   // SharedPreferences preferences = await SharedPreferences.getInstance();
//   // await preferences.setString("hello", "world");

//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });

//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }

//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });

//   // bring to foreground
//   Timer.periodic(const Duration(seconds: 1), (timer) async {
//     if (service is AndroidServiceInstance) {
//       service.setForegroundNotificationInfo(
//         title: "My App Service",
//         content: "Updated at ${DateTime.now()}",
//       );
//     }

//     /// you can see this log in logcat
//     print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
//   });
// }
