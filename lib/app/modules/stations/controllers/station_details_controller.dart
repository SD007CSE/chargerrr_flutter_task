import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/station_model.dart';

class StationDetailsController extends GetxController {
  var distanceInKm = 0.0.obs;
  var currentPosition = Rx<Position?>(null);
  var markers = <Marker>{}.obs;
  var polylines = <Polyline>{}.obs;

  GoogleMapController? mapController;

  // Initialize location and setup markers + polyline
  Future<void> initLocation(Station station) async {
    try {
      final position = await Geolocator.getCurrentPosition();
      currentPosition.value = position;

      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        station.latitude,
        station.longitude,
      );

      distanceInKm.value = distanceInMeters / 1000;

      markers.value = {
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
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: "You are here"),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
        ),
      };

      polylines.add(Polyline(
        polylineId: const PolylineId("route"),
        points: [
          LatLng(position.latitude, position.longitude),
          LatLng(station.latitude, station.longitude),
        ],
        color: Colors.blue,
        width: 5,
      ));

      // Adjust camera
      if (mapController != null) {
        LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(
            position.latitude < station.latitude
                ? position.latitude
                : station.latitude,
            position.longitude < station.longitude
                ? position.longitude
                : station.longitude,
          ),
          northeast: LatLng(
            position.latitude > station.latitude
                ? position.latitude
                : station.latitude,
            position.longitude > station.longitude
                ? position.longitude
                : station.longitude,
          ),
        );

        mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 80),
        );
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  // Open Google Maps Navigation
  Future<void> openGoogleMaps(double lat, double lng) async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not open Google Maps");
    }
  }
}
