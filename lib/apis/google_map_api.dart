import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GoogleMapAPI {
  static final _searchByCoordinate =
      "https://maps.googleapis.com/maps/api/geocode/json?latlng=";

  static String getApiKey() {
    return DotEnv().env["MAPS_API_KEY"];
  }

  static Future<String> getAddress({@required coordinate}) async {
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
}
