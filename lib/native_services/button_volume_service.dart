import 'dart:async';


import 'package:flutter/services.dart';
import 'package:panic_app/native_services/notification_button_service.dart';
import 'package:panic_app/services/event_services.dart';

import '../main.dart';
import '../utils/preferencias_app.dart';


import 'package:panic_app/native_services/volume_keydown_channel.dart';




import 'package:panic_app/utils/utils.dart';
import 'package:geolocator/geolocator.dart';


final PreferenciasUsuario _prefs = PreferenciasUsuario();
class ActivacionBotton {
  
  static const platform =  MethodChannel('samples.flutter.dev/battery'); 
  late StreamSubscription<HardwareButton> subscription;

  Future<void> initializeButtonService() async {
  
    try {
      bool a  = await platform.invokeMethod('initButtonEvent');
      _prefs.button = a;
      // inicio a escuchar el canal
      startListening();
    } on PlatformException catch (e) {
      print("Failed to get battery level: '${e.message}'.");
    }

  }

  Future<void> stopbuttonService() async {

    try {
      bool a = await platform.invokeMethod('stopButtonEvent');
      _prefs.button =  a;
      // paro de escuchar por el canal
      stopListening();
    
    } on PlatformException catch (e) {
        print(e.toString());
    }

    }

  
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
            // paro el servicio
            stopbuttonService();
            counter = 0;
          }
        } else if (event == HardwareButton.volume_up) {}
      });
    }

  void stopListening() {
      subscription.cancel();
      
  }
  
  void _message() async{
    print("creando envio");
    Position position = await determinePosition();
    final buttonemergency = await eventService.addEvent(position, 1 , "Evento externo, botones de volumen");
    print(buttonemergency);
    if(buttonemergency == true){
      print("enviado");
      // MANDO LA NOTIFICACION DE QUE SE ENVIO LA ALERTA
      showNotificacion();
      var context  =  navigatorKey.currentContext;
      mensajeInfo(context!,  "Alerta de emergencia enviada!", "");
      // Navigator.pushReplacementNamed(navigatorKey.currentContext!, 'home');
    }
  }

  // metodos para comunicar los metodos con android y activar los servicios desde allá

  
  
  
  }
  
  EventService eventService = EventService(); // clase que tiene los metodos para consultar en la base de datos
  ActivacionBotton activacion = ActivacionBotton(); // instancia de la clase de este archivo

  

  