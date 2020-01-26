import 'package:fresto_apps/apis/merchant_api.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:fresto_apps/utils/restaurant_file_reader.dart';

class PopulateFirebase {
  static final _password = "fresto1234";

  // do not call this function unless wants to repopulate database
  static void populateMerchants() async {
    List<Merchant> merchants =
        await RestaurantFileReader().getMerchantsFromCSV();
    for (int i = 0; i < merchants.length; i++) {
      String result = await MerchantAPI.addNewMerchantToDatabase(
        merchant: merchants[i],
        password: _password,
        confirmPassword: _password,
      );
      if (result == null) {
        print("${merchants[i].merchantName} added!");
      } else {
        print(result);
      }
    }
  }
}
