import 'package:chargerrr_flutter/app/modules/stations/controllers/station_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final StationController stationController = Get.find<StationController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF89cda4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.ev_station, size: 48, color: Color(0xFF89cda4)),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Chargerrr India',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                stationController.logout();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.ev_station_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text("EV Charging Stations", style: TextStyle(color: Colors.white)),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF89cda4),
        
      ),
      body: Obx(() {
        if (stationController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (stationController.errorMessage.isNotEmpty) {
          return Center(child: Text(stationController.errorMessage.value));
        }
        if (stationController.stations.isEmpty) {
          return const Center(child: Text("No stations available"));
        }

        return RefreshIndicator(
          onRefresh: () => stationController.fetchStations(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: stationController.stations.length,
            itemBuilder: (context, index) {
              final station = stationController.stations[index];
              final int availablePoints = station.availablePoints;
              final int totalPoints = station.totalPoints;
              final double progress = totalPoints > 0
                  ? availablePoints / totalPoints
                  : 0.0;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.green.shade50],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    if (stationController.locationPermissionGranted.value) {
                      Get.toNamed('/station-details', arguments: station);
                    } else {
                      stationController.checkPermission();
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ✅ Show Map only if permission granted
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: SizedBox(
                          height: 180,
                          child:
                              stationController.locationPermissionGranted.value
                              ? GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                      station.latitude,
                                      station.longitude,
                                    ),
                                    zoom: 14,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: MarkerId(station.id),
                                      position: LatLng(
                                        station.latitude,
                                        station.longitude,
                                      ),
                                      infoWindow: InfoWindow(
                                        title: station.name,
                                        snippet: station.address,
                                      ),
                                    ),
                                  },
                                  zoomControlsEnabled: false,
                                  myLocationButtonEnabled: false,
                                  liteModeEnabled: true,
                                )
                              : Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Text(
                                      "Enable location permission to view map.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      // Station info
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.greenAccent.shade100,
                              child: const Icon(
                                Icons.ev_station,
                                color: Colors.green,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    station.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    station.address,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 8,
                                      backgroundColor: Colors.grey[300],
                                      color: const Color(0xFF89cda4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              children: [
                                Text(
                                  "$availablePoints",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: availablePoints > 0
                                        ? Colors.green[700]
                                        : Colors.red[700],
                                  ),
                                ),
                                Text(
                                  "/$totalPoints",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade600,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Get.toNamed('/add-station'),
      ),
    );
  }
}
