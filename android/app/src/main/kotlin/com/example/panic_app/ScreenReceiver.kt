package com.example.panic_app

import android.content.BroadcastReceiver
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log

// create the BroadcastReceiver, this going to use in a service , and we need register it
class ScreenReceiver  : BroadcastReceiver(){


    private var screenOff : Boolean?=null
    override fun onReceive(context: Context?, intent: Intent) {
        if (intent.action == Intent.ACTION_SCREEN_OFF) {
            screenOff =  true
            Log.d(ContentValues.TAG, Intent.ACTION_SCREEN_OFF)
        } else if (intent.action == Intent.ACTION_SCREEN_ON) {
            screenOff =  false
            Log.d(ContentValues.TAG, Intent.ACTION_SCREEN_ON)
        }

        val i = Intent(context, MyService::class.java)
        i.putExtra("screen_state", screenOff)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context!!.startForegroundService(i)
        }

    }

}