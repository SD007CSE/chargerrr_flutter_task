import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class AddStationController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lngController = TextEditingController();
  final TextEditingController availableController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  var isLoading = false.obs;
  var errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    _setCurrentPosition();
  }

  Future<void> _setCurrentPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      Placemark address = (await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      )).first;
      debugPrint("User position: $position");

      // ✅ Pre-fill the latitude and longitude fields
      latController.text = position.latitude.toString();
      lngController.text = position.longitude.toString();
      addressController.text ="${address.street}, ${address.locality}, ${address.administrativeArea}, ${address.country}";
    } catch (e) {
      errorMessage.value = "Unable to get location: $e";
    }
  }

  void fetchAddressFromCoordinates({double? lat, double? lng}) async {
  final latitude = lat ?? double.tryParse(latController.text) ?? 0.0;
  final longitude = lng ?? double.tryParse(lngController.text) ?? 0.0;

  final placemarks = await placemarkFromCoordinates(latitude, longitude);
  addressController.text = "${placemarks.first.street}, ${placemarks.first.locality}";

}

  

  Future<void> addStation({
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    required int availablePoints,
    required int totalPoints,
    List<String>? amenities,
  }) async {
    try {
      isLoading.value = true;

      // Firebase integration
      await FirebaseFirestore.instance.collection('stations').add({
        'name': name,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'available_points': availablePoints,
        'total_points': totalPoints,
        'amenities': amenities ?? [],
        'created_at': FieldValue.serverTimestamp(),
      });


      debugPrint(
        "Station added: $name, $address, $latitude, $longitude, $availablePoints, $totalPoints",
      );

      Get.snackbar(
        "Success",
        "Station added successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
    } finally {
      isLoading.value = false;
    }
  }
}
