import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fresto_apps/apis/collection_names.dart';
import 'package:fresto_apps/models/client.dart';
import 'package:fresto_apps/models/user.dart';

class ClientAPI {
  static void addNewUserToDatabase(User user) {
    final Firestore firestore = Firestore.instance;
    if (user is Client) {
      firestore.collection(kClientCollection).document().setData(user.toJson());
      return;
    }
  }
}
