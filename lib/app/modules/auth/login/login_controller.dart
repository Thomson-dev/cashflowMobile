import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashflow/app/data/services/auth_service.dart';

class LoginController extends GetxController {
  // Services
  final AuthService _authService = AuthService();
  
  // Form key
  final formKey = GlobalKey<FormState>();
  
  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Observables
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var rememberMe = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Toggle remember me
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  // Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 4) {
      return 'Password must be at least 4 characters';
    }
    return null;
  }

  // Login
  Future<void> login() async {
    if (formKey.currentState?.validate() ?? false) {
      try {
        isLoading.value = true;

        final response = await _authService.login(
          emailController.text.trim(),
          passwordController.text,
        );

        // Show success message
        Get.snackbar(
          'Success',
          response['message'] ?? 'Login successful!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );

        // Navigate to home
        Get.offAllNamed('/main');

      } catch (e) {
        Get.snackbar(
          'Error',
          e.toString().replaceAll('Exception: ', ''),
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Forgot password
  void forgotPassword() {
    // TODO: Implement forgot password
    Get.snackbar(
      'Info',
      'Forgot password functionality coming soon',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Navigate to register
  void navigateToRegister() {
    Get.toNamed('/register');
  }
}
