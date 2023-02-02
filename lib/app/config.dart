import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jbuti_app/app/constants.dart';

class Config {
  init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Future.wait(
      [
        Firebase.initializeApp(),
        GetStorage.init(),
      ],
    );
   try{
    //await FirebaseMessaging.instance.subscribeToTopic("mutualis");
   }catch(e){
    log(e.toString(),name: "Subscription error");
   }
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveLocalNotificationAndroid,
    );
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

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      // showMessage(flutterLocalNotificationsPlugin,channel);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("CALLED");
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null) {
          print("LOOGED");

          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                importance: Importance.max,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher',
                // other properties...
              ),
            ),
          );
        }
      });
    }
  }

  // showMessage(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  //     AndroidNotificationChannel channel) {
  //   return flutterLocalNotificationsPlugin.show(
  //     1,
  //     "NOTIFICATION",
  //     "WARAA AHMED",
  //     NotificationDetails(
  //       // android: AndroidNotificationDetails(
  //       //   channel.id,
  //       //   channel.name,
  //       //   channelDescription: channel.description,
  //       //   // icon: android.smallIcon,
  //       //   // other properties...
  //       // ),
  //     ),
  //   );
  // }

  void selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
  }

  void onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? ""),
        content: Text(body ?? ""),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {},
          )
        ],
      ),
    );
  }

  void onDidReceiveLocalNotificationAndroid(
      NotificationResponse details) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(details.notificationResponseType.name),
        content: Text(details.input ?? ""),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {},
          )
        ],
      ),
    );
  }

  sendNotification(
      {required String token,
      required String title,
      required String body}) async {
    try {
      var data = {
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {
          'page': 'requestPage',
          'group_id': token,
          'click_action': 'FLUTTER_NOTIFICATION_CLICK'
        },
        "to": token
      };
      var response = await http.post(
        Uri.parse(kFirebaseUrl),
        body: jsonEncode(data),
        headers: {
          "Authorization": "key =$kApi",
          "Content-Type": "application/json"
        },
      );
      if (response.statusCode == 200) {
        log("SUCCESS SENT", name: "SUCCESS");
        log(token, name: "THE TOKEN");
      } else {
        throw response.body;
      }
    } catch (e) {
      log(e.toString(), name: "Send Notification");
    }
  }
}
