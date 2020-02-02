import 'package:fresto_apps/apis/merchant_api.dart';
import 'package:fresto_apps/apis/storage_api.dart';
import 'package:fresto_apps/models/menu.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/models_data/base_data/menu_base_data.dart';
import 'package:fresto_apps/utils/constants.dart';

class MerchantModifyMenuData extends MenuBaseData {
  bool isLoading = false;
  Menu defaultMenu;

  @override
  void resetMenuValue() {
    super.resetMenuValue();
    file = null;
    notifyListeners();
  }

  void selectMenu(Menu menu) {
    setMenu(menu);
    this.defaultMenu = Menu.fromJson(menu.toJson());
    file = null;
    notifyListeners();
    print("compare menu ${isSameAsPrevious()}");
  }

  void printDifference(Merchant merchant) {
    print(merchant.menus);
    for (int i = 0; i < merchant.menus.length; i++) {
      if (merchant.menus[i] == defaultMenu) {
        merchant.menus[i] = this.menu;
      }
    }
    print(merchant.menus);
  }

  String _addMenuValidator() {
    if (this.menu == null) return "Menu is NULL";
    if (this.menu.name == null) return kNullMenuName;
    if (this.menu.price == null) return kNullPrice;
    return null;
  }

  Future<String> updateMenu(Merchant merchant) async {
    if (_addMenuValidator() != null) return _addMenuValidator();
    if (isSameAsPrevious()) return "There are no changes to be updated!";
    if (this.file != null) {
      String imgUrl = await StorageAPI.uploadMenuImage(
        file: this.file,
        merchantName: merchant.merchantName,
        menuName: this.menu.name,
      );
      if (imgUrl == null) return kErrorFailedUploadImage;
      this.menu.imageUrl = imgUrl;
    }
    for (int i = 0; i < merchant.menus.length; i++) {
      if (merchant.menus[i] == defaultMenu) {
        merchant.menus[i] = this.menu;
      }
    }
    String msg = await MerchantAPI.addMenusToMerchant(
        merchant: merchant, menus: merchant.menus);
    if (msg != null) return msg;
    return null;
  }

  Future<String> addMenu(Merchant merchant) async {
    if (_addMenuValidator() != null) return _addMenuValidator();

    if (this.file != null) {
      String imgUrl = await StorageAPI.uploadMenuImage(
        file: this.file,
        merchantName: merchant.merchantName,
        menuName: this.menu.name,
      );
      if (imgUrl == null) return kErrorFailedUploadImage;
      this.menu.imageUrl = imgUrl;
    }

    Merchant updatedMerchant = Merchant.fromJson(merchant.toJson());
    updatedMerchant.addMenu(this.menu);
    print("merchant => $merchant");
    print("updated => $updatedMerchant");
    String msg = await MerchantAPI.addMenusToMerchant(
        merchant: merchant, menus: updatedMerchant.menus);
    if (msg != null) return msg;
    return null;
  }

  void setLoading(bool value) {
    this.isLoading = value;
    notifyListeners();
  }

  bool isSameAsPrevious() => this.menu == this.defaultMenu;
}
