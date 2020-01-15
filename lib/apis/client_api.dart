import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresto_apps/apis/collection_names.dart';
import 'package:fresto_apps/models/client.dart';

class ClientAPI {
  static Future<void> addNewClientToDatabase(Client client) async {
    final Firestore firestore = Firestore.instance;
    await firestore
        .collection(kClientCollection)
        .document()
        .setData(client.toJson());
    return;
  }
}
