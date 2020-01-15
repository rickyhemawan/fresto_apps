import 'package:fresto_apps/apis/merchant_api.dart';
import 'package:fresto_apps/models/menu.dart';
import 'package:fresto_apps/models/merchant.dart';

void main() async {
  print("main executed");
  Merchant merchant = Merchant(email: "new@merchant.com", menus: [
    Menu(
        name: "MENU1",
        price: 1000.0,
        available: true,
        description: "This is MENU1",
        imageUrl: ""),
    Menu(
        name: "MENU2",
        price: 2000.0,
        available: true,
        description: "This is MENU2",
        imageUrl: ""),
    Menu(
        name: "MENU3",
        price: 3000.0,
        available: true,
        description: "This is MENU3",
        imageUrl: ""),
  ]);
  String password = "password1234";
  String createMerchant = await MerchantAPI.addNewMerchantToDatabase(
    merchant: merchant,
    password: password,
    confirmPassword: password,
  );
  print(createMerchant ?? "success adding merchant");
}
