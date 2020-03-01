import 'package:fresto_apps/models_data/base_data/order_base_data.dart';

class ClientUpdateOrderData extends OrderBaseData {
  bool isLoading = false;
  ClientUpdateOrderData();

  void setLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }
}