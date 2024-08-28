# Firebase Push Notification

## System Settings
-  Flutter version 2.2.2 or higher

## Plugin Needs

[firebase_core: ^1.3.0](https://pub.dev/packages/firebase_core)

[firebase_messaging: ^10.0.2](https://pub.dev/packages/firebase_messaging)

[flutter_local_notifications: ^6.0.0](https://pub.dev/packages/flutter_local_notifications)

## Firebase Setup
- complete firebase setup and download **google-services.json**

## Android Setup

### In AndroidManifest.xml

```
<application
        android:name=".Application"
```

### Create Application.kt file In kotlin folder where MainActivity is placed

```
package com.pinetco.notification_boilerplate <- your project class here
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.view.FlutterMain
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;

class Application : FlutterApplication(), PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
        FlutterMain.startInitialization(this)
    }

    override fun registerWith(registry: PluginRegistry?) {
    }
}
```

### In MainActivity.kt file (Optional -> Only if want custom sound)

- here you can create channel for custome sound, icon and other settings
- here we have 2 channel with ID **noti_push_app_1** & **noti_push_app_2**
- add sound file in res/raw folder here we have 2 files

```
package com.pinetco.notification_boilerplate   <- your project class here
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
```

## Postman Setup

Link : https://fcm.googleapis.com/fcm/send
Post Method

In Header (Remove [] from Authorization)
```
Content-Type:application/json
Authorization:key=[your firebase server key here]
```

In Body
```
{
  "to": "cXq67ScQRQKHxWOzMJh4M7:APA91bHUNmzKioVHCfP31dooJJybu2_PnHjOZhO5W0VwGM1GQrU7L_oLZxqUbLmi-p5dpTTNYBBfscDlRBs1FPnhEMJqe2JE1LPahbghT5b6v25hCyTwedsSr7AoNE4cS4-s76UMTtyx",
  "notification": {
    "title": "ASAP Alert",
    "body": "Please open your app",
    "android_channel_id": "noti_push_app_1" <- your channel ID here (Optional)
  },
  "data": {
    "screen": "/Nexpage1",
    "click_action": "FLUTTER_NOTIFICATION_CLICK"
  }
}
```
