import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:varla/Services/Notification/temp.dart';
import 'package:varla/Utility/Env/env.dart';
import 'package:varla/Utility/NetworkConnection.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Verbosity { QUITE, NORMAL, VERBOSE }

class NotificationChannel {
  final String name;
  final Verbosity verbosity;

  NotificationChannel({required this.name, required this.verbosity});

  // Future<void> addChannel() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   prefs.setStringList("channels", [
  //     NotificationChannel(name: "name", verbosity: Verbosity.VERBOSE).toJson(),
  //     NotificationChannel(name: "Hello", verbosity: Verbosity.NORMAL).toJson(),
  //   ]);
  // }

  factory NotificationChannel.fromJson(String string) {
    Map<String, dynamic> json = jsonDecode(string);

    return NotificationChannel(
        name: json["name"]!,
        verbosity: Verbosity.values[int.parse(json["verbosity"].toString())]);
  }

  toJson() {
    return {"name": name.toString(), "verbosity": verbosity.index.toString()};
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}

class ConnectionDetails {
  String? id;
  List<NotificationChannel> channels = [];

  Future<void> loadConnectionDetailes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('connection_id');
    channels = (prefs.getStringList('channels') ?? [])
        .map((e) => NotificationChannel.fromJson(e))
        .toList();
  }

  Future<void> setId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('connection_id', id);
    this.id = id;
  }

  Future<void> setChannels(List<NotificationChannel> channels) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        "channels", channels.map((e) => e.toString()).toList());
    this.channels = channels;
  }

  Future<void> addChannels(List<NotificationChannel> channels) async {
    String s = jsonEncode(<String, dynamic>{
      "channels": channels
          .map((channel) => {"name": channel.name, "verbosity": 2})
          .toList(),
      "connection_id": id
    });
    print(s);
    http
        .post(
          Uri.parse('http://${Env.NOTIFICATION_CORE_URL}/subscribe'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: s,
        )
        .then((value) => null);
  }

  Future<void> removeChannels(String channel) async {
    http
        .post(Uri.parse('http://${Env.NOTIFICATION_CORE_URL}/unsubscribe'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(
              <String, dynamic>{
                "channel_names": [channel],
                "connection_id": id
              },
            ))
        .then((value) => null);
  }

  Future<void> syncChannels() async {
    var client = http.Client();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var decodedResponse = await client
          .post(
        Uri.parse('http://${Env.NOTIFICATION_CORE_URL}/list_subscribtions'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{"connection_id": id}),
      )
          .then((value) {
        dynamic json =
            jsonDecode(utf8.decode(value.bodyBytes)) as List<dynamic>;
        // setChannels(json.map((e) => NotificationChannel.fromJson(e)).toList());
        print(json);
        return json;
      });

      print(decodedResponse);
      List<dynamic> zeft = decodedResponse
          .map((e) => NotificationChannel.fromJson(jsonEncode(e)))
          .toList();
      //  decodedResponse.map((e) {
      //   return NotificationChannel(
      //       name: e["name"], verbosity: Verbosity.NORMAL);
      // }).toList();
      print("**********");
      print(zeft);
      setChannels(zeft
          .map((e) => NotificationChannel.fromJson(jsonEncode(e)))
          .toList());
      // return decodedResponse;
    } finally {
      // client.close();
    }
  }

  Future<List<NotificationChannel>> loadChannels() async {
    await syncChannels();
    print("**********");
    print(channels);
    return channels;
  }
  // Future<void> syncChannels() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   id = prefs.getString('connection_id');
  //   channels = ((prefs.getStringList('channels') ?? []).map((e) {
  //     return NotificationChannel(
  //         name: jsonDecode(e)["name"],
  //         verbosity: Verbosity.values[int.parse(jsonDecode(e)["verbosity"])]);
  //   })).toList();

  //   print("****************");
  //   print(id);
  //   print(channels);
  //   print("****************");
  // }

  Future<void> setConnectionDetailes() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    // prefs.setStringList("channels", [
    //   NotificationChannel(name: "name", verbosity: Verbosity.VERBOSE)
    //       .toString(),
    //   NotificationChannel(name: "Hello", verbosity: Verbosity.NORMAL)
    //       .toString(),
    // ]);
    // id = prefs.getString('connection_id');
    // channels = jsonDecode(prefs.getString('channels') ?? "[]")
    // as List<NotificationChannel>;
  }
}

class NotificationConnection {
  static ConnectionDetails connection = ConnectionDetails();

  static Future<List<NotificationChannel>> getChannels() async {
    await connection.syncChannels();
    return connection.channels;
  }

  static isConnected() {
    return connection.id == null;
  }

  static Future<void> init() async {
    await connection.loadConnectionDetailes();
    NotificationService.connection = connection;
    print(connection.id);
    print(connection.channels);
  }

  static Future<void> open() async {
    // open SharedPreferences instance
    print("Noti V2");
    NotificationService.prefs = await SharedPreferences.getInstance();

    await NotificationService.open();
  }

  static void subcribe() {
    connection.addChannels(connection.channels);
  }

