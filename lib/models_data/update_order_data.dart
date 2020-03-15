import 'package:flutter/cupertino.dart';
import 'package:fresto_apps/apis/order_api.dart';
import 'package:fresto_apps/models/client.dart';
import 'package:fresto_apps/models/order.dart';
import 'package:fresto_apps/models_data/base_data/order_base_data.dart';
import 'package:fresto_apps/utils/constants.dart';

class UpdateOrderData extends OrderBaseData {
  bool isLoading = false;
  bool isAccessedByMerchant = false;
  String selectedDownPayment;
  UpdateOrderData();

  void setLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  Future<String> cancelReservation() async {
    return await OrderAPI.updateOrderStatus(
      status: OrderStatus.kCancelled,
      order: this.order,
    );
  }

  Future<String> approveReservation() async {
    return await OrderAPI.updateOrderStatus(
      status: OrderStatus.kWaitingPayment,
      order: this.order,
    );
  }

  Future<String> payReservation({@required Client client}) async {
    if (this.selectedDownPayment == null)
      return "Please Select a Down Payment first";
    // TODO make this flow useful
    // TODO # 1
//    return await MidtransAPI.invokePayment(order: this.order, client: client);
    // TODO # 2
//    try {
//      print(
//          await MidtransAPI.getPaymentInfo(order: this.order, client: client));
//      return null;
//    } catch (e) {
//      return e.toString();
//    }
    // TODO # 3
//    String errorMessage;
//    errorMessage = await OrderAPI.updateOrderStatus(
//      status: OrderStatus.kOnProgress,
//      order: this.order,
//    );
//    if (errorMessage != null) return errorMessage;
//    // TODO update payment gateway integration, then update the status based on completion
//    // TODO comment code below if necessary for payment gateway
//
//    errorMessage = await OrderAPI.updatePaymentStatus(
//        status: selectedDownPayment, order: this.order);
//    return errorMessage;
  }

  Future<String> finishReservation() async {
    return await OrderAPI.updateOrderStatus(
      status: OrderStatus.kDone,
      order: this.order,
    );
  }

  void setAccessedByMerchant(bool ans) {
    this.isAccessedByMerchant = ans;
    notifyListeners();
  }

  void onDownPaymentSelected(String selected) {
    if (selected == kPayFull)
      this.selectedDownPayment = PaymentStatus.kPaidFull;
    if (selected == kPayHalf)
      this.selectedDownPayment = PaymentStatus.kPaidHalf;
    notifyListeners();
  }

  String getSubmittedDownPayment() {
    if (this.order == null) return null;
    if (this.order.paymentStatus == null) return null;
    if (this.order.paymentStatus == PaymentStatus.kPaidHalf) return kPayHalf;
    if (this.order.paymentStatus == PaymentStatus.kPaidFull) return kPayFull;
    return null;
  }

  String get lastOrderStatus => this.order.lastOrderStatus;
}
