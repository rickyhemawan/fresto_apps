import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/utils/constants.dart';

class AdminModifyMerchantData extends ChangeNotifier {
  final kDummyImage =
      CachedNetworkImage(imageUrl: kDummyDefaultImage, fit: BoxFit.cover);

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
    if (merchant == null) merchant = Merchant();
  }

  void resetMerchantValue() {
    merchant = null;
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
    return "Open from.."; // TODO change this
  }

  String getMerchantDescription() {
    if (merchant == null) return kDefaultDescription;
    if (merchant.description == null) return kDefaultDescription;
    return merchant.description;
  }

  //--------
  // Setters
  //--------

  void setImageViaFile({@required File file}) {
    _createMerchantInstance();
    this.merchant.imageUrl = null;
    this.file = file;
    notifyListeners();
  }

  void setImageViaURL({@required String url}) {
    _createMerchantInstance();
    this.file = null;
    this.merchant.imageUrl = url;
    notifyListeners();
  }

  void setMerchantName({@required String name}) {
    _createMerchantInstance();
    this.merchant.merchantName = name;
    notifyListeners();
  }

  void setMerchantDescription({@required String description}) {
    _createMerchantInstance();
    this.merchant.description = description;
    notifyListeners();
  }
}
