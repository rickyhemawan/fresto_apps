import 'package:flutter/material.dart';
import 'package:fresto_apps/models_data/admin_data/admin_modify_merchant_data.dart';
import 'package:fresto_apps/models_data/maps_data/map_search_data.dart';
import 'package:fresto_apps/models_data/merchant_data/merchant_data.dart';
import 'package:fresto_apps/utils/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapSearchScreen extends StatefulWidget {
  @override
  _MapSearchScreenState createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  dynamic Function(String, String) addressChangeCallback(UserType userType) {
    if (userType == UserType.admin) {
      return Provider.of<AdminModifyMerchantData>(context).onAddressChanged;
    }
    if (userType == UserType.merchant) {
      return Provider.of<MerchantData>(context).onAddressChanged;
    }
    return null;
  }

  AppBar _appBarSection(BuildContext context, MapSearchData mapSearchData) {
    return AppBar(
      title: Text("Select Address"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () async => await mapSearchData.showPrediction(context),
        ),
      ],
    );
  }

  Widget _mapSection(BuildContext context, MapSearchData mapSearchData) {
    return GoogleMap(
      onMapCreated: mapSearchData.onMapCreated,
      initialCameraPosition: CameraPosition(
        target: mapSearchData.getCameraPosition(),
        zoom: 15.0,
      ),
      markers: mapSearchData.getMarkers(),
      onCameraMove: mapSearchData.updatePosition,
    );
  }

  Widget _buttonSection(
      BuildContext context, MapSearchData mapSearchData, UserType userType) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: MaterialButton(
          minWidth: double.infinity,
          color: Colors.green,
          textColor: Colors.white,
          onPressed: () => mapSearchData.onConfirmAddress(
            context: context,
            onAddressChanged: addressChangeCallback(userType),
          ),
          child: Text("Confirm Address"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loadingScreen(BuildContext context, MapSearchData mapSearchData) {
    if (!mapSearchData.isFetching) return SizedBox();
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white.withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.green,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapSearchData>(
      builder: (context, mapSearchData, child) {
        return Scaffold(
          appBar: _appBarSection(context, mapSearchData),
          body: Stack(
            children: <Widget>[
              _mapSection(context, mapSearchData),
              _buttonSection(context, mapSearchData, mapSearchData.userType),
              _loadingScreen(context, mapSearchData),
            ],
          ),
        );
      },
    );
  }
}
