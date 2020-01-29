import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fresto_apps/apis/google_map_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

const currentLocationMarker = "CurrentLocationMarker";

class MapSearchData extends ChangeNotifier {
  LatLng _cameraPosition;
  Set<Marker> _markers;
  Marker _marker;
  Completer<GoogleMapController> _controller;
  String markerDescription = "Merchant Location";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: GoogleMapAPI.getApiKey());
  String address = "";
  bool isFetching = false;

  MapSearchData() {
    _controller = Completer();
    _cameraPosition = LatLng(-8.507890, 115.264532);
    _marker = Marker(
      draggable: true,
      markerId: MarkerId(currentLocationMarker),
      position: _cameraPosition,
      infoWindow: InfoWindow(title: markerDescription),
    );
    _markers = Set<Marker>.of(<Marker>[_marker]);
  }

  LatLng _locationToPosition(Location location) =>
      LatLng(location.lat, location.lng);
  String _positionToString(LatLng position) =>
      "${position.latitude},${position.longitude}";

  //-------------------
  // Screens Callbacks
  //-------------------

  void onMapCreated(GoogleMapController controller) =>
      _controller.complete(controller);

  void updatePosition(CameraPosition position) {
    setCameraPosition(position.target);
    setMarker(_marker.copyWith(positionParam: _cameraPosition));
  }

  Future showPrediction(BuildContext context) async {
    address = "";
    await setPrediction(
      await PlacesAutocomplete.show(
        context: context,
        apiKey: GoogleMapAPI.getApiKey(),
        components: [
          Component(Component.country, "id"),
          Component(Component.country, "my"),
        ],
      ),
    );
  }

  void onConfirmAddress(
      {@required
          BuildContext context,
      @required
          Function(String addressName, String addressCoordinate)
              onAddressChanged}) async {
    setLoadingStatus(true);
    String coordinate = _positionToString(_marker.position);
    if (address == "")
      address = await GoogleMapAPI.getAddress(coordinate: coordinate);
    onAddressChanged(this.address, coordinate);
    setLoadingStatus(false);
    Navigator.pop(context);
  }

  //---------
  // Setters
  //---------

  Future<Null> setPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      Location location = detail.result.geometry.location;
      setCameraPosition(_locationToPosition(location));
      setMarker(_marker.copyWith(positionParam: _locationToPosition(location)));
      await updateCameraAccordingToPosition();
      print("p.description = ${p.description}");
      address = p.description;
    }
  }

  Future<void> updateCameraAccordingToPosition() async {
    final GoogleMapController mapController = await _controller.future;
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _cameraPosition,
      zoom: 15.0,
    )));
  }

  void setMarker(Marker marker) {
    _markers = Set<Marker>.of(<Marker>[marker]);
    notifyListeners();
  }

  void setCameraPosition(LatLng position) {
    _cameraPosition = position;
    notifyListeners();
  }

  void setLoadingStatus(bool b) {
    this.isFetching = b;
    notifyListeners();
  }

  //---------
  // Getters
  //---------

  Set<Marker> getMarkers() => _markers;
  Completer<GoogleMapController> getMapController() => _controller;
  LatLng getCameraPosition() => _cameraPosition;
}
