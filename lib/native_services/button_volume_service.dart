import 'dart:async';


import 'package:panic_app/services/event_services.dart';

import '../main.dart';
import '../utils/preferencias_app.dart';


import 'package:panic_app/native_services/volume_keydown_channel.dart';




import 'package:panic_app/utils/utils.dart';
import 'package:geolocator/geolocator.dart';

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
  
  void _message() async{
    print("creando envio");
    Position position = await determinePosition();
    final buttonemergency = await eventService.addEvent(position, 1 , "Evento externo, botones de volumen");
    print(buttonemergency);
    if(buttonemergency == true){
      print("enviado");
      var context  =  navigatorKey.currentContext;
      mensajeInfo(context!,  "Alerta de emergencia enviada!", "");
      // Navigator.pushReplacementNamed(navigatorKey.currentContext!, 'home');
    }
  }
  
  
  }
  
  EventService eventService = EventService();
  ActivacionBotton activacion = ActivacionBotton();