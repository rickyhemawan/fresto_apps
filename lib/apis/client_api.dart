import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fresto_apps/apis/collection_names.dart';
import 'package:fresto_apps/models/client.dart';

class ClientAPI {
  static Future<void> addNewClientToDatabase(Client client) async {
    final Firestore firestore = Firestore.instance;
    if (client.allowTracking == null) client.allowTracking = false;
    await firestore
        .collection(kClientCollection)
        .document(client.userUid)
        .setData(client.toJson());
    return;
  }

  static Future<String> updateExistingClient(
      {@required Client currentClient, @required Client updatedClient}) async {
    if (currentClient == null || updatedClient == null)
      return "Nothing to update";
    if (currentClient.userUid != updatedClient.userUid)
      return "Client doesnt match";
    final Firestore firestore = Firestore.instance;
    try {
      await firestore
          .collection(kClientCollection)
          .document(currentClient.userUid)
          .setData(updatedClient.toJson());
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> updateSingleClientLocation(
      {@required String userUid, @required String locationCoordinate}) async {
    if (userUid == null) return "User id must not be null";
    if (locationCoordinate == null)
      return "Location coordinate must not be null";
    final Firestore firestore = Firestore.instance;
    try {
      await firestore
          .collection(kClientCollection)
          .document(userUid)
          .updateData({"locationCoordinate": locationCoordinate});
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<Client> getCurrentClient({@required String userUid}) async {
    Client client;
    await Firestore.instance
        .collection(kClientCollection)
        .document(userUid)
        .get()
        .then((DocumentSnapshot ds) {
      client = Client.fromJson(ds.data);
    });
    return client;
  }

  static Future<List<Client>> getClientsFromDatabase() async {
    List<Client> clients = [];
    await Firestore.instance
        .collection(kClientCollection)
        .getDocuments()
        .then((QuerySnapshot qs) {
      qs.documents.forEach((d) => clients.add(Client.fromJson(d.data)));
    });
    return clients;
  }

  static Stream listenSingleClient({String clientUid}) {
    final Firestore firestore = Firestore.instance;
    if (clientUid != null) {
      return firestore
          .collection(kClientCollection)
          .where("uid", isEqualTo: clientUid)
          .snapshots();
    }
    return null;
  }
}
