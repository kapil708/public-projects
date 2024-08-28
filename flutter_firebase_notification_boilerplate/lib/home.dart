import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_boilerplate/result_screen.dart';

import 'index.dart';

//when app in background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  AndroidNotification android = message.notification?.android;
}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    initNotification();
    super.initState();
  }

  Future<void> initNotification() async {
    //when app in background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    }

    //when app is [closed | killed | terminated]
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage message) {
      if (message != null) {
        print("Notification On InitMsg");
        print(message);
        //Navigator.pushNamed(context, '/result', arguments: message.data);
        Navigator.push(context, MaterialPageRoute(builder: (_) => ResultScreen(data: message.data)));
      }
    });

    var initialzationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    //when app in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;

      //check for custom channel
      String channelId = message.notification.android.channelId;
      print(channelId);
      //end check

      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: channelId != null
                  ? AndroidNotificationDetails(
                      channelId,
                      'custom notification title',
                      'custom notification description',
                      icon: android?.smallIcon,
                      //sound: sound,
                    )
                  : AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      channel.description,
                      icon: android?.smallIcon,
                    ),
            ));
      }

      Navigator.push(context, MaterialPageRoute(builder: (_) => ResultScreen(data: message.data)));
      //Navigator.pushNamed(context, '/result', arguments: message.data);
    });

    //when app in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print(message);
      Navigator.push(context, MaterialPageRoute(builder: (_) => ResultScreen(data: message.data)));
      //Navigator.pushNamed(context, '/result', arguments: message.data);
    });

    requestPermissions();

    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return HomeLayout();
  }

  getToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    print("token : $token");
  }

  requestPermissions() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );

    print(settings.authorizationStatus);
  }
}
