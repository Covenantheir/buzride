import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';

// create an instance
FirebaseMessaging messaging = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin fltNotification =
    FlutterLocalNotificationsPlugin();

void initMessaging() {
  var androiInit =
      const AndroidInitializationSettings('@mipmap/ic_launcher'); //for logo
  var iosInit = const DarwinInitializationSettings();
  var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);
  fltNotification = FlutterLocalNotificationsPlugin();
  fltNotification.initialize(initSetting);
  var androidDetails = const AndroidNotificationDetails('1', 'channelName',
      enableVibration: true,
      enableLights: true,
      importance: Importance.high,
      playSound: true,
      priority: Priority.high,
      visibility: NotificationVisibility.public);
  var iosDetails = const DarwinNotificationDetails();
  var generalNotificationDetails =
      NotificationDetails(android: androidDetails, iOS: iosDetails);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      fltNotification.show(notification.hashCode, notification.title,
          notification.body, generalNotificationDetails);
      if (client.connectionStatus!.state != MqttConnectionState.connected ||
          client.connectionStatus == null) {
        getUserDetails();
        valueNotifierBook.incrementNotifier();
        //audioPlayer.play(audio);
        audioPlayers.play(DeviceFileSource(audio));
      }
    } else if (notification != null) {
      fltNotification.show(notification.hashCode, notification.title,
          notification.body, generalNotificationDetails);
      if (client.connectionStatus!.state != MqttConnectionState.connected ||
          client.connectionStatus == null) {
        getUserDetails();
        valueNotifierBook.incrementNotifier();
        //audioPlayer.play(audio);
        audioPlayers.play(DeviceFileSource(audio));
      }
    }
  });
}
