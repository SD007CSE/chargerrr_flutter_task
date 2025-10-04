import 'package:chargerrr_flutter/app/modules/stations/controllers/add_station_controller.dart';
import 'package:chargerrr_flutter/app/modules/stations/controllers/station_controller.dart';
import 'package:chargerrr_flutter/app/modules/stations/controllers/station_details_controller.dart';
import 'package:get/get.dart';

class Stationbindings extends Bindings{
  @override
  void dependencies() {
    Get.put<StationController>(StationController());
    Get.put<StationDetailsController>(StationDetailsController());
    Get.put<AddStationController>(AddStationController());
  }
}