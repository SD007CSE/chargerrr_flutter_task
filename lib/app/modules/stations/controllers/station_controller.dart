import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/station_model.dart';

class StationController extends GetxController {
  var stations = <Station>[].obs;
  var isLoading = true.obs;
  var errorMessage = "".obs;
  var locationPermissionGranted = false.obs;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final db = FirebaseFirestore.instance;


  @override
  void onInit() {
    super.onInit();
    fetchStations();
    checkPermission();
  }

  Future<void> fetchStations() async {
    try {
      isLoading(true);
      QuerySnapshot snapshot = await db.collection('stations').get();
      var result = snapshot.docs
          .map((doc) => Station.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      stations.assignAll(result);
    } catch (e) {
      errorMessage(e.toString());
    } finally {
      isLoading(false);
    }
  }
  Future<void> checkPermission() async {
    final status = await Permission.location.status;

    if (status.isGranted) {
      locationPermissionGranted(true);
    } else if (status.isDenied) {
      final requestStatus = await Permission.location.request();
      locationPermissionGranted(requestStatus.isGranted);
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      locationPermissionGranted(status.isGranted);
    }
  }

  Future<void> logout() async {
    await auth.signOut();
    Get.offAllNamed('/login');
  }

}
