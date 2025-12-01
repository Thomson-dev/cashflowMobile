import 'package:cashflow/app/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:get/get.dart';

class InsightController extends GetxController {
  final AuthService _authService = AuthService();

  // Reactive state variables
  final Rx<Map<String, dynamic>> insights = Rx<Map<String, dynamic>>({});
  final Rx<Map<String, dynamic>> aiInsights = Rx<Map<String, dynamic>>({});
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInsights();
  }

  /// Fetch insights from API
  Future<void> fetchInsights() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _authService.getInsights();

      if (response['insights'] != null) {
        insights.value = response['insights'];
      }

      if (response['aiInsights'] != null) {
        aiInsights.value = response['aiInsights'];
      }
    } catch (e) {
      errorMessage.value = 'Failed to load insights: ${e.toString()}';
      _showAwesomeSnackbar(
        title: 'Error!',
        message: 'Failed to load insights',
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh insights data
  Future<void> refreshInsights() async {
    try {
      isRefreshing.value = true;
      errorMessage.value = '';

      final response = await _authService.getInsights();

      if (response['insights'] != null) {
        insights.value = response['insights'];
      }

      if (response['aiInsights'] != null) {
        aiInsights.value = response['aiInsights'];
      }
    } catch (e) {
      errorMessage.value = 'Failed to refresh insights: ${e.toString()}';
      _showAwesomeSnackbar(
        title: 'Error!',
        message: 'Failed to refresh insights',
        contentType: ContentType.failure,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Check if insights data is available
  bool get hasInsights => insights.value.isNotEmpty || aiInsights.value.isNotEmpty;

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
