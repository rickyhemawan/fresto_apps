// Class for Fetch from payment info
class PaymentInfo {
  double totalPaid;
  String currency;
  String orderId;
  String paymentType;
  String transactionStatus;
  String fraudStatus;
  String transactionId;

  PaymentInfo.fromJson(Map<String, dynamic> data) {
    this.totalPaid = double.parse(data["gross_amount"]);
    this.currency = data["currency"];
    this.orderId = data["order_id"];
    this.paymentType = data["payment_type"];
    this.transactionStatus = data["transaction_status"];
    this.fraudStatus = data["fraud_status"];
    this.transactionId = data["transaction_id"];
  }

  @override
  String toString() {
    return 'PaymentInfo{totalPaid: $totalPaid, currency: $currency, orderId: $orderId, paymentType: $paymentType, transactionStatus: $transactionStatus, fraudStatus: $fraudStatus}';
  }
}
