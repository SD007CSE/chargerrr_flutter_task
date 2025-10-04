import 'package:chargerrr_flutter/app/bindings/login_bindings.dart';
import 'package:chargerrr_flutter/app/bindings/station_bindings.dart';
import 'package:chargerrr_flutter/app/modules/stations/views/add_station_view.dart';
import 'package:chargerrr_flutter/app/modules/stations/views/home_view.dart';
import 'package:chargerrr_flutter/app/modules/stations/views/map_picker_view.dart';
import 'package:chargerrr_flutter/app/modules/stations/views/sign_up_view.dart';
import 'package:chargerrr_flutter/app/modules/stations/views/station_details_view.dart';
import 'package:get/get.dart';
import 'package:chargerrr_flutter/app/modules/stations/views/login_view.dart';
import 'package:get/route_manager.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: Loginbindings(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => SignUpView(),
      // binding: SignUpBindings(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(), // Replace with HomeView when created
      binding: Stationbindings(),
    ),
    GetPage(
      name: Routes.STATION_DETAILS,
      page: () => StationDetailsView(),
      // binding: StationDetailsBindings(),
    ),
    GetPage(
      name: Routes.ADD_STATION,
      page: () => const AddStationView(),
      // binding: AddStationBindings(),
    ),
    GetPage(
      name: Routes.MAP_PICKER,
      page: () => const MapPickerPage(),
      // binding: MapPickerBindings(),
    ),
  ];
}