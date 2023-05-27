import 'dart:convert';

import 'package:http/http.dart' as http;

class VarlaResponse {
  dynamic body;
  dynamic serverMessage;
  String serverDetails = "";
  late int statusCode;

  bool error = false;

  VarlaResponse(http.Response response) {
    body = json.decode(response.body);
    print(body);
    serverMessage = body["message"] ?? "";
    serverDetails = body["detail"].toString();
    statusCode = response.statusCode;

    if (statusCode >= 400) error = true;
  }
}
