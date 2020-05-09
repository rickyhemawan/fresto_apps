import 'dart:async';
import 'dart:math' as Math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fresto_apps/models/client.dart';
import 'package:fresto_apps/models/merchant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_math/vector_math.dart' as VectorMath;

const kMerchantMarker = "MerchantMarker";
const kClientMarker = "ClientMarker";
const kMerchantCircle = "MerchantCircle";
const kCircleRadius = 4000.0;

//Dev Purpose
const kDummyLatLng1 = LatLng(-8.507890, 115.264532);
const kDummyLatLng2 = LatLng(-8.645105, 115.255725);

class MapTrackData extends ChangeNotifier {
  // Google Map Properties
  Completer<GoogleMapController> _controller;
  LatLng _cameraPosition;
  Set<Marker> _markers;
  Set<Circle> _circles;
  Marker _merchantMarker;
  Marker _clientMarker;
  Circle _merchantCircle;
  BitmapDescriptor _merchantIcon;

  // Business Properties
  Merchant _merchant;
  Client _client;

  // Screen Properties
  bool isFetching = false;

  MapTrackData() {
    mapInit();
  }

  void mapInit() {
    _controller = Completer();
    _cameraPosition = kDummyLatLng1;
    _merchantMarker = Marker(
      draggable: false,
      markerId: MarkerId(kMerchantMarker),
      position: _cameraPosition,
    );
    _clientMarker = Marker(
      draggable: false,
      markerId: MarkerId(kClientMarker),
      position: kDummyLatLng2,
    );
    _merchantCircle = Circle(
      circleId: CircleId(kMerchantCircle),
      radius: kCircleRadius,
      center: _merchantMarker.position,
      visible: true,
      fillColor: Colors.blue.withOpacity(0.3),
      strokeColor: Colors.blue,
    );
    _markers = Set<Marker>.of(<Marker>[_merchantMarker, _clientMarker]);
    _circles = Set<Circle>.of(<Circle>[_merchantCircle]);
  }

  CameraPosition initialCameraPosition() {
    return CameraPosition(
      target:
          _getMiddlePosition(_merchantMarker.position, _clientMarker.position),
      zoom: 11.0,
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void onMapCreated(GoogleMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  void updatePosition(CameraPosition position) {
    setCameraPosition(position.target);
  }

  void setCameraPosition(LatLng position) {
    _cameraPosition = position;
    notifyListeners();
  }

  void setClientPosition(LatLng position) {
    _client.locationCoordinate = "${position.latitude}, ${position.longitude}";
    _clientMarker = Marker(
      draggable: false,
      markerId: MarkerId(kClientMarker),
      position: position,
    );
    _markers = Set<Marker>.of(<Marker>[_merchantMarker, _clientMarker]);
    notifyListeners();
  }

  Future<void> updateMerchantPosition() async {
    this.isFetching = true;
    notifyListeners();
    _merchantIcon = BitmapDescriptor.fromBytes(
        await getBytesFromAsset("assets/images/merchantIcon.png", 100));
    _merchantMarker = Marker(
      draggable: false,
      markerId: MarkerId(kMerchantMarker),
      position: this._merchant.position,
      icon: _merchantIcon,
    );
    _merchantCircle = Circle(
      circleId: CircleId(kMerchantCircle),
      radius: kCircleRadius,
      center: _merchantMarker.position,
      visible: true,
      fillColor: Colors.blue.withOpacity(0.3),
      strokeColor: Colors.blue,
    );
    _circles = Set<Circle>.of(<Circle>[_merchantCircle]);
    this.isFetching = false;
  }

  void setClientAndMerchant(
      {@required Client client, @required Merchant merchant}) async {
    if (client == null) return;
    if (merchant == null) return;

    this._merchant = merchant;
    this._client = client;
    notifyListeners();
    await updateMerchantPosition();
    setClientPosition(client.position);
  }

  LatLng get cameraPosition => this._cameraPosition;
  Set<Marker> get markers => this._markers;
  Set<Circle> get circles => this._circles;
  Client get client => this._client;

  Client clientFromSnapshot(List<DocumentSnapshot> documents) {
    return Client.fromJson(documents[0].data);
  }

  void toggleIsFetching() {
    this.isFetching = !this.isFetching;
    notifyListeners();
  }

  bool checkClientInRadius(LatLng startPosition, LatLng endPosition) {
    // Split the latitude and longitude
    double lat1 = startPosition.latitude;
    double lon1 = startPosition.longitude;
    double lat2 = endPosition.latitude;
    double lon2 = endPosition.longitude;

    double theta = lon1 - lon2;
    double dist = Math.sin(VectorMath.radians(lat1)) *
            Math.sin(VectorMath.radians(lat2)) +
        Math.cos(VectorMath.radians(lat1)) *
            Math.cos(VectorMath.radians(lat2)) *
            Math.cos(VectorMath.radians(theta));
    dist = Math.acos(dist);
    dist = VectorMath.degrees(dist);
    dist = dist * 60 * 1.1515 * 1.609344 * 1000;
    print("Difference is ${dist.toStringAsFixed(2)} meters");
    return kCircleRadius < dist;
  }

  LatLng _getMiddlePosition(LatLng startPosition, LatLng endPosition) {
    // Split the latitude and longitude
    double lat1 = startPosition.latitude;
    double lon1 = startPosition.longitude;
    double lat2 = endPosition.latitude;
    double lon2 = endPosition.longitude;

    double dLon = VectorMath.radians(lon2 - lon1);

    // convert to radians
    lat1 = VectorMath.radians(lat1);
    lat2 = VectorMath.radians(lat2);
    lon1 = VectorMath.radians(lon1);

    double bx = Math.cos(lat2) * Math.cos(dLon);
    double by = Math.cos(lat2) * Math.sin(dLon);
    double lat3 = Math.atan2(Math.sin(lat1) + Math.sin(lat2),
        Math.sqrt((Math.cos(lat1) + bx) * (Math.cos(lat1) + bx) + by * by));
    double lon3 = lon1 + Math.atan2(by, Math.cos(lat1) + bx);

    return LatLng(VectorMath.degrees(lat3), VectorMath.degrees(lon3));
  }

  // Dev Purpose
  void onButtonPressed1() {
    checkClientInRadius(_merchantMarker.position, _clientMarker.position);
  }
}
