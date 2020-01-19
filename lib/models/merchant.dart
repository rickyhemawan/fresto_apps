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
  String description;

  Merchant({
    String email,
    String phoneNumber,
    String userUid,
    this.merchantName,
    this.locationCoordinate,
    this.locationName,
    this.imageUrl,
    this.openHour,
    this.closeHour,
    this.dayOff,
    this.outOfOrder,
    this.menus,
    this.description,
  }) : super(
          userUid: userUid,
          email: email,
          phoneNumber: phoneNumber,
        );

  Merchant.fromJson(Map<String, dynamic> json) {
    this.userUid = json["uid"];
    this.email = json["email"];
    this.phoneNumber = json["phoneNumber"];
    this.merchantName = json["merchantName"];
    this.locationCoordinate = json["locationCoordinate"];
    this.locationName = json["locationName"];
    this.imageUrl = json["imageUrl"];
    this.openHour = json["openHour"];
    this.closeHour = json["closeHour"];
    this.dayOff = json["dayOff"];
    this.outOfOrder = json["dayOff"];
    this.menus = json["menus"];
    this.description = json["description"];
  }

  List encodeToJson(List<Menu> list) {
    List jsonList = List();
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }

  Map<String, dynamic> toJson() => {
        "uid": this.userUid,
        "email": this.email,
        "phoneNumber": this.phoneNumber,
        "merchantName": this.merchantName,
        "locationCoordinate": this.locationCoordinate,
        "locationName": this.locationName,
        "imageUrl": this.imageUrl,
        "openHour": this.openHour,
        "closeHour": this.closeHour,
        "dayOff": this.dayOff,
        "outOfOrder": this.outOfOrder,
        "menus": encodeToJson(this.menus),
        "description": this.description,
      };
}
