import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fresto_apps/apis/google_map_api.dart';
import 'package:fresto_apps/components/food_card.dart';
import 'package:fresto_apps/components/schedule_card.dart';
import 'package:fresto_apps/components/title_and_subtitle_row_text.dart';
import 'package:fresto_apps/models/order.dart';
import 'package:fresto_apps/models_data/client_data/client_data.dart';
import 'package:fresto_apps/models_data/maps_data/map_track_data.dart';
import 'package:fresto_apps/models_data/update_order_data.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  Widget _foodList(UpdateOrderData orderData) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return FoodCardWithQuantity(menuHelper: orderData.order.menus[index]);
      },
      itemCount: orderData.order.menus.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  Widget _orderStatusSection(UpdateOrderData orderData) {
    return InformationCard(
      onPressed: null,
      color: Colors.green,
      icon: Icons.access_time,
      title: 'Order Status',
      content: orderData.order.formattedOrderStatus,
      showViewIcon: false,
    );
  }

  Widget _timeSection(UpdateOrderData orderData) {
    if (orderData.lastOrderStatus == OrderStatus.kCancelled) return SizedBox();
    if (orderData.lastOrderStatus == OrderStatus.kWaitingPayment &&
        orderData.isAccessedByMerchant) return SizedBox();
    return InformationCard(
      color: Colors.blue,
      title: 'Reservation Date',
      content: orderData.order.formattedTime,
      onPressed: () =>
          Fluttertoast.showToast(msg: "Cannot edit date once being submitted"),
    );
  }

  Widget _merchantDetailsSection(
      BuildContext context, UpdateOrderData orderData) {
    if (orderData.isAccessedByMerchant) return SizedBox();
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () => Navigator.pushNamed(context, kMerchantDetailScreenRoute),
          leading: CachedNetworkImage(
            imageUrl: orderData.merchant.imageUrl ?? kDummyMerchantImage,
            fit: BoxFit.fill,
          ),
          title: Text(orderData.merchant.merchantName),
          subtitle: Text(
            orderData.merchant.merchantName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          isThreeLine: true,
        ),
        ListTile(
          title: Text(
            "Address",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(orderData.merchant.locationName),
          trailing: Icon(
            Icons.location_on,
            color: Colors.orange,
          ),
          onTap: () async => await GoogleMapAPI.openExternalMap(
            coordinate: orderData.merchant.locationCoordinate,
          ),
        ),
      ],
    );
  }

  Widget _paymentDetailsSection(UpdateOrderData orderData) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: Column(
        children: <Widget>[
          _foodList(orderData),
          TitleAndSubtitleRowText(
            title: "Product Total",
            description: orderData.getProductTotal(),
            fontSize: 16.0,
          ),
          TitleAndSubtitleRowText(
            title: "Product Tax",
            description: orderData.getTax(),
            fontSize: 16.0,
          ),
          Divider(),
          TitleAndSubtitleRowText(
            title: "Grand Total",
            description: orderData.getGrandTotalString(),
            fontSize: 20,
            titleColor: Colors.blueGrey,
            descriptionColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _paymentMethodSection(UpdateOrderData orderData) {
    if (orderData.lastOrderStatus == OrderStatus.kWaitingMerchantConfirmation)
      return SizedBox();
    if (orderData.lastOrderStatus == OrderStatus.kCancelled) return SizedBox();
    if (orderData.lastOrderStatus == OrderStatus.kWaitingPayment)
      return SizedBox();
    if (orderData.order.paymentMethod == null) return SizedBox();

    return InformationCard(
      icon: Icons.attach_money,
      color: Colors.green,
      title: 'Payment Method',
      content: orderData.order.formattedPaymentMethod,
      showViewIcon: false,
    );
  }

  Widget _downPaymentSection(BuildContext context, UpdateOrderData orderData) {
    if (orderData.lastOrderStatus == OrderStatus.kWaitingMerchantConfirmation)
      return SizedBox();
    if (orderData.lastOrderStatus == OrderStatus.kCancelled) return SizedBox();
    if (orderData.lastOrderStatus == OrderStatus.kWaitingPayment &&
        orderData.isAccessedByMerchant) return SizedBox();

    final List<String> _downPaymentList = [
      kPayHalf,
      kPayFull,
    ];
    Widget payWithMidtrans(BuildContext context) {
      if (orderData.lastOrderStatus != OrderStatus.kWaitingPayment)
        return SizedBox();
      return Container(
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent.withOpacity(0.3),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(6.0),
            topLeft: Radius.circular(6.0),
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(4.0),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.asset(
              "assets/images/midtrans_logo.jpg",
            ),
          ),
          title: Text(
            "Pay with Midtrans",
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Icon(Icons.navigate_next),
          onTap: () async {
            String msg = await orderData.payWithMidTrans(
              client: Provider.of<ClientData>(context).client,
            );
            if (msg != null) Fluttertoast.showToast(msg: msg);
          },
        ),
      );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 8.0, left: 24.0, bottom: 4.0),
            child: Text(
              "Down Payment",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          RadioButtonGroup(
            labels: _downPaymentList,
            picked: orderData.getSubmittedDownPayment(),
            disabled: orderData.lastOrderStatus == OrderStatus.kWaitingPayment
                ? null
                : _downPaymentList,
            activeColor: Colors.green,
            onSelected: orderData.onDownPaymentSelected,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          payWithMidtrans(context),
        ],
      ),
    );
  }

  Widget _buttonBuilder(
      {void Function() onTap, String labelTitle, Color color}) {
    Text labelText = Text(
      labelTitle,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      width: double.infinity,
      alignment: Alignment.center,
      child: InkWell(
        onTap: onTap,
        child: labelText,
      ),
    );
  }

  Widget _completeReservationButton(
      BuildContext context, UpdateOrderData orderData) {
    // Validation
    if (!orderData.isAccessedByMerchant) return SizedBox();
    if (orderData.lastOrderStatus != OrderStatus.kOnProgress) return SizedBox();

    // On Button Pressed Callback
    void onTap() {
      if (!orderData.order.isEligibleToComplete) {
        Fluttertoast.showToast(
            msg: "Cannot Complete Order Before Reservation Time");
        return;
      }
      _onLoading(
        context: context,
        orderData: orderData,
        onProcessCallback: orderData.finishReservation,
      );
    }

    // Button views
    return _buttonBuilder(
      onTap: onTap,
      color:
          orderData.order.isEligibleToComplete ? Colors.green : Colors.blueGrey,
      labelTitle: "Complete Reservation",
    );
  }

  Widget _payReservationButtonSection(
      BuildContext context, UpdateOrderData orderData) {
    // Validation
    if (orderData.lastOrderStatus != OrderStatus.kWaitingPayment)
      return SizedBox();

    // On Button Pressed Callback
    void onTap() {
      _onLoading(
        context: context,
        orderData: orderData,
        onProcessCallback: () async {
          return await orderData.payReservation(
            client: Provider.of<ClientData>(context).client,
          );
        },
      );
    }

    // Button views
    return _buttonBuilder(
      onTap: onTap,
      color: Colors.green,
      labelTitle: "Confirm Reservation",
    );
  }

  Widget _approveButtonSection(
      BuildContext context, UpdateOrderData orderData) {
    // Validation
    if (!orderData.isAccessedByMerchant) return SizedBox();
    if (orderData.lastOrderStatus != OrderStatus.kWaitingMerchantConfirmation)
      return SizedBox();

    // On Button Pressed Callback
    void onTap() {
      _onLoading(
        context: context,
        orderData: orderData,
        onProcessCallback: orderData.approveReservation,
      );
    }

    // Button views
    return _buttonBuilder(
      onTap: onTap,
      color: Colors.green,
      labelTitle: "Approve Reservation",
    );
  }

  Widget _cancelButtonSection(BuildContext context, UpdateOrderData orderData) {
    // Validation
    if (orderData.isAccessedByMerchant) return SizedBox();
    if (orderData.lastOrderStatus == OrderStatus.kCancelled) return SizedBox();

    // On Button Pressed Callback
    void onTap() {
      if (!orderData.order.isEligibleToCancel) {
        Fluttertoast.showToast(msg: "Cannot Cancel Order");
        return;
      }
      _onLoading(
        context: context,
        orderData: orderData,
        onProcessCallback: orderData.cancelReservation,
      );
    }

    // Button viewss
    return _buttonBuilder(
      onTap: onTap,
      color: orderData.order.isEligibleToCancel ? Colors.red : Colors.blueGrey,
      labelTitle: "Cancel Reservation",
    );
  }

  Widget _trackClientButtonSection(
      BuildContext context, UpdateOrderData orderData) {
    if (!orderData.isAccessedByMerchant) return SizedBox();
    // Comment this 2 function below on dev
    if (orderData.order.orderDay != OrderDay.today) return SizedBox();
    if (orderData.order.lastOrderStatus != OrderStatus.kOnProgress)
      return SizedBox();
    bool isAbleToTrack = orderData.client.allowTracking;
    print(orderData.client.allowTracking);
    print("isAbleToTrack $isAbleToTrack");

    void onTap() {
      if (!isAbleToTrack) {
        Fluttertoast.showToast(msg: "Client doesnt allow tracking");
        return;
      }
      print(orderData.client.email);
      Provider.of<MapTrackData>(context).setClientAndMerchant(
        client: orderData.client,
        merchant: orderData.merchant,
      );
      Navigator.pushNamed(context, kMapTrackScreenRoute);
      // push to track screen
    }

    return _buttonBuilder(
      onTap: onTap,
      color: isAbleToTrack ? Colors.green : Colors.grey,
      labelTitle: "Track Client",
    );
  }

  Widget _sectionTitle(BuildContext context, String title,
      {EdgeInsetsGeometry margin, bool setVisibility = true}) {
    if (!setVisibility) return SizedBox();
    return Container(
      margin: margin ?? EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 4.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.title,
      ),
    );
  }

  void _onLoading({
    @required BuildContext context,
    @required UpdateOrderData orderData,
    Future<String> Function() onProcessCallback,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(backgroundColor: Colors.green),
              ),
            ],
          ),
        );
      },
    );
    String result;
    if (onProcessCallback != null) result = await onProcessCallback();
    Navigator.pop(context);
    if (result != null)
      Fluttertoast.showToast(msg: result);
    else {
      Fluttertoast.showToast(msg: "Reservation Updated!");
      Navigator.pop(context);
    }
  }

  Widget _divider() => SizedBox(height: 12.0);

  @override
  Widget build(BuildContext context) {
    return Consumer<UpdateOrderData>(
      builder: (context, orderData, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Reservation Details'),
          ),
          body: Container(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: <Widget>[
                _orderStatusSection(orderData),
                _timeSection(orderData),
                _paymentMethodSection(orderData),
                _sectionTitle(context, "Restaurant Details",
                    setVisibility: !orderData.isAccessedByMerchant),
                _merchantDetailsSection(context, orderData),
                _sectionTitle(context, "Product Details"),
                _paymentDetailsSection(orderData),
                _downPaymentSection(context, orderData),
                _divider(),
                _trackClientButtonSection(context, orderData),
                _completeReservationButton(context, orderData),
                _payReservationButtonSection(context, orderData),
                _approveButtonSection(context, orderData),
                _cancelButtonSection(context, orderData),
                _divider(),
              ],
            ),
          ),
        );
      },
    );
  }
}