  static void subscribe(String channelName, Verbosity verbosity) {
    connection.addChannels(
        [NotificationChannel(name: channelName, verbosity: verbosity)]);
  }

  static void unsubscribe(String channel) {
    connection.removeChannels(channel);
  }
}

class NotificationService {
  static bool abort = false;

  static ConnectionDetails connection = ConnectionDetails();

  static WebSocketChannel? socket;
  static Uri? uri;

  static int delay = 1;
  static bool isAcknowledged = false;
  static bool skipReconnection = false;
  static bool isAlive = false;
  static SharedPreferences? prefs;

  // NotificationService() {
  //   connection.loadConnectionDetailes();
  // }

  static Future<void> connect(Uri uri) async {
    // Checking if socket is already been abort.
    if (abort) return;

    if (skipReconnection) {
      await showNotificationWithActions(
          "skipping reconnecting until acknowledgment timeout!",
          connectionID: connection.id);
      return;
    }

    try {
      socket = WebSocketChannel.connect(uri);
    } catch (e) {
      await showNotificationWithActions(
          "Sir, I am facing a problem in push notification system. in socket : <conncectionID>" +
              e.toString(),
          connectionID: connection.id);
    }

    print(socket);
    listen();
  }

  static void listen() {
    /**
     *  Listen to streams. 
     */

    socket?.stream.listen((message) async {
      print("in body");
      print(message);

      if (connection.id == null) {
        // First connection on device.
        await connection.setId(json.decode(message)["connection_id"]!);
      }

      // If message arives:
      // send("alive");
      /**
       * Confirm connection is valid.
       */
      // isAcknowledged = true;
      // isAlive = true;

      // Reset reconnection delay.
      delay = 1;

      List<NotificationAction> list = [
        NotificationAction(
            id: "action 1",
            title: "Test 1",
            onPressed: () {
              print("HIIIIIIIIIIIIIIII");
              return "hi";
            }),
        // NotificationAction(
        //     id: "action 2",
        //     title: "Test 2",
        //     onPressed: () {
        //       print("HIIIIIIIIIIIIIIII");
        //     }),
        // NotificationAction(
        //   id: "actoin 3",
        //   title: "Test 3",
        //   onPressed: () {
        //     print("HIIIIIIIIIIIIIIII");
        //   },
        //   icon: DrawableResourceAndroidBitmap("ic_bg_service_small"),
        // ),
      ];

      // Send Notification with the message.
      // TODO check if confirmation message first.
      await showNotificationWithActions(json.decode(message)["text"],
          connectionID: connection.id, actions: list);
    }, onError: (e) {
      print(e);
      close();

      // On error close connection.
      // TODO try if exceptions work here :P.
    }, onDone: () async {
      // On socket close
      await onDone();
    });
  }

  static Future<void> open() async {
    if (connection.id == null) {
      // No connection ID assigned before.
      await connect(Uri.parse('ws://${Env.NOTIFICATION_CORE_URL}/connect'));
    } else {
      // connection ID was assigned before.
      await reconnect();
    }
  }

  static void abortReconnecting() {
    print("aborting");
    showNotificationWithActions("aborting reconnection",
        connectionID: connection.id);
    abort = true;
  }

  static void resumeReconnecting() {
    delay = 1;
    abort = false;
    open();
  }

  static void close() {
    if (socket == null) {
      print("Not Connected!");
      return;
    }
    // isAlive = false;

    socket?.sink.close(status.goingAway);
    socket = null;
    print("Connection Closed");
  }

  static Future<void> handleAcknowledgement() async {
    skipReconnection = true;
    int ackDelay = 4;
    while (!isAcknowledged && ackDelay <= 32) {
      if (!await hasInternt(ackDelay)) {
        abortReconnecting();
        return;
      }
      await showNotificationWithActions(
          "waiting for acknowledgement in ${ackDelay}",
          connectionID: connection.id);

      await Future.delayed(Duration(seconds: min(ackDelay, 300)));
      ackDelay *= 2;
    }
    await showNotificationWithActions("Acknowledgement timedout!",
        connectionID: connection.id);
    skipReconnection = false;
  }

  static void send(String message) {
    socket?.sink.add(message);
  }

  static Future<bool> hasInternt(int delay) async {
    if (delay >= 64 && !await IsConnected()) {
      print("Not Connected to Internet!");

      //TODOadd reconnect button
      await showNotificationWithActions("Not Connected to Internet!",
          connectionID: connection.id);

      return false;
    }
    return true;
  }

  static Future<void> onDone() async {
    print("OnDone!:");
    close();

    // Always try to reconnect unless abort
    if (abort) return;

    // Always try to reconnect unless internet not connected!
    if (!await hasInternt(delay)) {
      abortReconnecting();
      return;
    }

    print("not abort, reconncting in ${delay}");
    open();
  }

  static Future<void> reconnect() async {
    await showNotificationWithActions("reconnecting in ${delay}",
        connectionID: connection.id);
    await Future.delayed(Duration(seconds: delay));

    delay = min(delay * 2, 300);

    await connect(Uri.parse(
        'ws://${Env.NOTIFICATION_CORE_URL}/reconnect/${connection.id}'));
  }
}
