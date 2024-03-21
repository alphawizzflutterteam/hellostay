
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotificationService {
  BuildContext? context;
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() async {
    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings(
            "@mipmap/ic_launcher"),
        //iOS: DarwinInitializationSettings()
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(
          (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");

        }
      },
    );

    FirebaseMessaging.onMessage.listen(
          (message) {
        if (message.notification != null) {

          print("message.data11 ${message.data}");

         display(message);

          //handleNotification(message.data);

        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        if (message.notification != null) {

          print(message.notification!.body);
          print("message.data22 ${message.data}");



        }
      },
    );


  }
  static  Future<void> handleNotification(Map<String, dynamic> message) async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      // App was opened from a notification
      // TODO: handle the notification

    } else {
      // App was opened normally
    }
  }


  static void display(RemoteMessage message) async {
    try {
      // int id = DateTime.now().microsecondsSinceEpoch ~/1000000;
      Random random = Random();
      int id = random.nextInt(1000);
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
            "DR.Apps",
            "DR.Apps",
            importance: Importance.max,
            priority: Priority.high,
          ));
      await _flutterLocalNotificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails,
          payload: message.data['_id']);
    } on Exception catch (e) {
      print('Error>>>$e');
    }
  }



}