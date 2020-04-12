import 'package:geolocator/geolocator.dart';

class DeviceTrackingAPI {
  static final DeviceTrackingAPI _deviceTrackingAPI =
      DeviceTrackingAPI._internal();
  factory DeviceTrackingAPI() => _deviceTrackingAPI;
  DeviceTrackingAPI._internal();

  Future<String> getDeviceLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (position == null) return null;
    exactLocation = "${position.latitude}, ${position.longitude}";
    return "${position.latitude.toStringAsFixed(3)}, ${position.longitude.toStringAsFixed(3)}";
  }

  // Check if tracking enabled by user
  static bool isTracking = false;
  // Check if startTracking() Instance Wants to be stopped
  static bool endTracking = false;
  static String previousLocation;
  static String exactLocation;
  static String _userUid;
  static int _timeout = 45;
  // Check if one and one only startTracking() Instance is activated
  static bool _isInstanceRunning = false;

  void setTrackStatus(bool trackStatus) {
    isTracking = trackStatus;
  }

  void stopTracking() {
    _userUid = null;
    endTracking = true;
  }

  void startTracking({String userUid}) {
    print("Received userUid => $userUid");
    _userUid = userUid;
    endTracking = false;
  }

  void initTracking() async {
    if (_isInstanceRunning) return;
    _isInstanceRunning = true;
    endTracking = false;
    while (!endTracking) {
      if (isTracking) {
        print("fetching device location...");
        String currentLocation = await getDeviceLocation();
        if (previousLocation == currentLocation) {
          print("same location as before");
        } // next
        else {
          print("Updated device location: $currentLocation");
          previousLocation = currentLocation;
          if (_userUid != null) {
            // TODO: Update to firebase here
          }
        }
      } else
        print("not fetching device location...");
      await Future.delayed(Duration(seconds: _timeout));
    }
    print("device tracking ended...");
    _userUid = null;
    _isInstanceRunning = false;
  }
}
