import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class SimpleMapScreen extends StatefulWidget {
  const SimpleMapScreen({super.key});

  @override
  _SimpleMapScreenState createState() => _SimpleMapScreenState();
}

class _SimpleMapScreenState extends State<SimpleMapScreen> {
  late GoogleMapController _mapController;
  bool _hasLocationPermission = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      setState(() {
        _hasLocationPermission = true;
      });
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // You can show a dialog or redirect the user to the app settings
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Map Test'),
      ),
      body: _hasLocationPermission
          ? GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194), // Example coordinates (San Francisco)
          zoom: 10,
        ),
        markers: {
          Marker(
            markerId: MarkerId('testMarker'),
            position: LatLng(37.7749, -122.4194), // Example coordinates (San Francisco)
            infoWindow: const InfoWindow(
              title: 'Test Marker',
              snippet: 'This is a test marker',
            ),
          ),
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      )
          : Center(
        child: Text(
          'Location permission is required to show the map',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
