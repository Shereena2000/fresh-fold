import 'package:flutter/material.dart';
import 'package:fresh_fold/Features/pick_up_screen/view_model/location_view_model.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../Settings/utils/p_colors.dart';

class MapLocationPickerScreen extends StatefulWidget {
  const MapLocationPickerScreen({Key? key}) : super(key: key);

  @override
  State<MapLocationPickerScreen> createState() => _MapLocationPickerScreenState();
}

class _MapLocationPickerScreenState extends State<MapLocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = LatLng(10.0261, 76.3125); // Kerala default
  LatLng _centerPosition = LatLng(10.0261, 76.3125);
  String _currentAddress = 'Loading...';
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() => _isLoading = true);

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError('Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError('Location permissions are permanently denied');
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentPosition = LatLng(position.latitude, position.longitude);
      _centerPosition = _currentPosition;

      // Get address
      await _getAddressFromLatLng(_currentPosition);

      // Move camera to current location
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition, zoom: 15),
        ),
      );

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error getting location: $e');
    }
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = 
              '${place.street ?? ''}, ${place.subLocality ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''} ${place.postalCode ?? ''}';
        });
      }
    } catch (e) {
      print('Error getting address: $e');
      setState(() => _currentAddress = 'Unable to get address');
    }
  }

  void _onCameraMove(CameraPosition position) {
    _centerPosition = position.target;
  }

  void _onCameraIdle() {
    _getAddressFromLatLng(_centerPosition);
  }

  void _confirmLocation() {
    final locationProvider = Provider.of<LocationViewModel>(context, listen: false);
    locationProvider.setLocation(_centerPosition, _currentAddress);
    Navigator.pop(context, {
      'location': _centerPosition,
      'address': _currentAddress,
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Center Pin
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_pin,
                  size: 50,
                  color: PColors.primaryColor,
                ),
                SizedBox(height: 50),
              ],
            ),
          ),

          // Top Bar with Search
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios, color: PColors.primaryColor),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Expanded(
                            child: Text(
                              'Select Pickup Location',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: PColors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Search Bar (Optional - for future implementation)
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    //   child: TextField(
                    //     controller: _searchController,
                    //     decoration: InputDecoration(
                    //       hintText: 'Search location...',
                    //       prefixIcon: Icon(Icons.search),
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Card with Address
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Address Section
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: PColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.location_on,
                              color: PColors.primaryColor,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pickup Location',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: PColors.darkGray.withOpacity(0.6),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _currentAddress,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: PColors.primaryColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),

                      // Confirm Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _confirmLocation,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Confirm Location',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Current Location Button
          Positioned(
            right: 16,
            bottom: 200,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              backgroundColor: Colors.white,
              elevation: 4,
              child: Icon(Icons.my_location, color: PColors.primaryColor),
            ),
          ),

          // Loading Overlay
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: Center(
                child: CircularProgressIndicator(
                  color: PColors.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }
}