import 'package:chargerrr_flutter/app/modules/stations/controllers/add_station_controller.dart';
import 'package:chargerrr_flutter/app/modules/stations/controllers/station_controller.dart';
import 'package:chargerrr_flutter/app/modules/stations/views/map_picker_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddStationView extends StatefulWidget {
  const AddStationView({super.key});

  @override
  State<AddStationView> createState() => _AddStationViewState();
}

class _AddStationViewState extends State<AddStationView> {
  final StationController stationController = Get.find<StationController>();
  final AddStationController addStationController =
      Get.find<AddStationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Station"),
        backgroundColor: const Color(0xFF89cda4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: addStationController.nameController,
              decoration: const InputDecoration(labelText: "Station Name"),
            ),
            TextField(
              controller: addStationController.addressController,
              decoration: const InputDecoration(labelText: "Address"),
            ),
            TextField(
              controller: addStationController.latController,
              decoration: InputDecoration(
                labelText: "Latitude",
                suffix: InkWell(
                  onTap: () async {
                    final pickedLocation = await Get.toNamed(
                      '/map-picker',
                      arguments: {
                        "lat":
                            double.tryParse(
                              addStationController.latController.text,
                            ) ??
                            37.4219983,
                        "lng":
                            double.tryParse(
                              addStationController.lngController.text,
                            ) ??
                            -122.084,
                      },
                    );

                    if (pickedLocation != null) {
                      addStationController.latController.text = pickedLocation
                          .latitude
                          .toString();
                      addStationController.lngController.text = pickedLocation
                          .longitude
                          .toString();

                      // also update address from coordinates
                      addStationController.fetchAddressFromCoordinates(
                        lat: pickedLocation.latitude,
                        lng: pickedLocation.longitude,
                      );
                      setState(() {});
                    }
                  },
                  child: const Icon(Icons.location_on),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: addStationController.lngController,
              decoration: InputDecoration(
                labelText: "Longitude",
                suffix: InkWell(
                  onTap: () async {
                    final pickedLocation = await Get.toNamed(
                      '/map-picker',
                      arguments: {
                        "lat":
                            double.tryParse(
                              addStationController.latController.text,
                            ) ??
                            37.4219983,
                        "lng":
                            double.tryParse(
                              addStationController.lngController.text,
                            ) ??
                            -122.084,
                      },
                    );

                    if (pickedLocation != null) {
                      addStationController.latController.text = pickedLocation
                          .latitude
                          .toString();
                      addStationController.lngController.text = pickedLocation
                          .longitude
                          .toString();

                      // also update address from coordinates
                      addStationController.fetchAddressFromCoordinates(
                        lat: pickedLocation.latitude,
                        lng: pickedLocation.longitude,
                      );
                      setState(() {});
                    }
                  },
                  child: const Icon(Icons.location_on),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: addStationController.availableController,
              decoration: const InputDecoration(labelText: "Available Points"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: addStationController.totalController,
              decoration: const InputDecoration(labelText: "Total Points"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
              ),
              onPressed: () {
                // Simple checks instead of validators
                if (addStationController.nameController.text.isEmpty ||
                    addStationController.addressController.text.isEmpty ||
                    addStationController.latController.text.isEmpty ||
                    addStationController.lngController.text.isEmpty ||
                    addStationController.availableController.text.isEmpty ||
                    addStationController.totalController.text.isEmpty) {
                  Get.snackbar(
                    "Error",
                    "Please fill all fields",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red[100],
                  );
                  return;
                }

                addStationController.addStation(
                  name: addStationController.nameController.text,
                  address: addStationController.addressController.text,
                  latitude:
                      double.tryParse(
                        addStationController.latController.text,
                      ) ??
                      0.0,
                  longitude:
                      double.tryParse(
                        addStationController.lngController.text,
                      ) ??
                      0.0,
                  availablePoints:
                      int.tryParse(
                        addStationController.availableController.text,
                      ) ??
                      0,
                  totalPoints:
                      int.tryParse(addStationController.totalController.text) ??
                      0,
                  amenities: [], // can add amenities later
                );
                Get.back();
              },
              child: const Text(
                "Add Station",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
