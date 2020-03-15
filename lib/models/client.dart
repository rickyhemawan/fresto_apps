import 'package:fresto_apps/models/user.dart';

class Client extends User {
  String fullName;
  String locationCoordinate;
  bool allowTracking;

  Client({
    String email,
    String phoneNumber,
    String userUid,
    this.fullName,
    this.locationCoordinate,
    this.allowTracking = false,
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
  }

  Map<String, dynamic> toJson() => {
        "uid": this.userUid,
        "email": this.email,
        "phoneNumber": this.phoneNumber,
        "fullName": this.fullName,
        "locationCoordinate": this.locationCoordinate,
        "allowTracking": this.allowTracking,
      };
}
