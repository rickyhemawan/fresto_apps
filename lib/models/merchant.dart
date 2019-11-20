import 'package:fresto_apps/models/menu.dart';
import 'package:fresto_apps/models/user.dart';

class Merchant extends User {
  String merchantName;
  String locationCoordinate;
  String locationName;
  String imageUrl;
  int openHour;
  int closeHour;
  bool dayOff;
  bool outOfOrder;
  List<Menu> menus;
}
