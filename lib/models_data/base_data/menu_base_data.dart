import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/models/menu.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:image_picker/image_picker.dart';

abstract class MenuBaseData extends ChangeNotifier {
  final kDummyImage =
      CachedNetworkImage(imageUrl: kDummyDefaultImage, fit: BoxFit.cover);

  Menu menu;
  File file;

  void _createMenuInstance() {
    if (this.menu == null) this.menu = Menu(available: true);
  }

  void resetMenuValue() {
    this.menu = null;
    notifyListeners();
  }

  //--------
  // Getters
  //--------

  Widget getMenuImage() {
    if (file != null) {
      return Image.file(file, fit: BoxFit.fill);
    }
    if (menu == null) return kDummyImage;
    if (menu.imageUrl == null) return kDummyImage;
    if (menu.imageUrl != null)
      return CachedNetworkImage(
        imageUrl: menu.imageUrl,
        fit: BoxFit.fill,
      );
    return kDummyImage;
  }

  String getMenuName() {
    if (menu == null) return kDefaultMenuName;
    if (menu.name == null) return kDefaultMenuName;
    return menu.name;
  }

  String getMenuPrice() {
    if (menu == null) return kDefaultPrice;
    if (menu.price == null) return kDefaultPrice;
    return menu.price.toString();
  }

  String getMenuDescription() {
    if (menu == null) return kDefaultDescription;
    if (menu.description == null) return kDefaultDescription;
    return menu.description;
  }

  bool getMenuAvailability() {
    if (menu == null) return false;
    return menu.available;
  }

  //--------
  // Setters
  //--------

  void setMenu(Menu menu) {
    this.menu = menu;
    notifyListeners();
  }

  void setImageViaFile(File file) {
    _createMenuInstance();
    this.menu.imageUrl = null;
    this.file = file;
    notifyListeners();
  }

  void setImageViaURL(String url) {
    _createMenuInstance();
    this.file = null;
    this.menu.imageUrl = url;
    notifyListeners();
  }

  void setMenuName(String name) {
    _createMenuInstance();
    this.menu.name = name;
    notifyListeners();
  }

  void setMenuPrice(String price) {
    double realPrice;
    try {
      price = price.replaceAll(",", "");
      realPrice = double.parse(price);
    } catch (e) {
      Fluttertoast.showToast(msg: price);
      return;
    }
    _createMenuInstance();
    this.menu.price = realPrice;
    notifyListeners();
  }

  void setMenuDescription(String description) {
    _createMenuInstance();
    this.menu.description = description;
    notifyListeners();
  }

  void toggleAvailability() {
    _createMenuInstance();
    this.menu.available = !this.menu.available;
    notifyListeners();
  }

  Future selectImageFromGallery(BuildContext context) async {
    print("selecting img from gallery");
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setImageViaFile(imageFile);
  }
}
