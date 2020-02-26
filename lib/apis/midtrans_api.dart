import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class MidtransAPI {
  static const kSandboxBaseUrl =
      "https://app.sandbox.midtrans.com/snap/v1/transactions";
  static const kServerKey = "SB-Mid-server-d1L4fCIex-e-TC9wFGF1vSyY";
  static const kClientKey = "SB-Mid-client-DUA0Ujl6E3ieGEyu";
  static get kAuthString {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode("$kServerKey:");
  }

  static const kPlatform = MethodChannel("fresto/fresto_apps");

  static void testMidTrans() async {
    Map testHeader = {
      "SERVER_KEY": kServerKey,
      "AUTH_STRING": kAuthString,
    };
    Map testBody = {
      "transaction_details": {
        "order_id": "ORDER-101",
        "gross_amount": 10000,
      }
    };
    var response = await http.post(
      kSandboxBaseUrl,
      headers: testHeader,
      body: testBody,
    );
    print(response);
  }

  static void testCallInvokeMethod() async {
    print("otw invoke platform");
    print(await kPlatform.invokeMethod("testInvoke"));
    print("done invoke platform");
  }

  static void testCallMidtrans() async {
    print(await kPlatform.invokeMethod('charge'));
  }
}
