import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signup() async {
    final name = nameController.text.trim();
    
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    } else if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    } else if (password.length < 6) {
      Get.snackbar("Error", "Password should be at least 6 characters");
      return;
    } else if (!GetUtils.isEmail(email)) {
      Get.snackbar("Error", "Please enter a valid email");
      return;
    } else {
      // Proceed with signup logic (e.g., API call)
      try {
        await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } on FirebaseAuthException catch (e) {
        String message = "An error occurred";
        if (e.code == 'email-already-in-use') {
          message = "The email is already in use";
        } else if (e.code == 'invalid-email') {
          message = "The email is invalid";
        } else if (e.code == 'operation-not-allowed') {
          message = "Operation not allowed";
        } else if (e.code == 'weak-password') {
          message = "The password is too weak";
        }
        Get.snackbar("Error", message);
        return;
      } catch (e) {
        Get.snackbar("Error", "An unexpected error occurred");
        return;
      }
      // For demonstration, we'll just show a success message
      Get.snackbar("Success", "Signup successful for $name");
      Get.offAllNamed("/login");
      // Clear the fields
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    }
  }
}
