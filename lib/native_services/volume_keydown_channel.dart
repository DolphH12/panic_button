import 'dart:async';
import 'package:flutter/services.dart';


// Clase que contiene
// - Creación del EventChannel
// - Inicialización del stream, el cual maneja el tipo de dato HardwareButton. 


class FlutterAndroidVolumeKeydown {
  static const EventChannel _channel =
      EventChannel('con.example.flutter/buttons');

  // Se activa el receiveBroadcastStream, ademas de mapearlo para usar nuestro tipo de dato definido
  // tener en cuenta que decidimos retornar true or false desde nativo
  static Stream<HardwareButton> stream = _channel
      .receiveBroadcastStream()
      .cast<bool>()
      .map((event) => // Mapeo el canal para todos los eventos que se envien convertirlos en mi tipo de dato HardwateButton
          event ?  HardwareButton.volume_up: HardwareButton.volume_down );
}

// tipologia con la que se va a trabajar, no es obligatoria, perfectamente podriamos hacerlo con true and false
enum HardwareButton { volume_up, volume_down }