import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cashflow/app/data/services/storage_service.dart';

class SettingsController extends GetxController {
  final biometricEnabled = false.obs;
  final twoFactorEnabled = false.obs;
  final notificationsEnabled = true.obs;
  final isLoading = false.obs;

  void updateBiometric(bool value) {
    biometricEnabled.value = value;
    // TODO: Save to SharedPreferences
  }

  void updateTwoFactor(bool value) {
    twoFactorEnabled.value = value;
    // TODO: Save to SharedPreferences
  }

  void updateNotifications(bool value) {
    notificationsEnabled.value = value;
    // TODO: Save to SharedPreferences
  }

  void navigateToChangePassword() {
    _showAwesomeSnackbar(
      title: 'Change Password',
      message: 'Navigate to change password screen',
      contentType: ContentType.help,
    );
  }

  void navigateToNotifications() {
    _showAwesomeSnackbar(
      title: 'Email Notifications',
      message: 'Navigate to notifications screen',
      contentType: ContentType.help,
    );
  }

  void navigateToLanguage() {
    _showAwesomeSnackbar(
      title: 'Language',
      message: 'Navigate to language selection',
      contentType: ContentType.help,
    );
  }

  void navigateToTheme() {
    _showAwesomeSnackbar(
      title: 'Theme',
      message: 'Navigate to theme selection',
      contentType: ContentType.help,
    );
  }

  void navigateToAbout() {
    _showAwesomeSnackbar(
      title: 'About App',
      message: 'Navigate to about screen',
      contentType: ContentType.help,
    );
  }

  void navigateToTerms() {
    _showAwesomeSnackbar(
      title: 'Terms & Conditions',
      message: 'Navigate to terms screen',
      contentType: ContentType.help,
    );
  }

  void navigateToPrivacy() {
    _showAwesomeSnackbar(
      title: 'Privacy Policy',
      message: 'Navigate to privacy screen',
      contentType: ContentType.help,
    );
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;

      // Clear all local storage/data
      final storageService = StorageService();
      await storageService.clearAll();

      // Navigate to login screen
      Get.offAllNamed('/login');

      // Show success message
      _showAwesomeSnackbar(
        title: 'Success!',
        message: 'You have been logged out successfully',
        contentType: ContentType.success,
      );
    } catch (e) {
      _showAwesomeSnackbar(
        title: 'Error!',
        message: 'Failed to logout: $e',
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Show awesome snackbar
  void _showAwesomeSnackbar({
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
          message: message,
          contentType: contentType,
        ),
      );
      ScaffoldMessenger.of(Get.context!)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    });
  }
}
