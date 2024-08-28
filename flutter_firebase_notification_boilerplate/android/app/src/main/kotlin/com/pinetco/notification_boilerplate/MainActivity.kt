package com.pinetco.notification_boilerplate

import android.app.NotificationChannel
import android.app.NotificationManager
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity


class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val soundUri: Uri = Uri.parse(
                    "android.resource://" +
                            applicationContext.packageName +
                            "/" + R.raw.sound1)

            val soundUri2: Uri = Uri.parse(
                    "android.resource://" +
                            applicationContext.packageName +
                            "/" + R.raw.sound2)

            val audioAttributes = AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                    .build()

            val channel = NotificationChannel("noti_push_app_1",
                    "noti_push_app",
                    NotificationManager.IMPORTANCE_HIGH)

            val channel2 = NotificationChannel("noti_push_app_2",
                    "noti_push_app2",
                    NotificationManager.IMPORTANCE_HIGH)

            channel.setSound(soundUri, audioAttributes)

            channel2.setSound(soundUri2, audioAttributes)

            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
            notificationManager.createNotificationChannel(channel2)
        }
    }
}