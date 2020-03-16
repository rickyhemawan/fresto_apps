import 'package:flutter/cupertino.dart';
import 'package:fresto_apps/apis/midtrans_api.dart';
import 'package:fresto_apps/apis/order_api.dart';
import 'package:fresto_apps/models/client.dart';
import 'package:fresto_apps/models/helper/payment_info.dart';
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

  String validateDownPayment() {
    if (this.selectedDownPayment == null)
      return "Please Select a Down Payment first";
    return null;
  }

  Future<String> cancelReservation() async {
    return await OrderAPI.updateOrderStatusAndPayment(
      status: OrderStatus.kCancelled,
      order: this.order,
    );
  }

  Future<String> approveReservation() async {
    return await OrderAPI.updateOrderStatusAndPayment(
      status: OrderStatus.kWaitingPayment,
      order: this.order,
    );
  }

  Future<String> payWithMidTrans({@required Client client}) async {
    if (validateDownPayment() != null) return validateDownPayment();
    return await MidtransAPI.invokePayment(client: client, order: this.order);
  }

  Future<String> payReservation({@required Client client}) async {
    if (validateDownPayment() != null) return validateDownPayment();
    PaymentInfo paymentInfo;
    // Get and update Payment Status ---------
    try {
      paymentInfo = await MidtransAPI.getPaymentInfo(order: this.order);
    } catch (e) {
      print("paymentReservation => " + e.toString());
      return kNullPaymentInformation;
    }
    if (paymentInfo == null) return kNullPaymentInformation;

    // Change order status ------------------
    return await OrderAPI.updateOrderStatusAndPayment(
      status: OrderStatus.kOnProgress,
      order: this.order,
      paymentStatus: selectedDownPayment,
      paymentInfo: paymentInfo,
    );
  }

  Future<String> finishReservation() async {
    return await OrderAPI.updateOrderStatusAndPayment(
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
