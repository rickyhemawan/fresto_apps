import 'package:fresto_apps/models/user.dart';

class Client extends User {
  String fullName;
  String locationCoordinate;

  Client({
    String email,
    String phoneNumber,
    String userUid,
    this.fullName,
    this.locationCoordinate,
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
  }

  Map<String, dynamic> toJson() => {
        "uid": this.userUid,
        "email": this.email,
        "phoneNumber": this.phoneNumber,
        "fullName": this.fullName,
        "locationCoordinate": this.locationCoordinate,
      };
}
