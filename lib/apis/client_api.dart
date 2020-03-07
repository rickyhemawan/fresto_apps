import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fresto_apps/apis/collection_names.dart';
import 'package:fresto_apps/models/client.dart';

class ClientAPI {
  static Future<void> addNewClientToDatabase(Client client) async {
    final Firestore firestore = Firestore.instance;
    await firestore
        .collection(kClientCollection)
        .document(client.userUid)
        .setData(client.toJson());
    return;
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
}
