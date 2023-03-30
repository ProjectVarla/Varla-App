import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:varla/Services/Notification/NotificationChannelStream.dart';
import 'package:varla/Services/Notification/NotificationChannels.dart';
import 'package:varla/Services/Notification/temp.dart';
import 'package:varla/Utility/BottomNavigationBar.dart';
import 'package:varla/Utility/Env/env.dart';
import 'package:varla/Utility/NotificationHelp.dart';
import 'package:varla/View/Home/HomePage.dart';
import 'package:varla/View/Tasks/TasksPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureLocalTimeZone();
  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String initialRoute = HomePage.routeName;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload =
        notificationAppLaunchDetails!.notificationResponse?.payload;
    initialRoute = TasksPage.routeName; // TasksPage.routeName;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_launcher');

  final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationStream.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    },
    notificationCategories: darwinNotificationCategories,
  );
  final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(
    defaultActionName: 'Open notification',
    defaultIcon: AssetsLinuxIcon('icons/icon.png'),
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
    linux: initializationSettingsLinux,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      if (notificationResponse.actionId != null) {
        print("7aywan");
        print(notificationActionsFunctions);
        notificationActionsFunctions[notificationResponse.actionId]!();
      }
      print(notificationResponse.actionId);
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: onStart,
  );

  await initializeService();

  NotificationChannels.add(NotificationChannelStream(
      serverUrl: Env.NOTIFICATION_CORE_URL, channelName: "communication"));

  NotificationChannels.add(NotificationChannelStream(
      serverUrl: Env.NOTIFICATION_CORE_URL, channelName: "FileManager"));

  initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData normalTheme = ThemeData().copyWith(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
        ));

    final ThemeData darkTheme = ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSwatch(
      primarySwatch: Colors.purple,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: normalTheme,
      darkTheme: darkTheme,
      home: const BottomNavigationBarHelper(),
    );
  }
}

Future<void> initializeService() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }

  final service = FlutterBackgroundService();
  await service.configure(
      iosConfiguration: IosConfiguration(autoStart: true),
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,
        initialNotificationContent: "Bob Peep Poop",
        // auto start service
        autoStartOnBoot: true,
        autoStart: true,
        isForegroundMode: true,
      ));
}

@pragma('vm:entry-point')
void onStart(dynamic zeft) async {
  if (zeft is NotificationResponse) {
    print("ya zeft");
    print(NotificationChannels.channels);
    print('notification(${zeft.id}) action tapped: '
        '${zeft.actionId} with'
        ' payload: ${zeft.payload}');

    if (zeft.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print('notification action tapped with input: ${zeft.input}');
    }
    return;
  }
  DartPluginRegistrant.ensureInitialized();
  NotificationChannels.add(NotificationChannelStream(
      serverUrl: Env.NOTIFICATION_CORE_URL, channelName: "FileManager"));

  initNotification();

  showNotificationWithActions("background service", actions: [
    NotificationAction(
        id: "id",
        title: "test",
        onPressed: () {
          print("meshan allah");
        })
  ]);
}

void initNotification() {
  NotificationChannels.init();
}
