import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

abstract class MerchantBaseData extends ChangeNotifier {
  final kDummyImage =
      CachedNetworkImage(imageUrl: kDummyDefaultImage, fit: BoxFit.cover);

  FirebaseAuth auth;
  FirebaseUser user;
  Merchant merchant;
  File file;

  MerchantBaseData() {
    this.auth = FirebaseAuth.instance;
  }

  void _createMerchantInstance() {
    if (merchant == null) merchant = Merchant(dayOff: false, menus: []);
  }

  void resetMerchantValue() {
    merchant = null;
    notifyListeners();
  }

  String merchantValidation() {
    if (merchant == null) return kNullMerchantName;
    if (merchant.merchantName == null) return kNullMerchantName;
    if (merchant.openHour == null) return kNullOperationHour;
    if (merchant.closeHour == null) return kNullOperationHour;
    if (merchant.locationName == null) return kNullMerchantAddress;
    if (merchant.locationCoordinate == null) return kNullMerchantAddress;
    if (merchant.phoneNumber == null) return kNullPhoneNumber;
    return null;
  }

  //--------------------------
  // Callbacks For Google Maps
  //--------------------------

  void onAddressChanged(String addressName, String coordinate) {
    setMerchantAddressCoordinate(coordinate);
    setMerchantAddressName(addressName);
  }

  //--------
  // Getters
  //--------

  Widget getMerchantImage() {
    if (file != null) {
      return Image.file(file, fit: BoxFit.fill);
    }
    if (merchant == null) return kDummyImage;
    if (merchant.imageUrl == null) return kDummyImage;
    if (merchant.imageUrl != null)
      return CachedNetworkImage(
        imageUrl: merchant.imageUrl,
        fit: BoxFit.fill,
      );
    return kDummyImage;
  }

  String getMerchantTitle() {
    if (merchant == null) return kDefaultRestaurantName;
    if (merchant.merchantName == null) return kDefaultRestaurantName;
    if (merchant.merchantName.trim() == "") return kDefaultRestaurantName;
    return merchant.merchantName;
  }

  String getMerchantOperatingHour() {
    if (merchant == null) return kDefaultOperatingTime;
    if (merchant.openHour == null) return kDefaultOperatingTime;
    if (merchant.closeHour == null) return kDefaultOperatingTime;
    if (merchant.openHour == merchant.closeHour) return "Open 24 Hour";
    return "Open from ${merchant.openHour}:00 until ${merchant.closeHour}:00";
  }

  String getMerchantDescription() {
    if (merchant == null) return kDefaultDescription;
    if (merchant.description == null) return kDefaultDescription;
    return merchant.description;
  }

  String getMerchantAddress() {
    if (merchant == null) return kDefaultAddress;
    if (merchant.locationName == null) return kDefaultAddress;
    if (merchant.locationName == "") return kDefaultAddress;
    if (merchant.locationCoordinate == null) return kDefaultAddress;
    if (merchant.locationCoordinate == null) return kDefaultAddress;
    return merchant.locationName;
  }

  String getMerchantEmail() {
    if (merchant == null) return kDefaultEmail;
    if (merchant.email == null) return kDefaultEmail;
    if (merchant.email == "") return kDefaultEmail;
    return merchant.email;
  }

  String getMerchantPhoneNumber() {
    if (merchant == null) return kDefaultPhoneNumber;
    if (merchant.phoneNumber == null) return kDefaultPhoneNumber;
    if (merchant.phoneNumber == "") return kDefaultPhoneNumber;
    return merchant.phoneNumber;
  }

  bool isMerchantOpen() {
    if (merchant == null) return false;
    if (merchant.openHour == null) return false;
    if (merchant.closeHour == null) return false;
    if (merchant.dayOff) return false;
    int currentHour = DateTime.now().hour;
    if (merchant.openHour == merchant.closeHour) return true;
    int realCloseHour = merchant.openHour > merchant.closeHour
        ? merchant.closeHour + 24
        : merchant.closeHour;
    if (realCloseHour > currentHour && merchant.openHour <= currentHour)
      return true;
    return false;
  }

  bool isDayOff() {
    if (merchant == null) return false;
    return merchant.dayOff;
  }

  //--------
  // Setters
  //--------

  void setMerchant({@required Merchant merchant}) {
    this.merchant = merchant;
    notifyListeners();
  }

  void setImageViaFile(File file) {
    _createMerchantInstance();
    this.merchant.imageUrl = null;
    this.file = file;
    notifyListeners();
  }

  void setImageViaURL(String url) {
    _createMerchantInstance();
    this.file = null;
    this.merchant.imageUrl = url;
    notifyListeners();
  }

  void setMerchantName(String name) {
    _createMerchantInstance();
    this.merchant.merchantName = name;
    notifyListeners();
  }

  void setMerchantDescription(String description) {
    _createMerchantInstance();
    this.merchant.description = description;
    notifyListeners();
  }

  void setMerchantCloseHour(int closeHour) {
    _createMerchantInstance();
    this.merchant.closeHour = closeHour;
    notifyListeners();
  }

  void setMerchantOpenHour(int openHour) {
    _createMerchantInstance();
    this.merchant.openHour = openHour;
    notifyListeners();
  }

  void setMerchantAddressName(String address) {
    _createMerchantInstance();
    this.merchant.locationName = address;
    notifyListeners();
  }

  void setMerchantAddressCoordinate(String coordinate) {
    _createMerchantInstance();
    this.merchant.locationCoordinate = coordinate;
    notifyListeners();
  }

  void setMerchantPhoneNumber(String phoneNumber) {
    _createMerchantInstance();
    this.merchant.phoneNumber = phoneNumber;
    notifyListeners();
  }

  void setMerchantEmail(String email) {
    _createMerchantInstance();
    this.merchant.email = email;
    notifyListeners();
  }

  CameraPosition getCameraPosition() {
    if (merchant == null) return null;
    if (merchant.locationCoordinate == null) return null;
    List coordinate = merchant.locationCoordinate.split(",");
    return CameraPosition(
        target: LatLng(
          double.parse(coordinate[0]),
          double.parse(coordinate[1]),
        ),
        zoom: 15.0);
  }

  void toggleDayOff() {
    _createMerchantInstance();
    this.merchant.dayOff = !this.merchant.dayOff;
    notifyListeners();
  }

  Future selectImageFromGallery(BuildContext context) async {
    print("selecting img from gallery");
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setImageViaFile(imageFile);
  }
}
