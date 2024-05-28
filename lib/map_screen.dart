import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'database_helper.dart'; // Adjust the import according to your project structure

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  late BitmapDescriptor _markerIcon;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _setCustomMarkerIcon();
  }

  Future<void> _checkPermissions() async {
    if (await Permission.location.request().isGranted) {
      _loadMarkers();
    } else {
      // Handle permission denied case
    }
  }

  Future<void> _setCustomMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/marker.png', // Add a custom marker image to your assets
    );
  }

  Future<void> _loadMarkers() async {
    try {
      final List<Map<String, dynamic>> lostProjects = await DatabaseHelper.instance.getLostProjects();
      setState(() {
        _markers.clear();
        for (final project in lostProjects) {
          final id = project['id']?.toString() ?? 'Unknown';
          final latitude = project['latitude'] != null ? double.parse(project['latitude']) : 0.0;
          final longitude = project['longitude'] != null ? double.parse(project['longitude']) : 0.0;
          final name = project['name'] ?? 'No Name';
          final description = project['description'] ?? 'No Description';

          final marker = Marker(
            markerId: MarkerId(id),
            position: LatLng(latitude, longitude),
            infoWindow: InfoWindow(
              title: name,
              snippet: description,
            ),
            icon: _markerIcon,
          );
          _markers.add(marker);
        }
      });
    } catch (e) {
      print('Error loading markers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.7749, -122.4194), // Set to your desired initial location
          zoom: 10,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
