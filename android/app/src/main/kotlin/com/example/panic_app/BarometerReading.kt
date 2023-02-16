package com.example.panic_app

import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.plugin.common.EventChannel

class BarometerReading : EventChannel.StreamHandler, SensorEventListener {
    private lateinit var sensorManager: SensorManager
    private lateinit var barometer  :  Sensor
    private var latestReading : Float = 0F
    private var barometerEventSink :  EventChannel.EventSink? = null

    fun init (context : Context){
        // aqui se coloca el controlador del hardware , se asigna quien lo lee ademas de iniciar con el listenes
        sensorManager  = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        barometer = sensorManager.getDefaultSensor(Sensor.TYPE_PRESSURE)
        sensorManager.registerListener(this , barometer , SensorManager.SENSOR_DELAY_NORMAL)

    }


    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        // aqui configuramos la sincronizacion de eventos para que se igual a los eventos
        if (events != null) {
            barometerEventSink =  events
        }
    }

    override fun onCancel(arguments: Any?) {

        // para anular la sincronización
        barometerEventSink = null
    }

    override fun onSensorChanged(p0: SensorEvent?) {
        latestReading = p0!!.values[0]
        if(barometerEventSink!= null){
            barometerEventSink!!.success(latestReading)
        }
    }


    override fun onAccuracyChanged(p0: Sensor?, p1: Int) {

    }
}