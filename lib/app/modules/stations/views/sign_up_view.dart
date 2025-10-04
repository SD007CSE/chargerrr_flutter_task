import 'package:chargerrr_flutter/app/common/widgets/common_textField.dart';
import 'package:chargerrr_flutter/app/modules/stations/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final SignupController controller = SignupController();

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo / Icon
              Image.asset('assets/images/AppIcon01.png', height: 170),
              const SizedBox(height: 20),

              // Title
              Text(
                "Create Account",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF89cda4),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Sign up to get started",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),

              // Full Name
              CommonTextfield(
                hintText: "Full Name",
                prefixIcon: Icons.person_outline,
                isPassword: false,
                controller: controller.nameController,
              ),
              const SizedBox(height: 16),

              // Email
              CommonTextfield(
                hintText: "Email",
                prefixIcon: Icons.email_outlined,
                isPassword: false,
                controller: controller.emailController,
              ),
              const SizedBox(height: 16),

              // Password
              CommonTextfield(
                hintText: "Password",
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: controller.passwordController,
              ),
              const SizedBox(height: 16),

              // Confirm Password
              CommonTextfield(
                hintText: "Confirm Password",
                prefixIcon: Icons.lock_reset,
                isPassword: true,
                controller: controller.confirmPasswordController,
              ),
              const SizedBox(height: 30),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.green.shade500,
                  ),
                  onPressed: () {
                    controller.signup();
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // OR Divider
              Row(
                children: [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("OR"),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),
              const SizedBox(height: 20),

              // Social Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.facebook, color: Colors.blue, size: 32),
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.g_mobiledata, color: Colors.red, size: 38),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Already Have Account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Get.offNamed('/login'); // Go back to Login
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Color(0xFF89cda4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
