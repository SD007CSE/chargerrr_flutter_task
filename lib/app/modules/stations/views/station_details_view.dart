import 'package:chargerrr_flutter/app/modules/stations/models/station_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StationDetailsView extends StatefulWidget {
  const StationDetailsView({super.key});

  @override
  State<StationDetailsView> createState() => _StationDetailsViewState();
}

class _StationDetailsViewState extends State<StationDetailsView> {
  double? _distanceInKm;
  Position? _currentPosition;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};



  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final Station station = Get.arguments as Station;
    try {
      // Get current location
      _currentPosition = await Geolocator.getCurrentPosition();

      double distanceInMeters = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        station.latitude,
        station.longitude,
      );

      setState(() {
        _distanceInKm = distanceInMeters / 1000;
        _markers = {
          Marker(
            markerId: const MarkerId("station"),
            position: LatLng(station.latitude, station.longitude),
            infoWindow: InfoWindow(
              title: station.name,
              snippet: station.address,
            ),
          ),
          Marker(
            markerId: const MarkerId("user"),
            position: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
            infoWindow: const InfoWindow(title: "You are here"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          ),
        };
        _polylines.add(Polyline(
          polylineId: const PolylineId("route"),
          points: [
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            LatLng(station.latitude, station.longitude),
          ],
          color: Colors.blue,
          width: 5,
        ));
      });

      // ✅ Adjust camera to show both points
      if (_mapController != null) {
        LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(
            _currentPosition!.latitude < station.latitude
                ? _currentPosition!.latitude
                : station.longitude,
            _currentPosition!.longitude < station.longitude
                ? _currentPosition!.longitude
                : station.longitude,
          ),
          northeast: LatLng(
            _currentPosition!.latitude > station.latitude
                ? _currentPosition!.latitude
                : station.latitude,
            _currentPosition!.longitude > station.longitude
                ? _currentPosition!.longitude
                : station.longitude,
          ),
        );

        _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 80), // 80 = padding
        );
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> _openGoogleMaps(double lat, double lng) async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      print("Could not open Google Maps");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Station station = Get.arguments;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            polylines: _polylines,
            initialCameraPosition: CameraPosition(
              target: LatLng(station.latitude, station.longitude),
              zoom: 14,
            ),
            myLocationEnabled: true, // ✅ shows blue dot for user
            markers: _markers,
            onMapCreated: (controller) => _mapController = controller,
          ),
          // Back Button
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Get.offAllNamed('/home'),
              ),
            ),
          ),
          // Bottom Info Panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station.name,
                    style: GoogleFonts.ptSerif(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    station.address,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 12),
                  if (_distanceInKm != null)
                    Row(
                      children: [
                        const Icon(Icons.directions, color: Colors.blueAccent),
                        const SizedBox(width: 6),
                        Text(
                          "${_distanceInKm!.toStringAsFixed(2)} km away",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _openGoogleMaps(
                      station.latitude,
                      station.longitude,
                    ),
                    icon: const Icon(Icons.navigation),
                    label: const Text("Navigate with Google Maps"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
