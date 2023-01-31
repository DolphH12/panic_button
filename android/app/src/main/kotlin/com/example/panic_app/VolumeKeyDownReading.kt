package com.example.panic_app

import io.flutter.plugin.common.EventChannel

class VolumeKeyDownReading : EventChannel.StreamHandler  {

    var buttonEventSink :  EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (events != null) {
            buttonEventSink =  events
        }
    }

    override fun onCancel(arguments: Any?) {

        buttonEventSink =  null

    }


}
