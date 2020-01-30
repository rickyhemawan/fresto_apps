import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as pathLib;

class StorageAPI {
  static String setMerchantSavePath(
      {@required String merchantName,
      @required String filePath,
      @required String objectType}) {
    return "$objectType/$merchantName/$filePath";
  }

  static Future<String> uploadMerchantImage(
      {String merchantName, File file}) async {
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference = firebaseStorage.ref().child(
          setMerchantSavePath(
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
      print(e);
      return null;
    }
  }
}
