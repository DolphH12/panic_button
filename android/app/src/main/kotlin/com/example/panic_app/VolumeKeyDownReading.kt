package com.example.panic_app

import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel


class VolumeKeyDownReading : EventChannel.StreamHandler  {

    var buttonEventSink :  EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        // aqui configuramos la sincronizacion de eventos para que se igual a los eventos
        if (events != null) {
            buttonEventSink =  events
        }
    }

    override fun onCancel(arguments: Any?) {

        buttonEventSink =  null

    }


}

