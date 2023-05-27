// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:varla/Utility/NotificationHelp.dart';
import 'package:varla/main.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

enum NotificationType { silent, normal, progress, debug }

Map<String, Function> notificationActionsFunctions = {};

class NotificationAction {
  static Function? get(String actionId) {
    return notificationActionsFunctions[actionId];
  }

  static void add(String actionId, Function onPressed) {
    notificationActionsFunctions[actionId] = onPressed;
  }

  final String id;
  final String title;
  final Function onPressed;
  final AndroidBitmap<Object>? icon;
  NotificationAction({
    required this.id,
    required this.title,
    required this.onPressed,
    this.icon,
  }) {
    NotificationAction.add(id, onPressed);
    print(notificationActionsFunctions);
  }
}

List<NotificationAction> list = [
  NotificationAction(
      id: "action 1",
      title: "Test 1",
      onPressed: () {
        print("HIIIIIIIIIIIIIIII");
        return "hi";
      }),
  NotificationAction(
      id: "action 2",
      title: "Test 2",
      onPressed: () {
        print("HIIIIIIIIIIIIIIII");
      }),
  NotificationAction(
    id: "actoin 3",
    title: "Test 3",
    onPressed: () {
      print("HIIIIIIIIIIIIIIII");
    },
    icon: DrawableResourceAndroidBitmap("ic_bg_service_small"),
  ),
];
//     this.id,
//     this.title, {
//     this.titleColor,
//     this.icon,
//     this.contextual = false,
//     this.showsUserInterface = false,
//     this.allowGeneratedReplies = false,
//     this.inputs = const <AndroidNotificationActionInput>[],
//     this.cancelNotification = true,
//     }
Map<NotificationType, Function> channels = {
  NotificationType.normal: silentForgroundChannel,
};

class NotificationDetailsParams {
  final int id;
  final String channelId;
  final String channelName;
  final String body;

  final NotificationType? type = NotificationType.normal;
  final String? title = "hi";
  final String? payload = "hi";

  NotificationDetailsParams({
    required this.id,
    required this.channelId,
    required this.channelName,
    required this.body,
  }) {
    if (type == NotificationType.normal) {}
  }
}

Future<void> NormalNotification() async {}

Future<void> showNotificationWithActions(dynamic message,
    {List<NotificationAction>? actions, String? connectionID}) async {
  await flutterLocalNotificationsPlugin.show(
    id++,
    'Varla',
    message,
    channels[NotificationType.normal]!(actions),
    payload: 'item z',
  );

  // await flutterLocalNotificationsPlugin.zonedSchedule(
  //     id++,
  //     'Varla',
  //     message,
  //     tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
  //     notificationDetails,
  //     androidAllowWhileIdle: true,
  //     payload: 'item z',
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime);
}

List<AndroidNotificationAction> androidNotificationActions(
    List<NotificationAction>? actions) {
  return List<AndroidNotificationAction>.generate((actions ?? []).length,
      (index) {
    NotificationAction action = actions![index];
    return AndroidNotificationAction(
      action.id, action.title,
      icon: action.icon,
      contextual: (action.icon != null) ? true : false,
      // cancelNotification: false
      // DrawableResourceAndroidBitmap('ic_bg_service_small'),
      // contextual: true,
      //  showsUserInterface: true,
    );
  });
}

NotificationDetails silentForgroundChannel(List<NotificationAction>? actions) {
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'SilentForegroundService',
    'Silent Foreground Service',
    channelDescription: 'Only use for Silent Notifications',
    channelShowBadge: true,
    importance: Importance.max,
    priority: Priority.max,
    enableLights: true,
    icon: 'ic_bg_service_small',
    color: Color.fromARGB(255, 255, 0, 179),
    ledColor: const Color.fromARGB(255, 140, 0, 255),
    colorized: true,
    ledOnMs: 200,
    ledOffMs: 200,
    enableVibration: false,
    playSound: false,
    ticker: 'ticker',
    actions: androidNotificationActions(actions),
  );

  return NotificationDetails(
    android: androidNotificationDetails,
    iOS: iosNotificationDetails(),
    macOS: macOSNotificationDetails(),
    linux: linuxNotificationDetails(),
  );
}

DarwinNotificationDetails iosNotificationDetails() {
  return DarwinNotificationDetails(
    categoryIdentifier: darwinNotificationCategoryPlain,
  );
}

DarwinNotificationDetails macOSNotificationDetails() {
  return DarwinNotificationDetails(
    categoryIdentifier: darwinNotificationCategoryPlain,
  );
}

LinuxNotificationDetails linuxNotificationDetails() {
  return LinuxNotificationDetails(
    actions: <LinuxNotificationAction>[
      LinuxNotificationAction(
        key: urlLaunchActionId,
        label: 'Action 1',
      ),
      LinuxNotificationAction(
        key: navigationActionId,
        label: 'Action sdads2',
      ),
    ],
  );
}



// NotificationDetails notificationDetails() {
//   const AndroidNotificationDetails androidNotificationDetails =
//       AndroidNotificationDetails(
//     'SilentForegroundService',
//     'Silent Foreground Service',
//     channelDescription: 'Only use for Silent Notifications',
//     channelShowBadge: true,
//     importance: Importance.max,
//     priority: Priority.max,
//     enableLights: true,
//     color: Color(0xFF8C00FF),
//     ledColor: Color.fromARGB(255, 140, 0, 255),
//     ledOnMs: 200,
//     ledOffMs: 200,
//     enableVibration: false,
//     playSound: false,
//     channelAction: AndroidNotificationChannelAction.update,
//     ticker: 'ticker',
//     actions: <AndroidNotificationAction>[
//       AndroidNotificationAction(
//         urlLaunchActionId,
//         'Action 1',
//         icon: DrawableResourceAndroidBitmap('ic_launcher'),
//         contextual: true,
//       ),
//       AndroidNotificationAction(
//         'id_2',
//         'Action 2',
//         titleColor: Color.fromARGB(255, 255, 0, 0),
//         icon: DrawableResourceAndroidBitmap('ic_launcher'),
//       ),
//       AndroidNotificationAction(
//         navigationActionId,
//         'Action 3',
//         icon: DrawableResourceAndroidBitmap('ic_launcher'),
//         showsUserInterface: true,
//         // By default, Android plugin will dismiss the notification when the
//         // user tapped on a action (this mimics the behavior on iOS).
//         cancelNotification: false,
//       ),
//     ],
//   );

//   const DarwinNotificationDetails iosNotificationDetails =
//       DarwinNotificationDetails(
//     categoryIdentifier: darwinNotificationCategoryPlain,
//   );

//   const DarwinNotificationDetails macOSNotificationDetails =
//       DarwinNotificationDetails(
//     categoryIdentifier: darwinNotificationCategoryPlain,
//   );

//   const LinuxNotificationDetails linuxNotificationDetails =
//       LinuxNotificationDetails(
//     actions: <LinuxNotificationAction>[
//       LinuxNotificationAction(
//         key: urlLaunchActionId,
//         label: 'Action 1',
//       ),
//       LinuxNotificationAction(
//         key: navigationActionId,
//         label: 'Action sdads2',
//       ),
//     ],
//   );

//   // return const NotificationDetails notificationDetails =
//   return const NotificationDetails(
//     android: androidNotificationDetails,
//     iOS: iosNotificationDetails,
//     macOS: macOSNotificationDetails,
//     linux: linuxNotificationDetails,
//   );
// }
