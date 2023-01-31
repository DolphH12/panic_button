package com.example.panic_app

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import android.view.KeyEvent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel


import android.view.KeyEvent.KEYCODE_VOLUME_DOWN
import android.view.KeyEvent.KEYCODE_VOLUME_UP

class MainActivity: FlutterActivity() {

    private val CHANNEL_STREAM_BUTTONS = "con.example.flutter/buttons"
    private  val  buttonReading : VolumeKeyDownReading  =  VolumeKeyDownReading()





    override fun configureFlutterEngine(@NonNull flutterEngine : FlutterEngine){
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_STREAM_BUTTONS).setStreamHandler(buttonReading)
    }



    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {

        if(keyCode == KeyEvent.KEYCODE_VOLUME_DOWN && buttonReading.buttonEventSink != null) {
            buttonReading.buttonEventSink!!.success(true)

            return true;
        }
        if(keyCode == KeyEvent.KEYCODE_VOLUME_UP && buttonReading.buttonEventSink != null) {
            buttonReading.buttonEventSink!!.success(false);
            return true;
        }

        return super.onKeyDown(keyCode, event)
    }

}
