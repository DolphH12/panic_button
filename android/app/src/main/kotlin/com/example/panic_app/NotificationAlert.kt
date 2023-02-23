package com.example.panic_app

import android.app.Notification
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat

class NotificationAlert(
        private val context : Context
) {


    fun showNotification(){
       // val intent = Intent(context, )
        //val contentIntent: PendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)

        var notification : NotificationCompat.Builder = NotificationCompat.Builder(context , "alerts" )
                .setContentText("alerta enviada")
                .setContentTitle("Flutter Alert")
                .setSmallIcon(R.drawable.notification_message)
                .setAutoCancel(true)


        val notificationManager: NotificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.notify(1, notification.build())
    }
}