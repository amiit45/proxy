import 'package:location/location.dart';
import 'dart:async';

class LocationService {
  final Location _location = Location();
  LocationData? _currentLocation;
  Timer? _locationUpdateTimer;

  LocationData? get currentLocation => _currentLocation;

  Future<void> initialize() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location service is enabled
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check if permission is granted
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get current location
    _currentLocation = await _location.getLocation();

    // Start location updates
    _locationUpdateTimer = Timer.periodic(Duration(minutes: 1), (_) async {
      _currentLocation = await _location.getLocation();
    });
  }

  Future<LocationData?> getCurrentLocation() async {
    if (_currentLocation == null) {
      _currentLocation = await _location.getLocation();
    }
    return _currentLocation;
  }

  void dispose() {
    _locationUpdateTimer?.cancel();
  }
}