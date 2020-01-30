import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fresto_apps/apis/merchant_api.dart';
import 'package:fresto_apps/apis/storage_api.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:image_picker/image_picker.dart';

class AdminModifyMerchantData extends ChangeNotifier {
  final kDummyImage =
      CachedNetworkImage(imageUrl: kDummyDefaultImage, fit: BoxFit.cover);

  bool isPasswordHidden = true;
  bool isLoading = false;
  String password;

  Merchant merchant;
  File file;

  AdminModifyMerchantData();

  //--------------------
  // Merchant Properties
  //--------------------

  void setMerchant({@required Merchant merchant}) {
    this.merchant = merchant;
    notifyListeners();
  }

  void _createMerchantInstance() {
    if (merchant == null) merchant = Merchant(dayOff: false, menus: []);
  }

  void resetMerchantValue() {
    merchant = null;
    notifyListeners();
  }

  void onAddressChanged(String addressName, String coordinate) {
    setMerchantAddressCoordinate(coordinate);
    setMerchantAddressName(addressName);
  }
  //--------------
  // UI Callbacks
  //--------------

  Future<String> _validatesAndSubmitMerchant() async {
    // Auth Validator
    if (merchant == null) return kErrorEmptyEmail;
    if (merchant.email.isEmpty) return kErrorEmptyEmail;

    bool emailValidator = RegExp(kEmailRegex).hasMatch(merchant.email);
    if (!emailValidator) return kErrorNotValidEmailAddress;
    if (password.isEmpty) return kErrorEmptyPassword;

    // Merchant validator
    if (merchant.merchantName == null) return kNullMerchantName;
    if (merchant.openHour == null) return kNullOperationHour;
    if (merchant.closeHour == null) return kNullOperationHour;
    if (merchant.locationName == null) return kNullMerchantAddress;
    if (merchant.locationCoordinate == null) return kNullMerchantAddress;

    isLoading = true;
    notifyListeners();

    if (file != null) {
      String imgUrl = await StorageAPI.uploadMerchantImage(
        merchantName: this.merchant.merchantName,
        file: this.file,
      );
      if (imgUrl == null) return kErrorFailedUploadImage;
      this.merchant.imageUrl = imgUrl;
    }

    return await MerchantAPI.addNewMerchantToDatabase(
      merchant: this.merchant,
      password: this.password,
      confirmPassword: this.password,
    );
  }

  Future<String> submitChanges(BuildContext context) async {
    String result = await _validatesAndSubmitMerchant();
    print("submit Changes Result => $result");
    isLoading = false;
    notifyListeners();

    if (result != null) {
      return result;
    }

    final successMsg =
        "${merchant.merchantName} is successfully added to Database";
    setMerchant(merchant: null);
    return successMsg;
  }

  Future selectImageFromGallery(BuildContext context) async {
    print("selecting img from gallery");
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setImageViaFile(imageFile);
  }

  void changePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    notifyListeners();
  }

  //--------
  // Getters
  //--------

  Widget getMerchantImage() {
    if (file != null) return Image.file(file, fit: BoxFit.cover);
    if (merchant == null) return kDummyImage;
    if (merchant.imageUrl == null) return kDummyImage;
    if (merchant.imageUrl != null)
      return CachedNetworkImage(imageUrl: merchant.imageUrl);
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

  void setMerchantPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void toggleDayOff() {
    _createMerchantInstance();
    this.merchant.dayOff = !this.merchant.dayOff;
    notifyListeners();
  }
}
