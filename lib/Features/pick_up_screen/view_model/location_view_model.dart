import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationViewModel extends ChangeNotifier {
  LatLng? _selectedLocation;
  String? _selectedAddress;
  bool _isLoading = false;

  LatLng? get selectedLocation => _selectedLocation;
  String? get selectedAddress => _selectedAddress;
  bool get isLoading => _isLoading;

  void setLocation(LatLng location, String address) {
    _selectedLocation = location;
    _selectedAddress = address;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}