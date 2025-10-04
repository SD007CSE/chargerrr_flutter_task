// ignore_for_file: file_names
import 'package:chargerrr_flutter/app/modules/stations/controllers/login_controller.dart';
import 'package:chargerrr_flutter/app/modules/stations/controllers/signup_controller.dart';
import 'package:get/get.dart';

class Loginbindings extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
    Get.lazyPut<SignupController>(() => SignupController());
  }
}