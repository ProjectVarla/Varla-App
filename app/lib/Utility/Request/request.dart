import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:varla/Utility/Env/env.dart';
import 'package:varla/Utility/Request/response.dart';

Future<VarlaResponse> post(String url,
    {Map<String, dynamic>? headers, Map<String, dynamic>? body}) async {
  var client = http.Client();
  try {
    var response = VarlaResponse(await client.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          ...?headers,
        },
        body: json.encode(body)));

    // if (response.statusCode == 503) ret;
    print(response.statusCode);
    // print(response.serverDetails);
    // final responseJson = //json.decode(response.body);
    return response;
  } finally {
    client.close();
  }
}
