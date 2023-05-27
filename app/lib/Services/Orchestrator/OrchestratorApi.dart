import 'dart:async';
import 'dart:convert';

import 'package:varla/Utility/Env/env.dart';
import 'package:varla/Utility/Request/request.dart' as varla;
import 'package:varla/Utility/Request/response.dart';

class OrchestratorApi {
  static Future<VarlaResponse> list() async {
    return varla.post('https://${Env.VARLA_GATEWAY_URL}/status', body: {
      "select_all": "true",
    });
  }

  // static Future<VarlaResponse> backup(String backupName) async {
  //   return varla.post(
  //       'https://${Env.VARLA_GATEWAY_URL}/FileManager/backup/trigger/${backupName}');
  // }

  // static Future<VarlaResponse> backupAll() async {
  //   return varla.post(
  //       'https://${Env.VARLA_GATEWAY_URL}/FileManager/backup/trigger_all');
  // }
}
