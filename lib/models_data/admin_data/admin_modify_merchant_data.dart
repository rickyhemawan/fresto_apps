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

  void resetMerchantValue() {
    merchant = null;
  }

  Widget getMerchantImage() {
    if (file != null) return Image.file(file, fit: BoxFit.cover);
    if (merchant == null) return kDummyImage;
    if (merchant.imageUrl == null) return kDummyImage;
    if (merchant.imageUrl != null)
      return CachedNetworkImage(imageUrl: merchant.imageUrl);
    return kDummyImage;
  }

  void uploadImage({File file}) {
    this.file = file;
    notifyListeners();
  }
}
