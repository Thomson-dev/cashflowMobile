import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashflow/app/data/services/auth_service.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

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

  // Show awesome snackbar
  void _showAwesomeSnackbar({
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.only(
        top: 10,
        left: 10,
        right: 10,
      ),
      content: AwesomeSnackbarContent(
        title: title,
        message: "Wrong password or email. Please try again.",
        contentType: contentType,
      ),
    );

    ScaffoldMessenger.of(Get.context!)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
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

        // Navigate to home first
        Get.offAllNamed('/main');

        // Show success message after navigation
        Future.delayed(const Duration(milliseconds: 300), () {
          _showAwesomeSnackbar(
            title: 'Success!',
            message: response['message'] ?? 'Login successful! Welcome back.',
            contentType: ContentType.success,
          );
        });

      } catch (e) {
        _showAwesomeSnackbar(
          title: 'Error!',
          message: e.toString().replaceAll('Exception: ', ''),
          contentType: ContentType.failure,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Forgot password
  void forgotPassword() {
    _showAwesomeSnackbar(
      title: 'Coming Soon!',
      message: 'Forgot password functionality will be available soon.',
      contentType: ContentType.help,
    );
  }

  // Navigate to register
  void navigateToRegister() {
    Get.toNamed('/register');
  }
}
