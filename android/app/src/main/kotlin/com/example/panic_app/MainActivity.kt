package com.example.panic_app

// para el canal

// para el uso de la bateria

//botones

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.provider.Settings
import android.view.accessibility.AccessibilityManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.util.regex.Pattern


class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/battery"

    private val CHANNEL_STREAM_BAROMETER = "com.example.platinum/barometer"
    private val barometerReading : BarometerReading = BarometerReading()

    private val CHANNEL_STREAM_BUTTONS = "con.example.flutter/buttons"

    companion object {
        val   buttonReading : VolumeKeyDownReading  =  VolumeKeyDownReading()
    }




    override fun configureFlutterEngine(@NonNull flutterEngine : FlutterEngine){
        super.configureFlutterEngine(flutterEngine)

        val pattern = longArrayOf(0,200,10,500)
        if(VERSION.SDK_INT >= VERSION_CODES.O){

            val name = getString(R.string.channel_name)
            //val descriptionText =  getString(R.string.channel_description) dont use for the moment
            val importance =  NotificationManager.IMPORTANCE_DEFAULT
            val CHANNEL_ID = "messages"
            val channel = NotificationChannel(CHANNEL_ID , name , importance)


            // Register the channel with the system
            val notificationManager : NotificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)




            /*
            val name2 = getString(R.string.channel_name_alert)
            //val descriptionText =  getString(R.string.channel_description) dont use for the moment
            val importance2 =  NotificationManager.IMPORTANCE_HIGH
            val CHANNEL_ID2 = "alerts"
            val channel2 = NotificationChannel(CHANNEL_ID2 , name2 , importance2)
            channel.vibrationPattern =  pattern
            channel.enableVibration(true)


            // Register the channel with the system

            notificationManager.createNotificationChannel(channel2)
            */

            // var channel =  NotificationChannel( "messages" , "Messages" , NotificationManager.IMPORTANCE_LOW);
            //var manager : NotificationManager = getSystemService(NotificationManager::class.java)
            //manager.createNotificationChannel(channel)

        }


        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "initButtonEvent") {


                val intentScreen =  Intent(context, MyService::class.java)

                if (VERSION.SDK_INT >= VERSION_CODES.O) {
                    startForegroundService(intentScreen)
                }
                else{
                    startService(intentScreen)
                }

                // valido que el servicio esté o no activado.
                val enabled = isAccessibilityServiceEnabled(context, MyAccessibilityService::class.java)
                if(!enabled){
                    startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS))
                }

                result.success(true);




            } else if (call.method == "stopButtonEvent" ){
                stopService(Intent(this, MyService::class.java));
                result.success(false);
                //var notification  = NotificationAlert(this)
                //notification.showNotification()





            }
            result.notImplemented()

        }

        //EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_STREAM_BAROMETER).setStreamHandler(barometerReading)
        //CHANNEL Of COMMUNICATION
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_STREAM_BUTTONS).setStreamHandler(buttonReading)
    }


}


fun isAccessibilityServiceEnabled(context: Context, service: Class<out AccessibilityService?>): Boolean {
    val am = context.getSystemService(Context.ACCESSIBILITY_SERVICE) as AccessibilityManager
    val enabledServices = am.getEnabledAccessibilityServiceList(AccessibilityServiceInfo.FEEDBACK_ALL_MASK)
    for (enabledService in enabledServices) {
        val enabledServiceInfo: ServiceInfo = enabledService.resolveInfo.serviceInfo
        if (enabledServiceInfo.packageName.equals(context.packageName) && enabledServiceInfo.name.equals(service.name)) return true
    }
    return false
}

