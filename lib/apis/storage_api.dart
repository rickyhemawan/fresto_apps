import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as pathLib;

class StorageAPI {
  static String _setMerchantSavePath(
      {@required String merchantName,
      @required String filePath,
      @required String objectType}) {
    return "$objectType/$merchantName/$filePath";
  }

  static String _setMenuSavePath(
      {@required String merchantName,
      @required String objectType,
      @required String menuName,
      @required String filePath}) {
    return "$objectType/$merchantName/$menuName/$filePath";
  }

  // Return URL if succeed, otherwise return null
  static Future<String> uploadMerchantImage(
      {String merchantName, File file}) async {
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference = firebaseStorage.ref().child(
          _setMerchantSavePath(
            merchantName: merchantName,
            filePath: pathLib.basename(file.path),
            objectType: "Merchant",
          ),
        );
    StorageUploadTask uploadTask = storageReference.putFile(file);
    try {
      await uploadTask.onComplete;
      print("File Uploaded");
      var s = await storageReference.getDownloadURL();
      return s.toString();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // return URL if succeed. otherwise return null
  static Future<String> uploadMenuImage(
      {String merchantName, File file, String menuName}) async {
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
          _setMenuSavePath(
            merchantName: merchantName,
            objectType: "Merchant",
            menuName: menuName,
            filePath: pathLib.basename(file.path),
          ),
        );
    StorageUploadTask uploadTask = storageReference.putFile(file);
    try {
      await uploadTask.onComplete;
      print("File Uploaded!");
      var s = await storageReference.getDownloadURL();
      return s.toString();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
