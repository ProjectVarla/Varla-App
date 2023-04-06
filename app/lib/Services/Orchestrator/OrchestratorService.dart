import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:varla/Utility/Env/env.dart';

class OrchestratorService {
  static Future<List<dynamic>> listServices() async {
    var client = http.Client();
    try {
      var decodedResponse = client
          .post(
            Uri.parse('https://${Env.VARLA_GATEWAY_URL}/status'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              "select_all": true,
            }),
          )
          .then((value) =>
              jsonDecode(utf8.decode(value.bodyBytes)) as List<dynamic>);
      return decodedResponse;
    } finally {
      client.close();
    }
  }

  static Future<dynamic> startServices(String serviceName) async {
    var client = http.Client();
    try {
      var decodedResponse = client
          .post(
            Uri.parse('https://${Env.VARLA_GATEWAY_URL}/up'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              "services_names": [serviceName]
            }),
          )
          .then((value) => jsonDecode(utf8.decode(value.bodyBytes)) as dynamic);
      return decodedResponse;
    } finally {
      client.close();
    }
  }

  static Future<dynamic> stopServices(String serviceName) async {
    var client = http.Client();
    try {
      var decodedResponse = client
          .post(
            Uri.parse('https://${Env.VARLA_GATEWAY_URL}/down'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              "services_names": [serviceName]
            }),
          )
          .then((value) => jsonDecode(utf8.decode(value.bodyBytes)) as dynamic);
      return decodedResponse;
    } finally {
      client.close();
    }
  }

  static Future<dynamic> restartServices(String serviceName) async {
    var client = http.Client();
    try {
      var decodedResponse = client
          .post(
            Uri.parse('https://${Env.VARLA_GATEWAY_URL}/restart'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              "services_names": [serviceName]
            }),
          )
          .then((value) => jsonDecode(utf8.decode(value.bodyBytes)) as dynamic);
      return decodedResponse;
    } finally {
      client.close();
    }
  }
  //  Future<List<dynamic>> listServices() async {
  //   var client = http.Client();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   try {
  //     var decodedResponse = client
  //         .post(
  //           Uri.parse('http://${serverUrl}/list_subscribtions'),
  //           headers: <String, String>{
  //             'Content-Type': 'application/json; charset=UTF-8',
  //           },
  //           body: jsonEncode(<String, dynamic>{"connection_id": connection_id}),
  //         )
  //         .then((value) =>
  //             jsonDecode(utf8.decode(value.bodyBytes)) as List<dynamic>);
  //     return decodedResponse;
  //   } finally {
  //     client.close();
  //   }
  // }
}
