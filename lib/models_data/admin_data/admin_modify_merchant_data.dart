import 'package:firebase_auth/firebase_auth.dart';
import 'package:fresto_apps/apis/merchant_api.dart';
import 'package:fresto_apps/apis/storage_api.dart';
import 'package:fresto_apps/models_data/base_data/merchant_base_data.dart';
import 'package:fresto_apps/utils/constants.dart';

class AdminModifyMerchantData extends MerchantBaseData {
  bool isPasswordHidden = true;
  bool isLoading = false;
  String password;

  AdminModifyMerchantData();

  //--------------------
  // Merchant Properties
  //--------------------

  void resetAllValues() {
    this.merchant = null;
    this.file = null;
    this.isPasswordHidden = true;
    this.isLoading = false;
    this.file = null;
    notifyListeners();
  }

  //---------------------------------
  // UI Callbacks for create merchant
  //---------------------------------

  // Create Merchant validation
  Future<String> _validatesAndCreateMerchant() async {
    // Auth Validator
    if (merchant == null) return kErrorEmptyEmail;
    if (merchant.email.isEmpty) return kErrorEmptyEmail;

    bool emailValidator = RegExp(kEmailRegex).hasMatch(merchant.email);
    if (!emailValidator) return kErrorNotValidEmailAddress;
    if (password.isEmpty) return kErrorEmptyPassword;

    if (merchantValidation() != null) return merchantValidation();

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

  // Create Merchant Submit Changes
  Future<String> createMerchant() async {
    String result = await _validatesAndCreateMerchant();
    print("create Merchant Result => $result");
    isLoading = false;
    notifyListeners();

    if (result != null) {
      return result;
    }

    final successMsg =
        "${merchant.merchantName} is successfully added to Database";
    resetAllValues();
    return successMsg;
  }

  //---------------------------------
  // UI Callbacks for update merchant
  //---------------------------------

  // Update Merchant Validation
  Future<String> _validatesAndModifyMerchant() async {
    if (merchantValidation() != null) return merchantValidation();

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

    return await MerchantAPI.updateMerchantFromDatabase(
      updatedMerchant: this.merchant,
      firebaseUser: await FirebaseAuth.instance.currentUser(),
    );
  }

  // Update Merchant Submit Changes
  Future<String> updateMerchant() async {
    String result = await _validatesAndModifyMerchant();
    print("create Merchant Result => $result");
    isLoading = false;
    notifyListeners();

    if (result != null) {
      return result;
    }

    final successMsg =
        "${merchant.merchantName} is successfully added to Database";
    resetAllValues();
    return successMsg;
  }

  //--------
  // Setters
  //--------

  void setMerchantPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void changePasswordVisibility() {
    isPasswordHidden = !isPasswordHidden;
    notifyListeners();
  }
}
