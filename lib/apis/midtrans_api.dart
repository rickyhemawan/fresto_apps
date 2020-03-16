import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fresto_apps/models/client.dart';
import 'package:fresto_apps/models/helper/payment_info.dart';
import 'package:fresto_apps/models/helper/transaction_finished.dart';
import 'package:fresto_apps/models/order.dart';
import 'package:http/http.dart' as http;

class MidtransAPI {
  static get kClientKey => DotEnv().env["MIDTRANS_CLIENT_KEY"];
  static get kServerKey => DotEnv().env["MIDTRANS_SERVER_KEY"];
  static get kSandboxBaseUrl => DotEnv().env["MIDTRANS_CHECKOUT_URL"];

  MidtransAPI._internal() {
    kPlatform.setMethodCallHandler(_methodHandler);
  }
  static MidtransAPI _instance = MidtransAPI._internal();
  factory MidtransAPI() => _instance;

  static String initPaymentSDK;

  static const kPlatform = MethodChannel("fresto/fresto_apps");
  static Future<void> _initSDK() async {
    if (initPaymentSDK != "Successfully Initialized SDKUIFlowBuilder") {
      await kPlatform.invokeMethod(
        "init",
        {
          "client_api_key": kClientKey,
          "check_out_url": kSandboxBaseUrl,
        },
      ).then(
        (val) {
          initPaymentSDK = val.toString();
        },
        onError: (e) {
          print(e.toString());
          initPaymentSDK = e.toString();
        },
      );
      print("initPaymentSDK => $initPaymentSDK");
    }
  }

  static Future<String> _pay(Order order, Client client) async {
    if (initPaymentSDK != "Successfully Initialized SDKUIFlowBuilder")
      await _initSDK();
    if (initPaymentSDK != "Successfully Initialized SDKUIFlowBuilder")
      return "Init Failed";
    String makePaymentMsg;
    await kPlatform.invokeMethod(
      "makePayment",
      {
        "clientStr": json.encode(client.toJson()),
        "orderStr": json.encode(order.toJson()),
      },
    ).then(
      (val) {
        print(val);
        makePaymentMsg = val.toString();
      },
      onError: (e) {
        print("invoke make payment says => ${e.toString()}");
        makePaymentMsg = e.toString();
      },
    );
    if (makePaymentMsg == "Payment Invoked") return null;
    return makePaymentMsg;
  }

  Future<void> _methodHandler(MethodCall call) async {
    print("this method invoked from flutter => ${call.method}");
    if (call.method == "onTransactionFinished") {
      print("method handler invoked");
      TransactionFinished transactionFinished = TransactionFinished(
        call.arguments['transactionCanceled'],
        call.arguments['status'],
        call.arguments['source'],
        call.arguments['statusMessage'],
        call.arguments['response'],
      );
      print(
          "transactionCanceled => ${transactionFinished.transactionCanceled}");
      print("status => ${transactionFinished.status}");
      print("source => ${transactionFinished.source}");
      print("statusMessage => ${transactionFinished.statusMessage}");
      print("response => ${transactionFinished.response}");
    }
    return Future.value(null);
  }

  static Future<String> invokePayment({Order order, Client client}) async {
    if (order == null) return "Order must not be null";
    if (client == null) return "Client must not be null";
    return await _pay(order, client);
  }

  static Future<PaymentInfo> getPaymentInfo({Order order}) async {
    if (order == null) throw "Order cannot be null";
    // Base Query String
    String queryString =
        "https://api.sandbox.midtrans.com/v2/${order.orderUid}/status";
    // Response
    final String base64ServerKey = base64Encode(utf8.encode(kServerKey));
    final response = await http.get(queryString, headers: {
      "Authorization": base64ServerKey,
    });
    if (response.statusCode != 200) throw "Cannot get payment details";
    print(response.body);
    try {
      return PaymentInfo.fromJson(json.decode(response.body));
    } catch (e) {
      print("getPaymentInfo => ${e.toString()}");
      throw "Payment is either pending or cancelled";
    }
  }
}
