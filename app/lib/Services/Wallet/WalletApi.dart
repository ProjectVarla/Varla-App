
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:varla/Utility/Env/env.dart';
import 'package:varla/Utility/Request/request.dart' as varla;
import 'package:varla/Utility/Request/response.dart';
import 'dart:convert';

import 'package:varla/View/Wallet/WalletPage.dart';

class WalletApi {
  static Future<VarlaResponse> listInvoiceGroups() async {
    return await varla
        .post('http://10.0.2.2:9000/api/invoices/get/groups', body: {});
  }

  static Future<VarlaResponse> listInvoiceItems(int id) async {
    return await varla.post('http://10.0.2.2:9000/api/invoices/get/invoices',
        body: {"group_id": id});
  }

  static Future<VarlaResponse> listInvoiceSubscriptions(int id) async {
    return await varla.post(
        'http://10.0.2.2:9000/api/invoices/get/subscriptions',
        body: {"group_id": id});
  }
  // static Future<List<dynamic>> list() async {
  //   var client = http.Client();
  //   // SharedPreferences prefs = await SharedPreferences.getInstance();
  //   try {
  //     var decodedResponse = await client.post(
  //         Uri.parse('http://10.0.2.2:9000/api/invoices/get/invoice_groups'),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //         body: json.encode({}));

  //     List<dynamic> d = json.decode(utf8.decode(decodedResponse.bodyBytes));
  //     print(d);

  //     print("**********");

  //     return d;
  //   } finally {
  //     // client.close();
  //   }

  //   // return varla
  //   //     .post('http://10.0.2.2:9000/api/invoices/get/invoice_groups', body: {});
  // }

  static Future<List<dynamic>> list_invoices(int id) async {
    var client = http.Client();
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var decodedResponse = await client.post(
          Uri.parse('http://10.0.2.2:9000/api/invoices/get/invoices'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({"group_id": id}));

      List<dynamic> d = json.decode(utf8.decode(decodedResponse.bodyBytes));
      print(d);

      print("**********");

      return d;
    } finally {
      // client.close();
    }

    // return varla
    //     .post('http://10.0.2.2:9000/api/invoices/get/invoice_groups', body: {});
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
