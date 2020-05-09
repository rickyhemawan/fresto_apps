import 'package:fresto_apps/models/user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Client extends User {
  String fullName;
  String locationCoordinate;
  bool allowTracking;
  bool nearFCMSent;

  Client({
    String email,
    String phoneNumber,
    String userUid,
    this.fullName,
    this.locationCoordinate,
    this.allowTracking = false,
    this.nearFCMSent = false,
  }) : super(
          userUid: userUid,
          email: email,
          phoneNumber: phoneNumber,
        );

  Client.fromJson(Map<String, dynamic> json) {
    this.userUid = json["uid"];
    this.email = json["email"];
    this.phoneNumber = json["phoneNumber"];
    this.fullName = json["fullName"];
    this.locationCoordinate = json["locationCoordinate"];
    this.allowTracking = json["allowTracking"];
    this.nearFCMSent = json["nearFCMSent"];
  }

  Map<String, dynamic> toJson() => {
        "uid": this.userUid,
        "email": this.email,
        "phoneNumber": this.phoneNumber,
        "fullName": this.fullName,
        "locationCoordinate": this.locationCoordinate,
        "allowTracking": this.allowTracking,
        "nearFCMSent": this.nearFCMSent,
      };
  LatLng get position {
    if (locationCoordinate == null) return null;
    List<String> val = locationCoordinate.split(",");
    return LatLng(double.parse(val[0].trim()), double.parse(val[1].trim()));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Client &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          phoneNumber == other.phoneNumber &&
          userUid == other.userUid &&
          fullName == other.fullName &&
          locationCoordinate == other.locationCoordinate &&
          allowTracking == other.allowTracking;

  @override
  int get hashCode =>
      fullName.hashCode ^ locationCoordinate.hashCode ^ allowTracking.hashCode;
}
