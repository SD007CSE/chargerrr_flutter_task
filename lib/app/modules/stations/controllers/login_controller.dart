import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  var isLoading = false.obs; // ✅ observable loading state

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and password are required");
      return;
    } else if (!GetUtils.isEmail(email)) {
      Get.snackbar("Error", "Please enter a valid email");
      return;
    } else if (password.length < 6) {
      Get.snackbar("Error", "Password should be at least 6 characters");
      return;
    } else {
      try {
        isLoading.value = true; // ✅ show loader

        await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        Get.snackbar("Success", "Login successful for $email");
        Get.offAllNamed("/home");
      } catch (e) {
        Get.snackbar("Error", "An unexpected error occurred");
      } finally {
        isLoading.value = false; // ✅ hide loader
      }
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
