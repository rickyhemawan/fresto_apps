import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GoogleMapAPI {
  static Future<String> _getApiKey() async {
    final storage = FlutterSecureStorage();
    return await storage.read(key: "google-map-api");
  }
}
