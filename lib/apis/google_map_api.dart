import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class GoogleMapAPI {
  static final _searchByCoordinate =
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=";

  static String getApiKey() {
    return DotEnv().env["MAPS_API_KEY"];
  }

  static Future<String> getAddress({@required String coordinate}) async {
    String url = _searchByCoordinate + coordinate + "&key=${getApiKey()}";
    print(url);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedData = json.decode(response.body);
      return decodedData["results"][0]["formatted_address"];
    }
    throw Exception(
        "status code: ${response.statusCode}, body: ${response.body}");
  }

  static Future<String> openExternalMap({@required String coordinate}) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$coordinate';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
      return null;
    } else {
      return 'Could not open the map.';
    }
  }
}
