import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:fresto_apps/apis/google_map_api.dart';
import 'package:fresto_apps/models/menu.dart';
import 'package:fresto_apps/models/merchant.dart';

class RestaurantFileReader {
  List<Merchant> _merchants;
  static RestaurantFileReader _instance;

  factory RestaurantFileReader() {
    if (_instance == null) {
      _instance = RestaurantFileReader.instance();
    }
    return _instance;
  }

  RestaurantFileReader.instance();

  Future loadAsset() async {
    final List<Merchant> loadedMerchants = [];
    await rootBundle.loadString("assets/data/restaurant.csv").then((val) async {
      final res = CsvToListConverter().convert(val);
      print(res.length);
      Merchant tempMerchant;
      for (int i = 0; i < res.length; i++) {
        if (_checkWhichData(res[i][0])) {
          String coordinate = res[i][2].toString().trim();
          coordinate = coordinate.substring(0, coordinate.length - 1);
          String locationName =
              await GoogleMapAPI.getAddress(coordinate: coordinate);
          if (tempMerchant != null) _merchants.add(tempMerchant);
          tempMerchant = Merchant(
            phoneNumber: "081231231231",
            email: res[i][5],
            description: res[i][3],
            imageUrl: res[i][4],
            merchantName: res[i][1],
            locationCoordinate: coordinate,
            menus: [],
            dayOff: false,
            openHour: 0,
            closeHour: 0,
            locationName: locationName,
          );
          print(tempMerchant);
          _merchants = loadedMerchants;
        } else {
          String priceString = res[i][2].replaceAll(RegExp(r","), "");
          Menu menu = Menu(
            name: res[i][1],
            price: double.parse(priceString),
            description: res[i][3],
            imageUrl: res[i][4],
            available: true,
          );
          tempMerchant.addMenu(menu);
        }
      }
      loadedMerchants.add(tempMerchant);
      loadedMerchants.forEach((f) => print(f));
    });
    _merchants = loadedMerchants;
  }

  Future<List<Merchant>> getMerchantsFromCSV() async {
    if (_merchants == null) await loadAsset();
    return _merchants;
  }

  bool _checkWhichData(String status) {
    if (status.trim() == "RESTAURANT") return true;
    if (status.trim() == "MENU") return false;
    throw new Exception("$status inputted, It is neither RESTAURANT or MENU");
  }
}
