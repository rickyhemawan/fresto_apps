import 'package:fresto_apps/models/menu.dart';
import 'package:fresto_apps/models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    this.menus = decodeMenusFromJson(json["menus"]);
    this.description = json["description"];
  }

  void addMenu(Menu menu) {
    if (this.menus == null) this.menus = [];
    menus.add(menu);
  }

  List<Menu> decodeMenusFromJson(List<dynamic> dynamics) {
    List<Menu> tempMenus = [];
    if (dynamics == null) return tempMenus;
    dynamics.forEach((e) {
      Map<String, dynamic> casted =
          Map.castFrom<dynamic, dynamic, String, dynamic>(e);
      tempMenus.add(Menu.fromJson(casted));
    });
    return tempMenus;
  }

  List encodeMenusToJson(List<Menu> list) {
    List jsonList = List();
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }

  LatLng get position {
    if (locationCoordinate == null) return null;
    List<String> val = locationCoordinate.split(",");
    return LatLng(double.parse(val[0].trim()), double.parse(val[1].trim()));
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
        "menus": encodeMenusToJson(this.menus),
        "description": this.description,
      };

  @override
  String toString() {
    return 'userUid: $userUid Merchant{merchantName: $merchantName, locationCoordinate: $locationCoordinate, locationName: $locationName, imageUrl: $imageUrl, openHour: $openHour, closeHour: $closeHour, dayOff: $dayOff, outOfOrder: $outOfOrder, menus: $menus, description: $description}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Merchant &&
          runtimeType == other.runtimeType &&
          merchantName == other.merchantName &&
          locationCoordinate == other.locationCoordinate &&
          locationName == other.locationName &&
          imageUrl == other.imageUrl &&
          openHour == other.openHour &&
          closeHour == other.closeHour &&
          dayOff == other.dayOff &&
          outOfOrder == other.outOfOrder &&
          description == other.description;

  @override
  int get hashCode =>
      merchantName.hashCode ^
      locationCoordinate.hashCode ^
      locationName.hashCode ^
      imageUrl.hashCode ^
      openHour.hashCode ^
      closeHour.hashCode ^
      dayOff.hashCode ^
      outOfOrder.hashCode ^
      menus.hashCode ^
      description.hashCode;
}
