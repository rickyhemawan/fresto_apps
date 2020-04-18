import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fresto_apps/apis/collection_names.dart';
import 'package:overlay_support/overlay_support.dart';

class CloudMessagingAPI {
  static final FirebaseMessaging fcm = FirebaseMessaging();
  static String currentUser;

  static String getServerKey() {
    return DotEnv().env["FCM_SERVER_KEY"];
  }

  static Future<dynamic> backgroundMessageHandler(
      Map<String, dynamic> message) async {
    print("onBackgroundMessage ===> $message");
  }

  static Future<String> saveTokenToUser(
      {@required String collectionName, @required String fcmToken}) async {
    if (currentUser == null) return "User Uid is null";
    final Firestore firestore = Firestore.instance;
    try {
      await firestore
          .collection(collectionName)
          .document(currentUser)
          .collection(kUserTokenCollection)
          .document(fcmToken)
          .setData({
        "token": fcmToken,
        "createdAt": FieldValue.serverTimestamp(),
        "platform": Platform.operatingSystem,
      });
      return null;
    } catch (e) {
      print(e.toString());
      return "Failed to register FCM Token to firestore";
    }
  }

  static Future<String> removeTokenFromUser(
      {@required String collectionName, @required String userUid}) async {
    if (collectionName == null) return "Cannot Connect to database";
    if (userUid == null) return "Cannot Connect to the database";
    final Firestore firestore = Firestore.instance;
    try {
      String deviceToken = await fcm.getToken();
      await firestore
          .collection(collectionName)
          .document(userUid)
          .collection(kUserTokenCollection)
          .document(deviceToken)
          .delete();
      return null;
    } catch (e) {
      print(e.toString());
      return "Failed to delete FCM from firestore";
    }
  }

  static Widget _buildDialog(BuildContext context, ParsedFCM parsedFCM) {
    print("_buildDialog Invoked");
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: SafeArea(
        child: ListTile(
          title: Text('${parsedFCM.notificationTitle}'),
          subtitle: Text('${parsedFCM.notificationBody}'),
          trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                OverlaySupportEntry.of(context).dismiss();
              }),
        ),
      ),
    );
  }

  static Future<String> configure(
      {@required String userUid,
      @required String collectionName,
      @required BuildContext context}) async {
    // Validation
    if (userUid == null && currentUser == null) return "User Uid is null";
    if (collectionName == null) return "Collection Name is null";
    if (context == null) return "Context is null";
    if (userUid == currentUser) return "Nothing to update because both equal";
    // Set this session currentUserUid
    currentUser = userUid;
    // Get token
    String fcmToken = await fcm.getToken();
    if (fcmToken == null) return "FCM Token is null";
    // Save token to firestore
    String msg = await saveTokenToUser(
        collectionName: collectionName, fcmToken: fcmToken);
    if (msg != null) return msg;
    // configure on message received
    // TODO: handle different user type (merchant / client)
    fcm.configure(
      onBackgroundMessage: backgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch ===> $message");
      },
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage ===> $message");
        ParsedFCM parsedFCM = ParsedFCM.fromJson(message);
        print(parsedFCM);
        showOverlayNotification((context) {
          return _buildDialog(context, parsedFCM);
        }, duration: Duration(milliseconds: 4000));
        print("onMessage Done");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume ===> $message");
      },
    );
    return null;
  }
}

class ParsedFCM {
  String notificationTitle;
  String notificationBody;

  ParsedFCM({this.notificationTitle, this.notificationBody});
  ParsedFCM.fromJson(Map<String, dynamic> json) {
    print("parsed fcm from json invoked!");
    this.notificationTitle = json['notification']["title"];
    this.notificationBody = json['notification']["body"];
    print("fcm done invoked");
  }

  @override
  String toString() {
    return 'ParsedFCM{notificationTitle: $notificationTitle, notificationBody: $notificationBody}';
  }
}
