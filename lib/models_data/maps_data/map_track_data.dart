import 'dart:async';
import 'dart:math' as Math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vector_math/vector_math.dart' as VectorMath;

const kMerchantMarker = "MerchantMarker";
const kClientMarker = "ClientMarker";
const kMerchantCircle = "MerchantCircle";

class MapTrackData extends ChangeNotifier {
  // Google Map Properties
  Completer<GoogleMapController> _controller;
  LatLng _cameraPosition;
  Set<Marker> _markers;
  Set<Circle> _circles;
  Marker _merchantMarker;
  Marker _clientMarker;
  Circle _merchantCircle;

  // Screen Properties
  bool isFetching = false;

  MapTrackData() {
    mapInit();
  }

  void mapInit() {
    _controller = Completer();
    _cameraPosition = LatLng(-8.507890, 115.264532);
    _merchantMarker = Marker(
      draggable: false,
      markerId: MarkerId(kMerchantMarker),
      position: _cameraPosition,
    );
    _clientMarker = Marker(
      draggable: false,
      markerId: MarkerId(kClientMarker),
      position: LatLng(-8.645105, 115.255725),
    );
    _merchantCircle = Circle(
      circleId: CircleId(kMerchantCircle),
      radius: 4000,
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

  void onMapCreated(GoogleMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

  void updatePosition(CameraPosition position) {
    setCameraPosition(position.target);
  }

  void setMarker(Marker marker) {
    _markers = Set<Marker>.of(<Marker>[marker]);
    notifyListeners();
  }

  void setCameraPosition(LatLng position) {
    _cameraPosition = position;
    notifyListeners();
  }

  LatLng get cameraPosition => this._cameraPosition;
  Set<Marker> get markers => this._markers;
  Set<Circle> get circles => this._circles;

  void toggleIsFetching() {
    this.isFetching = !this.isFetching;
    notifyListeners();
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
}
