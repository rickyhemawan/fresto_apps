import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/apis/client_api.dart';
import 'package:fresto_apps/apis/cloud_messaging_api.dart';
import 'package:fresto_apps/apis/collection_names.dart';
import 'package:fresto_apps/apis/device_tracking_api.dart';
import 'package:fresto_apps/models/client.dart';
import 'package:fresto_apps/utils/constants.dart';

class ClientData extends ChangeNotifier {
  FirebaseAuth auth;
  FirebaseUser firebaseUser;
  Client client;
  Client updateClient;

  bool isLoading = false;
  bool isTracking = false;

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

  Future<String> saveChanges() async {
    if (isSameAsPrevious()) return "Nothing to update";
    if (updateClient.allowTracking == null) updateClient.allowTracking = false;

    // Change location if Allow tracking checked
    if (!updateClient.allowTracking) {
      updateClient.locationCoordinate = null;
    } else {
      updateClient.locationCoordinate =
          await DeviceTrackingAPI().getDeviceLocation();
      if (updateClient.locationCoordinate == null)
        return "Cant get device location";
    }
    String res = await ClientAPI.updateExistingClient(
        currentClient: client, updatedClient: updateClient);
    if (res != null) return res;
    loadClientData();
    print("This device coordinate => ${updateClient.locationCoordinate}");
    return null;
  }

  void loadClientData({BuildContext context}) async {
    await auth.currentUser().then((FirebaseUser user) => firebaseUser = user);

    if (firebaseUser == null) return;
    client = await ClientAPI.getCurrentClient(userUid: firebaseUser.uid);
    updateClient = Client.fromJson(client.toJson());

    // Maps
    if (client.allowTracking == null) client.allowTracking = false;
    if (client.allowTracking) {
      DeviceTrackingAPI().initTracking(userUid: client.userUid);
    } else {
      DeviceTrackingAPI().stopTracking();
      setTracking(false);
    }

    if (context == null) {
      notifyListeners();
      return;
    }

    // FCM
    String msg = await CloudMessagingAPI.configure(
      userUid: client.userUid,
      collectionName: kClientCollection,
      context: context,
    );
    if (msg != null) Fluttertoast.showToast(msg: msg);
    notifyListeners();
  }

  bool isSameAsPrevious() {
    return client == updateClient;
  }

  void setLoading(bool loading) {
    this.isLoading = loading;
    notifyListeners();
  }

  void setTracking(bool tracking) {
    if (client == null) {
      Fluttertoast.showToast(msg: "Please wait for couple of seconds");
      return;
    }
    if (client.allowTracking == null) client.allowTracking = false;
    if (client.allowTracking == false) {
      this.isTracking = false;
      notifyListeners();
      Fluttertoast.showToast(msg: kNotAllowedTracking);
      return;
    }
    this.isTracking = tracking;
    DeviceTrackingAPI().setTrackStatus(tracking);
    notifyListeners();
  }
}
