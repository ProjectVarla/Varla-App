import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:varla/Services/Notification/NotificationService.dart';
import 'package:varla/Services/Notification/temp.dart';
import 'package:varla/Utility/NetworkConnection.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationApi {
  // Future<http.Response> subscribe(String channelName) {
  //   return http.post(
  //     Uri.parse('http://${serverUrl}/subscribe'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, dynamic>{
  //       "channels": [
  //         {"name": channelName, "verbosity": 2}
  //       ],
  //       // "connection_id": connection_id
  //     }),
  //   );
  // }

  // Future<List<NotificationChannel>> getChannels() async {
  //   var client = http.Client();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   try {
  //     var decodedResponse = client.post(
  //       Uri.parse('http://${serverUrl}/list_subscribtions'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       // body: jsonEncode(<String, dynamic>{"connection_id": connection_id}),
  //     ).then((value) => jsonDecode(utf8.decode(value.bodyBytes))
  //         as List<NotificationChannel>);
  //     return decodedResponse;
  //   } finally {
  //     client.close();
  //   }
  // http.Response response = http.post(
  // Uri.parse('http://${serverUrl}/list_subscribtions'),
  // headers: <String, String>{
  //   'Content-Type': 'application/json; charset=UTF-8',
  // },
  // body: jsonEncode(<String, dynamic>{"connection_id": connection_id}),
  // );
  // return response;
  // }
}
