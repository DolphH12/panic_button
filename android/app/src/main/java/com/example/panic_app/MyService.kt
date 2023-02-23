package com.example.panic_app

import android.app.Notification
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.annotation.Nullable
import androidx.core.app.NotificationCompat


class MyService : Service() {


    override fun onCreate() {
        super.onCreate()

        //notificacion
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            var builder : NotificationCompat.Builder = NotificationCompat.Builder(this , "messages" )
                    .setContentText("This is running in background")
                    .setContentTitle("Panic button Background")
                    .setSmallIcon(R.drawable.notification_message)
                    .setAutoCancel(true)
                    .setOngoing(false)

            startForeground(101, builder.build())



        }
        // fin de la  notificacion

        val intentFilter = IntentFilter(Intent.ACTION_SCREEN_ON)
        intentFilter.addAction(Intent.ACTION_SCREEN_OFF)
        // REGISTER RECEIVER THAT HANDLES SCREEN ON AND SCREEN OFF LOGIC
        val mReceiver: BroadcastReceiver = ScreenReceiver()
        registerReceiver(mReceiver, intentFilter)




    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val screenOn = intent!!.getBooleanExtra("screen_state", false)
        if (!screenOn) {
            //var notificationManager  = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager



            stopService(Intent(this, PlayerService::class.java))
            Log.e("aaaaa", "ScreenOn")
        } else {



            //initialice method mediasession
            val intentMedia =  Intent( this, PlayerService::class.java )
            startService(intentMedia)
            Log.e("aaaaa", "ScreenOff")
            // YOUR CODE
        }





        return START_STICKY
    }

    @Nullable
    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        stopForeground(STOP_FOREGROUND_REMOVE);


    }

}