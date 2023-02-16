package com.example.panic_app

import android.accessibilityservice.AccessibilityService
import android.app.Service
import android.util.Log
import android.view.KeyEvent
import android.view.accessibility.AccessibilityEvent

class MyAccessibilityService : AccessibilityService() {

    override fun onInterrupt() {
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {}

    override fun onKeyEvent(event: KeyEvent?): Boolean {
        Log.e("message", "backgrond")
        when (event!!.keyCode) {
            KeyEvent.KEYCODE_VOLUME_UP -> {
                when (event.action) {
                    KeyEvent.ACTION_DOWN -> {
                        if((MainActivity.buttonReading.buttonEventSink!=null)){
                            MainActivity.buttonReading.buttonEventSink!!.success(true)}
                    }
                    KeyEvent.ACTION_UP -> {


                    }
                }
            }
            KeyEvent.KEYCODE_VOLUME_DOWN -> {
                when (event.action) {
                    KeyEvent.ACTION_DOWN -> {
                        if((MainActivity.buttonReading.buttonEventSink!=null)){
                            MainActivity.buttonReading.buttonEventSink!!.success(false)}
                    }
                    KeyEvent.ACTION_UP -> {
                    }
                }
            }
        }
        return super.onKeyEvent(event)
    }

}