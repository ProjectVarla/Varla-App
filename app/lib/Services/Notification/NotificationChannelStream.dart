import 'dart:io';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:varla/Services/Notification/temp.dart';
import 'package:varla/Utility/NetworkConnection.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class NotificationChannelStream {
  WebSocketChannel? channel;
  Uri? uri;

  bool aborted = false;
  int delay = 1;
  bool isAcknowledged = false;
  bool skipReconnection = false;
  bool isAlive = false;

  final String serverUrl;
  final String channelName;

  NotificationChannelStream({
    required this.serverUrl,
    required this.channelName,
  });

  void listen() {
    // Listen to streams.

    channel?.stream.listen((message) async {
      print("in body");

      // If message arives:
      send("alive");

      // confirm connection is valid.
      isAcknowledged = true;
      isAlive = true;
      // reset reconnection delay.
      delay = 1;

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

      // Send Notification with the message.
      // TODO check if confirmation message first.
      await showNotificationWithActions(message, actions: list);
    }, onError: (e) {
      close();
      // On error close connection.
      //TODO try if exceptions work here :P.
    }, onDone: () async {
      // On socket close
      await onDone();
    });
  }

  Future<bool> hasInternt(int delay) async {
    if (delay >= 64 && !await IsConnected()) {
      print("Not Connected to Internet!");

      //TODOadd reconnect button
      await showNotificationWithActions("Not Connected to Internet!");

      return false;
    }
    return true;
  }

  Future<void> onDone() async {
    print("OnDone!:");
    close();
    // Always try to reconnect unless aborted
    if (aborted) return;

    // Always try to reconnect unless internet not connected!
    if (!await hasInternt(delay)) {
      abort_reconnecting();
      return;
    }

    print("not aborted, reconncting in ${delay}");
    reconnect();
  }

  Future<void> connect() async {
    // Connect to socket.
    try {
      isAcknowledged = false;
      print("Entering Connection");
      channel = await WebSocketChannel.connect(uri!);
      print("Exiting Connection");

      // Listen to socket.
      print("Entering listen");
      listen();
      print("Exiting listen");

      // Ensure Acknowledgement.
      print("Entering ack check");
      await handleAcknowledgement();
      print("Exiting ack check");
    } on SocketException catch (e) {
      print("heloooo");
      print(e);
    } catch (e) {
      print("heloXXXXXXXXXXXXXXXXooo");

      print(e);
    }
  }

  Future<void> init() async {
    // Checking if channel is already been inited.
    if (aborted) return;

    if (channel == null) {
      print("Connecting");

      // Parsing URI.
      uri = Uri.parse('ws://${serverUrl}/bind/${channelName}');

      try {
        // Connecting to server.
        await connect();

        print(isAcknowledged);

        if (!isAcknowledged) {
          await showNotificationWithActions(
              "Sir, I can not connect to ${uri.toString()}");

          if (delay > 32) {
            print("closing perminantly");
            abort_reconnecting();
          }
          if (!aborted) {
            await Future.delayed(Duration(seconds: delay));
            reconnect();
            delay *= 2;
          }
        }
      } catch (e) {
        await showNotificationWithActions(
            "Sir, I am facing a problem in push notification system. in channel : <channelName>" +
                e.toString());
      }
    } else {
      print("Already connected");
    }
    print("Connected");
  }

  void send(String message) {
    channel?.sink.add(message);
  }

  void reconnect() async {
    // close();
    if (skipReconnection) {
      await showNotificationWithActions(
          "skipping reconnecting until acknowledgment timeout!");
      return;
    }

    await showNotificationWithActions("reconnecting in ${delay}");
    await Future.delayed(Duration(seconds: delay));
    delay = min(delay * 2, 300);
    await init();
  }

  void abort_reconnecting() {
    print("aborting");
    showNotificationWithActions("aborting reconnection");
    aborted = true;
  }

  void resume_reconnecting() {
    aborted = false;
    reconnect();
  }

  void close() {
    if (channel == null) {
      print("Not Connected!");
      return;
    }
    isAlive = false;
    channel?.sink.close(status.goingAway);
    channel = null;
    print("Connection Closed");
  }

  Future<void> handleAcknowledgement() async {
    skipReconnection = true;
    int ackDelay = 4;
    while (!isAcknowledged && ackDelay <= 32) {
      if (!await hasInternt(ackDelay)) {
        abort_reconnecting();
        return;
      }
      await showNotificationWithActions(
          "waiting for acknowledgement in ${ackDelay}");

      await Future.delayed(Duration(seconds: min(ackDelay, 300)));
      ackDelay *= 2;
    }
    await showNotificationWithActions("Acknowledgement timedout!");
    skipReconnection = false;
  }
}
