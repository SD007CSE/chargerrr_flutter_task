import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    // Receive lat/lng from Get.arguments
    final args = Get.arguments as Map<String, dynamic>;
    final double initialLat = args["lat"] ?? 37.4219983;
    final double initialLng = args["lng"] ?? -122.084;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Location"),
        backgroundColor: const Color(0xFF89cda4),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (_pickedLocation != null) {
                Get.back(result: _pickedLocation); // return location
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Tap on the map to pick a location")),
                );
              }
            },
          )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(initialLat, initialLng),
          zoom: 14,
        ),
        onTap: (LatLng position) {
          setState(() {
            _pickedLocation = position;
          });
        },
        markers: _pickedLocation == null
            ? {}
            : {
                Marker(
                  markerId: const MarkerId("pickedLocation"),
                  position: _pickedLocation!,
                ),
              },
      ),
    );
  }
}
