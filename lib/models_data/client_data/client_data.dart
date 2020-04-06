import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/apis/client_api.dart';
import 'package:fresto_apps/models/client.dart';

class ClientData extends ChangeNotifier {
  FirebaseAuth auth;
  FirebaseUser firebaseUser;
  Client client;
  Client updateClient;

  bool isLoading = false;

  ClientData() {
    this.auth = FirebaseAuth.instance;
  }

  String getClientName() {
    if (client == null) return "Name";
    return updateClient.fullName;
  }

  String getClientEmail() {
    if (client == null) return "email";
    return updateClient.email;
  }

  String getClientPhoneNumber() {
    if (client == null) return "phone number";
    return updateClient.phoneNumber;
  }

  bool isTrackingAllowed() {
    if (client == null) return false;
    return updateClient.allowTracking;
  }

  void setClientName(String name) {
    updateClient.fullName = name;
    notifyListeners();
  }

  String validatePhoneNumber(String phoneNumber) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (phoneNumber.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(phoneNumber)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  void setClientPhoneNumber(String phoneNumber) {
    if (validatePhoneNumber(phoneNumber) != null) {
      Fluttertoast.showToast(msg: validatePhoneNumber(phoneNumber));
      return;
    }
    updateClient.phoneNumber = phoneNumber;
    notifyListeners();
  }

  void toggleAllowTracking(bool val) {
    updateClient.allowTracking = val;
    notifyListeners();
  }

  void updateCurrentClientData() async {
    await auth.currentUser().then((FirebaseUser user) => firebaseUser = user);

    if (firebaseUser == null) return;
    client = await ClientAPI.getCurrentClient(userUid: firebaseUser.uid);
    updateClient = Client.fromJson(client.toJson());
    notifyListeners();
  }

  bool isSameAsPrevious() {
    return client == updateClient;
  }
}
