import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:varla/Utility/Env/env.dart';

class OrchestartorEntry {
  String name;
  late bool status;
  OrchestartorEntry({
    required this.name,
  }) {
    status = name.toString().split(" ")[2] == "up!";
    name = name.split(" ")[0];
  }

  Future<dynamic> start() async {
    var client = http.Client();
    try {
      var decodedResponse = client
          .post(
            Uri.parse('https://${Env.VARLA_GATEWAY_URL}/up'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              "services_names": [name]
            }),
          )
          .then((value) =>
              jsonDecode(utf8.decode(value.bodyBytes)) as List<dynamic>);
      return decodedResponse;
    } finally {
      client.close();
    }
  }

  Future<dynamic> stop() async {
    var client = http.Client();
    try {
      var decodedResponse = client
          .post(
            Uri.parse('https://${Env.VARLA_GATEWAY_URL}/down'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              "services_names": [name]
            }),
          )
          .then((value) =>
              jsonDecode(utf8.decode(value.bodyBytes)) as List<dynamic>);
      return decodedResponse;
    } finally {
      client.close();
    }
  }

  Future<dynamic> restart() async {
    var client = http.Client();
    try {
      var decodedResponse = client
          .post(
            Uri.parse('https://${Env.VARLA_GATEWAY_URL}/restart'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              "services_names": [name]
            }),
          )
          .then((value) =>
              jsonDecode(utf8.decode(value.bodyBytes)) as List<dynamic>);
      return decodedResponse;
    } finally {
      client.close();
    }
  }
}
