package com.example.panic_app


import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.support.v4.media.session.MediaSessionCompat
import android.support.v4.media.session.PlaybackStateCompat
import androidx.media.VolumeProviderCompat


class PlayerService : Service() {

    var mediaSession: MediaSessionCompat? = null


    override fun onCreate() {

        super.onCreate()


        mediaSession = MediaSessionCompat(this, "PlayerService" )
        mediaSession!!.setFlags(MediaSessionCompat.FLAG_HANDLES_MEDIA_BUTTONS or
                MediaSessionCompat.FLAG_HANDLES_TRANSPORT_CONTROLS)
        mediaSession!!.isActive =  true



        mediaSession!!.setPlaybackState(PlaybackStateCompat.Builder()
                .setState(PlaybackStateCompat.STATE_PLAYING, 0, 0F) //you simulate a player which plays something.
                .build())



        //this will only work on Lollipop and up, see https://code.google.com/p/android/issues/detail?id=224134
        val myVolumeProvider: VolumeProviderCompat = object : VolumeProviderCompat(VolumeProviderCompat.VOLUME_CONTROL_RELATIVE,  /*max volume*/100,  /*initial volume level*/50) {

            override fun onAdjustVolume(direction: Int) {

                if(direction>0 && currentVolume < maxVolume){
                    currentVolume += 5
                } else if( direction<0  && currentVolume >5  ){
                    currentVolume -=5
                }


                if((MainActivity.buttonReading.buttonEventSink!=null) && ( direction == -1)){
                    MainActivity.buttonReading.buttonEventSink!!.success(false)
                }else if((MainActivity.buttonReading.buttonEventSink!=null) && ( direction == 1)){
                    MainActivity.buttonReading.buttonEventSink!!.success(true);
                }
            }
        }
        mediaSession!!.setPlaybackToRemote(myVolumeProvider)


    }

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onDestroy() {
        mediaSession?.release()
        super.onDestroy()


    }
}
