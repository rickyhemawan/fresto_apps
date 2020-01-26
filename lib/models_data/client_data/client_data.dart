import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fresto_apps/apis/client_api.dart';
import 'package:fresto_apps/models/client.dart';

class ClientData extends ChangeNotifier {
  FirebaseAuth auth;
  FirebaseUser firebaseUser;
  Client client;

  ClientData() {
    this.auth = FirebaseAuth.instance;
  }

  String getClientName() {
    if (client == null) return "Name";
    return client.fullName;
  }

  String getClientEmail() {
    if (client == null) return "email";
    return client.email;
  }

  String getClientPhoneNumber() {
    if (client == null) return "phone number";
    return client.phoneNumber;
  }

  void updateCurrentClientData() async {
    await auth.currentUser().then((FirebaseUser user) => firebaseUser = user);

    if (firebaseUser == null) return;
    client = await ClientAPI.getCurrentClient(userUid: firebaseUser.uid);
    notifyListeners();
  }
}
